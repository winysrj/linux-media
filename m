Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1181 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbaC3MDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 08:03:22 -0400
Message-ID: <533807FC.5050008@xs4all.nl>
Date: Sun, 30 Mar 2014 14:03:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Christopher Li <sparse@chrisli.org>
CC: Linux-Sparse <linux-sparse@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: sparse: ARRAY_SIZE and sparse array initialization
References: <532442E2.7050206@xs4all.nl>	<532443AB.9080105@xs4all.nl>	<533553E6.3060508@xs4all.nl> <CANeU7Qksj-tq0fjsZya1otX75sV4JOsAdXHr5Kxu-WyvYrksSw@mail.gmail.com>
In-Reply-To: <CANeU7Qksj-tq0fjsZya1otX75sV4JOsAdXHr5Kxu-WyvYrksSw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On 03/30/2014 08:10 AM, Christopher Li wrote:
> On Fri, Mar 28, 2014 at 3:50 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Is there any chance that the three issues I reported will be fixed? If not,
>> then I'll work around it in the kernel code.
>>
> 
> Most likely it is a sparse issue. Can you generate a minimal stand alone
> test case that expose this bug? I try to simplify it as following, but
> it does not
> reproduce the error.
> 
> 
> #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
> 
> static const char *v4l2_type_names[] = {
>         [1]    = "mmap",
>         [9] = "userptr",
>         [2] = "overlay",
>         [3] = "dmabuf",
> };
> 
> #define prt_names(a, arr) (((unsigned)(a)) < ARRAY_SIZE(arr) ? arr[a]
> : "unknown")
> 
> 
> extern void prt(const char *name);
> 
> static void v4l_print_requestbuffers(const void *arg, int write_only)
> {
>         const struct v4l2_requestbuffers *p = arg;
> 
>         prt(prt_names(3, v4l2_type_names));
> }
> 
> 
> If you have the test case, you are welcome to submit a patch to
> add the test case.

I experimented a bit more and it turned out that the use of EXPORT_SYMBOL
for the array is what causes the problem. Reproducible with this:

#include <linux/kernel.h>

#define prt_names(a, arr) (((unsigned)(a)) < ARRAY_SIZE(arr) ? arr[a] : "unknown")

extern const char *v4l2_names[];

const char *v4l2_names[] = {
        [1]    = "mmap",
        [9] = "userptr",
        [2] = "overlay",
        [3] = "dmabuf",
};
EXPORT_SYMBOL(v4l2_names);

extern void prt(const char *name);

static void v4l_print_requestbuffers(const void *arg, int write_only)
{
        prt(prt_names(3, v4l2_names));
}


And with this sparse command:

sparse  -nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.8/include -Iarch/x86/include -Iarch/x86/include/generated  -Iinclude -Iarch/x86/include/uapi -Iarch/x86/include/generated/uapi -Iinclude/uapi -Iinclude/generated/uapi -include include/linux/kconfig.h -D__KERNEL__ x.c

If I remove EXPORT_SYMBOL all is well. EXPORT_SYMBOL expands to this:

extern typeof(v4l2_names) v4l2_names;
extern __attribute__((externally_visible)) void *__crc_v4l2_names __attribute__((weak));
static const unsigned long __kcrctab_v4l2_names __attribute__((__used__)) __attribute__((section("___kcrctab" "" "+" "v4l2_names"), unused)) = (unsigned long) &__crc_v4l2_names;
static const char __kstrtab_v4l2_names[] __attribute__((section("__ksymtab_strings"), aligned(1))) = "v4l2_names";
extern const struct kernel_symbol __ksymtab_v4l2_names;
__attribute__((externally_visible)) const struct kernel_symbol __ksymtab_v4l2_names __attribute__((__used__)) __attribute__((section("___ksymtab" "" "+" "v4l2_names"), unused)) = { (unsigned long)&v4l2_names, __kstrtab_v4l2_names };

I did some more research and the key is the first line: 

extern typeof(v4l2_names) v4l2_names;

If I add that to your test case:

static const char *v4l2_type_names[] = {
        [1]    = "mmap",
        [9] = "userptr",
        [2] = "overlay",
        [3] = "dmabuf",
};
extern typeof(v4l2_type_names) v4l2_type_names;

Then I get the same error with your test case.

The smallest test case I can make is this:

====== extern-array.c ======
extern const char *v4l2_type_names[];
const char *v4l2_type_names[] = {
        "test"
};
extern const char *v4l2_type_names[];

static void test(void)
{
	unsigned sz = sizeof(v4l2_type_names);
}
/*
 * check-name: duplicate extern array
 *
 * check-error-start
 * check-error-end
 */
====== extern-array.c ======

If I leave out the both 'extern' declarations I get:

warning: symbol 'v4l2_type_names' was not declared. Should it be static?

Which is a correct warning.

If I leave out the second 'extern' only, then all is fine. If I add both
'extern' declarations, then I get:

error: cannot size expression

which is clearly a sparse bug somewhere.

Regards,

	Hans
