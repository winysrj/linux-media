Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:64919 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864Ab0KOMgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 07:36:01 -0500
Subject: Re: Hauppauge WinTV MiniStick IR in 2.6.36 - [PATCH]
From: Andy Walls <awalls@md.metrocast.net>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	stefano.pompa@gmail.com
In-Reply-To: <20101115112746.GB6607@linux-m68k.org>
References: <20101115112746.GB6607@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 07:35:06 -0500
Message-ID: <1289824506.2057.9.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2010-11-15 at 12:27 +0100, Richard Zidlicky wrote:
> Hi,
> 
> for some users (thats at least one user in Italy and me) the following is required:
> 
> --- linux-2.6.36/drivers/media/dvb/siano/sms-cards.c.rz 2010-11-15 11:16:56.000000000 +0100
> +++ linux-2.6.36/drivers/media/dvb/siano/sms-cards.c    2010-11-15 11:54:25.000000000 +0100
> @@ -17,6 +17,9 @@
>   *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +//#include <media/ir-kbd-i2c.h>
> +//#include <media/ir-core.h>
> +
>  #include "sms-cards.h"
>  #include "smsir.h"
>  
> @@ -64,7 +67,7 @@
>                 .type   = SMS_NOVA_B0,
>                 .fw[DEVICE_MODE_ISDBT_BDA] = "sms1xxx-hcw-55xxx-isdbt-02.fw",
>                 .fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
> -               .rc_codes = RC_MAP_RC5_HAUPPAUGE_NEW,
> +               .rc_codes = RC_MAP_DIB0700_RC5_TABLE,
>                 .board_cfg.leds_power = 26,
>                 .board_cfg.led0 = 27,
>                 .board_cfg.led1 = 28,
> 
> What is the way to achieve the effect without recompiling the kernel - is there any?
> Could we combine the keymaps - as I understand it all RC5 maps could be combined into
> one huge map without any problems except memory usage?

You apparently can use the keytable program to twiddle sysfs nodes or
the /dev/input nodes, I think:

http://git.linuxtv.org/v4l-utils.git?a=tree;f=utils/keytable;h=e599a8b5288517fc7fe58d96f44f28030b04afbc;hb=HEAD

DocBook documentation source is here:
 
http://git.linuxtv.org/media_tree.git?a=tree;f=Documentation/DocBook/v4l;h=a3e5448a4703ef0bd35fc5910bd990b2a3ca306c;hb=staging/for_v2.6.37-rc1

Human readable documentation is here:

http://linuxtv.org/downloads/v4l-dvb-apis/v4ldvb_common.html

Regards,
Andy


