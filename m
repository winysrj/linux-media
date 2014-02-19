Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:46439 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaBSFWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 00:22:33 -0500
MIME-Version: 1.0
In-Reply-To: <20140218085651.GL26722@mwanda>
References: <20140206092800.GB31780@elgon.mountain>
	<CAHFNz9LMU0X2YsqniY+6VOS_mM-jUfAvP2sF5MFNdwWWwEVgsw@mail.gmail.com>
	<20140218085651.GL26722@mwanda>
Date: Wed, 19 Feb 2014 10:52:32 +0530
Message-ID: <CAHFNz9LUP4UVROk5RWW_-=LQ5=gC8__zD67aLxNq7bHUMgipCQ@mail.gmail.com>
Subject: Re: [patch] [media] stv090x: remove indent levels
From: Manu Abraham <abraham.manu@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 18, 2014 at 2:26 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Feb 18, 2014 at 09:25:36AM +0530, Manu Abraham wrote:
>> Hi Dan,
>>
>> On Thu, Feb 6, 2014 at 2:58 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> > 1) We can flip the "if (!lock)" check to "if (lock) return lock;" and
>> >    then remove a big chunk of indenting.
>> > 2) There is a redundant "if (!lock)" which we can remove since we
>> >    already know that lock is zero.  This removes another indent level.
>>
>>
>> The stv090x driver is a mature, but slightly complex driver supporting
>> quite some
>> different configurations. Is it that some bug you are trying to fix in there ?
>> I wouldn't prefer unnecessary code churn in such a driver for
>> something as simple
>> as gain in an indentation level.
>
> I thought the cleanup was jusitification enough, but the real reason I
> wrote this patch is that testing:
>
>         if (!lock) {
>                 if (!lock) {
>
> sets off a static checker warning.  That kind of code is puzzling and if
> we don't clean it up then it wastes a lot of reviewer time.
>
> Also when you're reviewing these patches please consider that the
> original code might be buggy and not simply messy.  Perhaps something
> other than "if (!lock) {" was intended?
>

I can't seem to find the possible bug in there..

The code:

lock = fn();
if (!lock) {
     if (condition1) {
           lock = fn()
     } else {
           if (!lock) {
           }
     }
}

looks harmless to me, AFAICS. Also, please do note that, if the
function coldlock exits due to some reason for not finding valid symbols,
stv090x_search is again fired up from the kernel frontend thread.
It is easy to make such cleanup patches and cause breakages, but a
lot time consuming to fix such issues. My 2c.

Best Regards,

Manu
