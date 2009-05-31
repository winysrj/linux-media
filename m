Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:48395 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbZEaNeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 09:34:05 -0400
Date: Sun, 31 May 2009 06:34:06 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Miroslav =?UTF-8?Q?=20=C5=A0ustek?= <sustmidown@centrum.cz>
cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH] Leadtek WinFast DTV-1800H support
In-Reply-To: <200905291639.30476@centrum.cz>
Message-ID: <Pine.LNX.4.58.0905310536500.32713@shell2.speakeasy.net>
References: <200905291638.9584@centrum.cz> <200905291639.30476@centrum.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 29 May 2009, Miroslav [UTF-8]  Šustek wrote:
> Hello,
> this patch adds support for Leadtek WinFast DTV-1800H hybrid card.
> It enables analog/digital tv, radio and remote control trough GPIO.
>
> Input GPIO values are extracted from INF file which is included in winxp driver.
> Analog audio works both through cx88-alsa and through internal cable from tv-card to sound card.
>
> Tested by me and the people listed in patch (works well).

> +                *  2: mute (0=off,1=on)
> +                * 12: tuner reset pin
> +                * 13: audio source (0=tuner audio,1=line in)
> +                * 14: FM (0=on,1=off ???)
> +                */
> +               .input          = {{
> +                       .type   = CX88_VMUX_TELEVISION,
> +                       .vmux   = 0,
> +                       .gpio0  = 0x0400,       /* pin 2 = 0 */
> +                       .gpio1  = 0x6040,       /* pin 13 = 0, pin 14 = 1 */
> +                       .gpio2  = 0x0000,
> +               }, {
> +                       .type   = CX88_VMUX_COMPOSITE1,
> +                       .vmux   = 1,
> +                       .gpio0  = 0x0400,       /* pin 2 = 0 */
> +                       .gpio1  = 0x6060,       /* pin 13 = 1, pin 14 = 1 */
> +                       .gpio2  = 0x0000,
> +               }, {
> +                       .type   = CX88_VMUX_SVIDEO,
> +                       .vmux   = 2,
> +                       .gpio0  = 0x0400,       /* pin 2 = 0 */
> +                       .gpio1  = 0x6060,       /* pin 13 = 1, pin 14 = 1 */
> +                       .gpio2  = 0x0000,
> +               } },
> +               .radio = {
> +                       .type   = CX88_RADIO,
> +                       .gpio0  = 0x0400,       /* pin 2 = 0 */
> +                       .gpio1  = 0x6000,       /* pin 13 = 0, pin 14 = 0 */
> +                       .gpio2  = 0x0000,
> +               },
> +static int cx88_xc3028_winfast1800h_callback(struct cx88_core *core,
> +                                            int command, int arg)
> +{
> +       switch (command) {
> +       case XC2028_TUNER_RESET:
> +               /* GPIO 12 (xc3028 tuner reset) */
> +               cx_set(MO_GP1_IO, 0x1010);
> +               mdelay(50);
> +               cx_clear(MO_GP1_IO, 0x10);
> +               mdelay(50);
> +               cx_set(MO_GP1_IO, 0x10);
> +               mdelay(50);
> +               return 0;
> +       }
> +       return -EINVAL;
> +}

Instead of raising the reset line here, why not change the gpio settings in
the card definition to have it high?  Change gpio1 for television to 0x7050
and radio to 0x7010.

Then the reset can be done with:

	case XC2028_TUNER_RESET:
		/* GPIO 12 (xc3028 tuner reset) */
		cx_write(MO_GP1_IO, 0x101000);
		mdelay(50);
		cx_write(MO_GP1_IO, 0x101010);
		mdelay(50);
		return 0;

Though I have to wonder why each card needs its own xc2028 reset function.
Shouldn't they all be the same other than what gpio they change?


@@ -2882,6 +2946,16 @@
                cx_set(MO_GP0_IO, 0x00000080); /* 702 out of reset */
                udelay(1000);
                break;
+
+       case CX88_BOARD_WINFAST_DTV1800H:
+               /* GPIO 12 (xc3028 tuner reset) */
+               cx_set(MO_GP1_IO, 0x1010);
+               mdelay(50);
+               cx_clear(MO_GP1_IO, 0x10);
+               mdelay(50);
+               cx_set(MO_GP1_IO, 0x10);
+               mdelay(50);
+               break;
        }
 }

Couldn't you replace this with:

	case CX88_BOARD_WINFAST_DTV1800H:
		cx88_xc3028_winfast1800h_callback(code, XC2028_TUNER_RESET, 0);
		break;
