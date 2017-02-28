Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34900 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdB1I2x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 03:28:53 -0500
MIME-Version: 1.0
In-Reply-To: <20170228010803.GA7977@dell-m4800.Home>
References: <20170227203252.3295528-1-arnd@arndb.de> <20170228010803.GA7977@dell-m4800.Home>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 28 Feb 2017 09:20:53 +0100
Message-ID: <CAK8P3a0GgrDsQeCzXJvRn+a5u1JavVhRZ+7q7ztYrTP2W5XoNw@mail.gmail.com>
Subject: Re: [PATCH] [media] tw5864: handle unknown video std gracefully
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrey Utkin <andrey_utkin@fastmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 28, 2017 at 2:08 AM, Andrey Utkin
<andrey.utkin@corp.bluecherry.net> wrote:
> Hi Arnd,
>
> Thanks for sending this patch.
>
> On Mon, Feb 27, 2017 at 09:32:34PM +0100, Arnd Bergmann wrote:
>> tw5864_frameinterval_get() only initializes its output when it successfully
>> identifies the video standard in tw5864_input. We get a warning here because
>> gcc can't always track the state if initialized warnings across a WARN()
>> macro, and thinks it might get used incorrectly in tw5864_s_parm:
>>
>> media/pci/tw5864/tw5864-video.c: In function 'tw5864_s_parm':
>> media/pci/tw5864/tw5864-video.c:816:38: error: 'time_base.numerator' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>> media/pci/tw5864/tw5864-video.c:819:31: error: 'time_base.denominator' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>
> I think behaviour of tw5864_frameinterval_get() is ok.
> I don't see how WARN() could affect gcc state tracking. There's "return
> -EINVAL" right after WARN() which lets caller handle the failure case
> gracefully. Maybe I just don't see how confusing WARN() can be for gcc
> in this situation, but it's not as confusing as BUG() would be, right?

The problem is on architectures that use "unlikely()" within WARN(),
in combination with CONFIG_PROFILE_ANNOTATED_BRANCHES().

That option invokes this macro:


#define __branch_check__(x, expect) ({                                  \
                        int ______r;                                    \
                        static struct ftrace_likely_data                \
                                __attribute__((__aligned__(4)))         \

__attribute__((section("_ftrace_annotated_branch"))) \
                                ______f = {                             \
                                .data.func = __func__,                  \
                                .data.file = __FILE__,                  \
                                .data.line = __LINE__,                  \
                        };                                              \
                        ______r = likely_notrace(x);                    \
                        ftrace_likely_update(&______f, ______r, expect); \
                        ______r;                                        \
                })

and after the condition has been passed through it, gcc is sufficiently
confused that it forgets everything about which variables have been
initialized and which haven't based on the condition.

> I see the reason of that warning is
>
>  - time_base being not initialized in tw5864_s_parm()
>  - gcc being too dumb to recognize that we have checked the retcode in
>    tw5864_s_parm() and proceed only when we are sure we have correctly
>    initialized time_base.
>
> Is that you compiling with manually added -Werror=maybe-uninitialized or
> is that default compilation flags? I don't remember encountering that
> and I doubt a lot of kernel code compiles without warnings with such
> flag.

I build with -Werror locally to turn all warnings into errors,
-Wmaybe-uninitialized
is turned on by default with gcc-4.9 and higher.

> Also, which GCC version are you using?

I see this happening on arm64 with gcc-5.2.1, gcc-6.3.1 and gcc-7.0.1,
but not with gcc-4.9.3.

I did not run into this one on arm or x86 with any of the above compiler
versions during randconfig testing.

>> This particular use happens to be ok, but we do copy the uninitialized
>> output of tw5864_frameinterval_get() into other memory without checking
>> the return code, interestingly without getting a warning here.
>
> Retcode checking takes place everywhere, but currently it overwrites
> supplied structs with potentially-uninitialized values. To make it
> cleaner, it should be (e.g. tw5864_g_parm())
>
> ret = tw5864_frameinterval_get(input, &cp->timeperframe);
> if (ret)
>         return ret;
> cp->timeperframe.numerator *= input->frame_interval;
> cp->capturemode = 0;
> cp->readbuffers = 2;
> return 0;
>
> and not
>
> ret = tw5864_frameinterval_get(input, &cp->timeperframe);
> cp->timeperframe.numerator *= input->frame_interval;
> cp->capturemode = 0;
> cp->readbuffers = 2;
> return ret;
>
> That would resolve your concerns of uninitialized values propagation
> without writing bogus values 1/1 in case of failure. I think I'd
> personally prefer a called function to leave my data structs intact when
> it fails.

That seems reasonable, I can try to come up with a new version that
incorporates this change, but I haven't been able to avoid the warning
without either removing the WARN() or adding an initialization.

>> This initializes the output to 1/1s for the case, to make sure we do
>> get an intialization that doesn't cause a division-by-zero exception
>> in case we end up using this uninitialized data later.
>
> Personally I won't object against such patch, but I find it a bit too
> much "defensive" for kernel coding taste.
>
> Making sure somebody who doesn't check return codes don't get a crash is
> traditionally not considered a valid concern AFAIK.
>
> Please let me know what you think about this.

I'm mainly interested in fixing the compiler warning on arm64, since
I think we should have a warning. I try hard to address any related
problems at the same time, and in this case it seemed justify to
prepare for the other modes since the header defines additional
modes that are not covered and I could not see anything preventing
us from setting them:

enum tw5864_vid_std {
        STD_NTSC = 0, /* NTSC (M) */
        STD_PAL = 1, /* PAL (B, D, G, H, I) */
        STD_SECAM = 2, /* SECAM */
        STD_NTSC443 = 3, /* NTSC4.43 */
        STD_PAL_M = 4, /* PAL (M) */
        STD_PAL_CN = 5, /* PAL (CN) */
        STD_PAL_60 = 6, /* PAL 60 */
        STD_INVALID = 7,
        STD_AUTO = 7,
};

     Arnd
