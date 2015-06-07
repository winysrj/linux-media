Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:45729 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbbFGIvV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 04:51:21 -0400
Message-ID: <557405F7.3050908@xs4all.nl>
Date: Sun, 07 Jun 2015 10:51:03 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH 01/10] sh-vou: hook up the clock correctly
References: <1433501966-30176-1-git-send-email-hverkuil@xs4all.nl>	<1433501966-30176-2-git-send-email-hverkuil@xs4all.nl> <CAMuHMdUYA=WOnHMXLnm0kMy6-tmR1sKJDeC4F7XUW5_cJ7PWyg@mail.gmail.com>
In-Reply-To: <CAMuHMdUYA=WOnHMXLnm0kMy6-tmR1sKJDeC4F7XUW5_cJ7PWyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2015 11:42 PM, Geert Uytterhoeven wrote:
> Hi Hans,
> 
> On Fri, Jun 5, 2015 at 12:59 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Bitrot has set in for this driver and the sh-vou.0 clock was never enabled,
>> so this driver didn't do anything. In addition, the clock was incorrectly
>> defined in clock-sh7724.c. Fix this.
> 
> I think the clock should be enabled automatically using Runtime PM.
> drivers/sh/pm_runtime.c should configure the "NULL" (i.e. the first) clock
> for power management, after which pm_runtime_get_sync() will enable it.

Ah, that works too after I fixed a small bug in sh_vou_release (status should
have been reset to SH_VOU_INITIALISING).

>> While we're at it: use proper resource managed calls.
> 
> Shouldn't that be a separate patch? Especially if the real fix becomes a
> one-liner (see below).

I'll split it up.

>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Magnus Damm <damm@opensource.se>
>> ---
>>  arch/sh/kernel/cpu/sh4a/clock-sh7724.c |  2 +-
>>  drivers/media/platform/sh_vou.c        | 54 ++++++++++++----------------------
>>  2 files changed, 20 insertions(+), 36 deletions(-)
>>
>> diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7724.c b/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
>> index c187b95..f1df899 100644
>> --- a/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
>> +++ b/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
>> @@ -343,7 +343,7 @@ static struct clk_lookup lookups[] = {
>>         CLKDEV_CON_ID("2ddmac0", &mstp_clks[HWBLK_2DDMAC]),
>>         CLKDEV_DEV_ID("sh_fsi.0", &mstp_clks[HWBLK_SPU]),
>>         CLKDEV_CON_ID("jpu0", &mstp_clks[HWBLK_JPU]),
>> -       CLKDEV_DEV_ID("sh-vou.0", &mstp_clks[HWBLK_VOU]),
>> +       CLKDEV_CON_ID("sh-vou.0", &mstp_clks[HWBLK_VOU]),
> 
> I don't know which SH board you have, but both
> arch/sh/boards/mach-ecovec24/setup.c and
> arch/sh/boards/mach-se/7724/setup.c create the platform device as:

I have a R0P7724LC0011/21RL (mach-ecovec24 based) board.

> 
>         static struct platform_device vou_device = {
>                 .name           = "sh-vou",
>                 .id             = -1,
>         };
> 
> so unless I'm mistaken, the platform device's name will be "sh-vou",
> not "sh-vou.0".
> 
> Does it work if you just correct the name in the CLKDEV_DEV_ID() line?

Yes, that works.

Thanks for the help, I'll report this patch series with these fixes.

Regards,

	Hans

> 
> Thanks!
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

