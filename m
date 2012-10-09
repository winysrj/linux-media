Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44508 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2JIMMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 08:12:47 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so4929272oag.19
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 05:12:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACKLOr3stV-Pup_w+DwGO3z842hct4RV+_hCVpL7Pu3QRFwH0w@mail.gmail.com>
References: <1349735823-30315-1-git-send-email-festevam@gmail.com>
	<CACKLOr3stV-Pup_w+DwGO3z842hct4RV+_hCVpL7Pu3QRFwH0w@mail.gmail.com>
Date: Tue, 9 Oct 2012 09:12:46 -0300
Message-ID: <CAOMZO5CrhWGBW4z4eoeAviDeBF0bPLcp-7tXGUrdnFWfVGr+cw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] [media]: mx2_camera: Fix regression caused by
 clock conversion
From: Fabio Estevam <festevam@gmail.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	kernel@pengutronix.de, gcembed@gmail.com,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tue, Oct 9, 2012 at 8:16 AM, javier Martin
<javier.martin@vista-silicon.com> wrote:

> This patch doesn't fix the BUG it claims to, since I have it working
> properly in our Visstrim M10 platform without it. Look:

Yes, it does fix a real bug. Without this patch the ov2640 cannot be
probed, as it fails to read the product/vendor ID via I2C. I measure
with the scope and do not get mclk at all without this patch.

Again, camera probe does work fine on kernel 3.4.

Does the mx27 feed the mclk to your camera?  Which frequency do you
get if you measure it with a scope.

>
> soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
> mx2-camera mx2-camera.0: Camera driver attached to camera 0
> ov7670 0-0021: chip found @ 0x42 (imx-i2c)
> [..]
> mx2-camera mx2-camera.0: Camera driver detached from camera 0
> mx2-camera mx2-camera.0: MX2 Camera (CSI) driver probed, clock
> frequency: 66500000

This 66.5MHz is wrong.

>
> Furthermore, it's not correct, since there isn't such "per" clock for
> the CSI in 3.5 [1], 3.6 [2], linux-next-20121008[3], or
> next-20121009[4].

Well, you are looking to all git trees after the conversion to the
common clock framework.

Please look at 3.4 kernel instead and you will see that per4 is indeed
used for csi.
"DEFINE_CLOCK1(csi_clk,     0, NULL,   0, parent, &csi_clk1, &per4_clk);"

In fact, the mx27 reference manual is the correct source for such
information. Please check "Table 39-9. CSI Control Register 1 Field
Descriptions (continued)":

"Sensor Master Clock (MCLK) Divider. This field contains the divisor MCLK.
The MCLK is derived from the PERCLK4."

Can you let me know if this patch breaks things for you? Or what
exactly you think is wrong with it?

It seems that you are camera works by pure luck without this patch.
Maybe you are turning per4 in the bootloader or you get the clock to
your camera from somewhere else.

Regards,

Fabio Estevam
