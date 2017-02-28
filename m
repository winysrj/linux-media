Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38443 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdB1BSH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 20:18:07 -0500
Received: by mail-wm0-f54.google.com with SMTP id u199so164337wmd.1
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2017 17:17:07 -0800 (PST)
Date: Tue, 28 Feb 2017 01:08:03 +0000
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Utkin <andrey_utkin@fastmail.com>
Subject: Re: [PATCH] [media] tw5864: handle unknown video std gracefully
Message-ID: <20170228010803.GA7977@dell-m4800.Home>
References: <20170227203252.3295528-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170227203252.3295528-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thanks for sending this patch.

On Mon, Feb 27, 2017 at 09:32:34PM +0100, Arnd Bergmann wrote:
> tw5864_frameinterval_get() only initializes its output when it successfully
> identifies the video standard in tw5864_input. We get a warning here because
> gcc can't always track the state if initialized warnings across a WARN()
> macro, and thinks it might get used incorrectly in tw5864_s_parm:
> 
> media/pci/tw5864/tw5864-video.c: In function 'tw5864_s_parm':
> media/pci/tw5864/tw5864-video.c:816:38: error: 'time_base.numerator' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> media/pci/tw5864/tw5864-video.c:819:31: error: 'time_base.denominator' may be used uninitialized in this function [-Werror=maybe-uninitialized]

I think behaviour of tw5864_frameinterval_get() is ok.
I don't see how WARN() could affect gcc state tracking. There's "return
-EINVAL" right after WARN() which lets caller handle the failure case
gracefully. Maybe I just don't see how confusing WARN() can be for gcc
in this situation, but it's not as confusing as BUG() would be, right?

I see the reason of that warning is 

 - time_base being not initialized in tw5864_s_parm()
 - gcc being too dumb to recognize that we have checked the retcode in
   tw5864_s_parm() and proceed only when we are sure we have correctly
   initialized time_base.

Is that you compiling with manually added -Werror=maybe-uninitialized or
is that default compilation flags? I don't remember encountering that
and I doubt a lot of kernel code compiles without warnings with such
flag.

Also, which GCC version are you using?

> This particular use happens to be ok, but we do copy the uninitialized
> output of tw5864_frameinterval_get() into other memory without checking
> the return code, interestingly without getting a warning here.

Retcode checking takes place everywhere, but currently it overwrites
supplied structs with potentially-uninitialized values. To make it
cleaner, it should be (e.g. tw5864_g_parm())

ret = tw5864_frameinterval_get(input, &cp->timeperframe);
if (ret)
        return ret;
cp->timeperframe.numerator *= input->frame_interval;
cp->capturemode = 0;
cp->readbuffers = 2;
return 0;

and not

ret = tw5864_frameinterval_get(input, &cp->timeperframe);
cp->timeperframe.numerator *= input->frame_interval;
cp->capturemode = 0;
cp->readbuffers = 2;
return ret;

That would resolve your concerns of uninitialized values propagation
without writing bogus values 1/1 in case of failure. I think I'd
personally prefer a called function to leave my data structs intact when
it fails.

> 
> This initializes the output to 1/1s for the case, to make sure we do
> get an intialization that doesn't cause a division-by-zero exception
> in case we end up using this uninitialized data later.

Personally I won't object against such patch, but I find it a bit too
much "defensive" for kernel coding taste.

Making sure somebody who doesn't check return codes don't get a crash is
traditionally not considered a valid concern AFAIK.

Please let me know what you think about this.
