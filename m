Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60788 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1IMKIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 06:08:35 -0400
Received: by ywb5 with SMTP id 5so294497ywb.19
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 03:08:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315907297.2355.9.camel@sokoban>
References: <CA+2YH7s-BH=4vN-DUZJXa9DKrwYsZORWq-YR9fK7JV9236ntMQ@mail.gmail.com>
	<20110912202822.GB1845@valkosipuli.localdomain>
	<CAK7N6vpr8uJSHMgTnrd=FrnvYf_Oqy8D3ua__S63T3nEvqaKGw@mail.gmail.com>
	<4E6EFCFC.5030803@iki.fi>
	<1315907297.2355.9.camel@sokoban>
Date: Tue, 13 Sep 2011 12:08:34 +0200
Message-ID: <CA+2YH7tEfmXnfgyFwbCEi4u5viRESM_Qckbc4MceSwsn151q6A@mail.gmail.com>
Subject: Re: omap3isp as a wakeup source
From: Enrico <ebutera@users.berlios.de>
To: t-kristo@ti.com
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	anish singh <anish198519851985@gmail.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 13, 2011 at 11:48 AM, Tero Kristo <t-kristo@ti.com> wrote:
> On Tue, 2011-09-13 at 08:49 +0200, Sakari Ailus wrote:
>> anish singh wrote:
>> > On Tue, Sep 13, 2011 at 1:58 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> >> On Mon, Sep 12, 2011 at 04:50:42PM +0200, Enrico wrote:
>> >>> Hi,
>> >>
>> >> Hi Enrico,
>> >>
>> >>> While testing omap3isp+tvp5150 with latest Deepthy bt656 patches
>> >>> (kernel 3.1rc4) i noticed that yavta hangs very often when grabbing
>> >>> or, if not hanged, it grabs at max ~10fps.
>> >>>
>> >>> Then i noticed that tapping on the (serial) console made it "unblock"
>> >>> for some frames, so i thought it doesn't prevent the cpu to go
>> >>> idle/sleep. Using the boot arg "nohlt" the problem disappear and it
>> >>> grabs at a steady 25fps.
>> >>>
>> >>> In the code i found a comment that says the camera can't be a wakeup
>> >>> source but the camera powerdomain is instead used to decide to not go
>> >>> idle, so at this point i think the camera powerdomain is not enabled
>> >>> but i don't know how/where to enable it. Any ideas?
>> >>
>> >> I can confirm this indeed is the case --- ISP can't wake up the system ---
>> >> but don't know how to prevent the system from going to sleep when using the
>> >> ISP.
>> > Had it been on android i think wakelock would have been very useful.
>>
>> I believe there are proper means to do this using more standard methods
>> as well. Not being a PM expert, I don't know how.
>>
>> Cc Tero.
>>
>
> Hi,
>
> I don't think there are proper means yet to do this, as camera is
> somewhat a special case in omap3, it is apparently the only module that
> is causing this kind of problem. However, you can prevent idle when
> camera is active with something like this:
>
> diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
> index 2789e0a..7fdf6e2 100644
> --- a/arch/arm/mach-omap2/pm34xx.c
> +++ b/arch/arm/mach-omap2/pm34xx.c
> @@ -358,6 +358,9 @@ void omap_sram_idle(void)
>                                omap3_per_save_context();
>        }
>
> +       if (pwrdm_read_pwrst(cam_pwrdm) == PWRDM_POWER_ON)
> +               clkdm_deny_idle(mpu_pwrdm->pwrdm_clkdms[0]);
> +
>        /* CORE */
>        if (core_next_state < PWRDM_POWER_ON) {
>                omap_uart_prepare_idle(0);
>
>
>
> -Tero

i think something related is already in
arch/arm/mach-omap2/cpuidle34xx.c omap3_enter_idle_bm(...):

/*
 * Prevent idle completely if CAM is active.
 * CAM does not have wakeup capability in OMAP3.
 */
cam_state = pwrdm_read_pwrst(cam_pd);
if (cam_state == PWRDM_POWER_ON) {
        new_state = dev->safe_state;
        goto select_state;
}


But probably the power domain is not set to ON, and i don't know where
it should be set. Maybe, as Laurent suggested, adding runtime PM
support will fix it?

Thanks,

Enrico
