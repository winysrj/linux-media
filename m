Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36394 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab1ITJT3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 05:19:29 -0400
Received: by ywb5 with SMTP id 5so182093ywb.19
        for <linux-media@vger.kernel.org>; Tue, 20 Sep 2011 02:19:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7uXQDC5x5O09oyuPJERxR1MRaSd44KC7Cfp_79X4dZcpg@mail.gmail.com>
References: <CA+2YH7s-BH=4vN-DUZJXa9DKrwYsZORWq-YR9fK7JV9236ntMQ@mail.gmail.com>
	<20110912202822.GB1845@valkosipuli.localdomain>
	<CAK7N6vpr8uJSHMgTnrd=FrnvYf_Oqy8D3ua__S63T3nEvqaKGw@mail.gmail.com>
	<4E6EFCFC.5030803@iki.fi>
	<1315907297.2355.9.camel@sokoban>
	<CA+2YH7tEfmXnfgyFwbCEi4u5viRESM_Qckbc4MceSwsn151q6A@mail.gmail.com>
	<1315909766.2355.13.camel@sokoban>
	<CA+2YH7uXQDC5x5O09oyuPJERxR1MRaSd44KC7Cfp_79X4dZcpg@mail.gmail.com>
Date: Tue, 20 Sep 2011 11:19:28 +0200
Message-ID: <CA+2YH7tGvNjn7QGQYsa59uQ4zDEXB-VnSHCyBiG_bZWUPd1W6w@mail.gmail.com>
Subject: Re: omap3isp as a wakeup source
From: Enrico <ebutera@users.berlios.de>
To: t-kristo@ti.com
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	anish singh <anish198519851985@gmail.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	khilman@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 13, 2011 at 3:25 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Tue, Sep 13, 2011 at 12:29 PM, Tero Kristo <t-kristo@ti.com> wrote:
>> Powerdomain is automatically on if there are any clocks enabled on it.
>> If you make sure that ISP has some activity ongoing, then it should be
>> on. You can check the state of the camera powerdomain
>> from /sys/kernel/debug/pm_debug/count file, if you have mounted debugfs.
>
> And in fact something seems wrong (this is on a patched 3.0.4 kernel):
>
> usbhost_pwrdm (ON),OFF:0,RET:0,INA:0,ON:1,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
> sgx_pwrdm (OFF),OFF:1,RET:0,INA:0,ON:1,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
> per_pwrdm (ON),OFF:0,RET:0,INA:0,ON:1,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
> dss_pwrdm (ON),OFF:0,RET:0,INA:0,ON:1,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
> cam_pwrdm (RET),OFF:0,RET:9,INA:0,ON:9,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
> core_pwrdm (ON),OFF:0,RET:0,INA:0,ON:1,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0,RET-MEMBANK2-OFF:0
> neon_pwrdm (ON),OFF:0,RET:0,INA:0,ON:1,RET-LOGIC-OFF:0
> mpu_pwrdm (ON),OFF:0,RET:0,INA:0,ON:1,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
> iva2_pwrdm (RET),OFF:0,RET:1,INA:0,ON:1,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0,RET-MEMBANK2-OFF:0,RET-MEMBANK3-OFF:0,RET-MEMBANK4-OFF:0
> per_clkdm->per_pwrdm (20)
> usbhost_clkdm->usbhost_pwrdm (3)
> cam_clkdm->cam_pwrdm (0)
> dss_clkdm->dss_pwrdm (1)
> core_l4_clkdm->core_pwrdm (23)
> core_l3_clkdm->core_pwrdm (4)
> d2d_clkdm->core_pwrdm (0)
> sgx_clkdm->sgx_pwrdm (0)
> iva2_clkdm->iva2_pwrdm (0)
> neon_clkdm->neon_pwrdm (0)
> mpu_clkdm->mpu_pwrdm (0)
> prm_clkdm->wkup_pwrdm (0)
> cm_clkdm->core_pwrdm (0)
>
>
> I think the line "cam_clkdm->cam_pwrdm (0)" means that it was never
> enabled, but i grabbed some frames with yavta before that.

Forget that, i was wrong.

While yavta is running (or better to say: hanged waiting for frames) i
have this:

cam_pwrdm (ON),OFF:0,RET:6,INA:0,ON:7,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0

cam_clkdm->cam_pwrdm (3)


So it seems that clocks/power domains are "acquired" correctly but
ignored. And from /proc/interrupts i can see the isp counter
increasing (while yavta is hanged waiting for frames).

Is it possibile this happens only because some
pm_runtime_enable/disable/get/put are missing in omap3isp?

Thanks,

Enrico
