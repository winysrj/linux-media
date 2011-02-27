Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:44087 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1B0SyE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 13:54:04 -0500
Message-ID: <4D6A9388.5030001@iki.fi>
Date: Sun, 27 Feb 2011 20:10:16 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Vinicio Nocciolini <vnocciolini@mbigroup.it>
CC: linux-media@vger.kernel.org
Subject: Re: ec168-9295d36ab66e compiling error
References: <4D666A3A.1090701@mbigroup.it>
In-Reply-To: <4D666A3A.1090701@mbigroup.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dont use my, or anyone else, old HG trees. You should follow that
http://www.linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers

Antti

On 02/24/2011 04:24 PM, Vinicio Nocciolini wrote:
> Hi all
>
> I have problem compiling the project
>
> regards Vinicio
>
> -----------------------------------------------------------------------------------------------------------
>
>
> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/vc032x.o
> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/zc3xx.o
> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hdpvr-control.o
> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hdpvr-core.o
> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hdpvr-video.o
> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hopper_cards.o
> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hopper_vp3028.o
> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-functions.o
> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.o
> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.c: In function
> '__ir_input_register':
> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.c:452:24:
> warning: assignment from incompatible pointer type
> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.c:453:24:
> warning: assignment from incompatible pointer type
> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.o
> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.c: In function
> 'ir_register_class':
> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.c:268:23: error:
> 'ir_raw_dev_type' undeclared (first use in this function)
> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.c:268:23: note:
> each undeclared identifier is reported only once for each function it
> appears in
> make[3]: *** [/home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.o]
> Error 1
> make[2]: *** [_module_/home/vinicio/Desktop/ec168-9295d36ab66e/v4l] Error 2
> make[2]: Leaving directory `/usr/src/kernels/2.6.35.11-83.fc14.i686'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/vinicio/Desktop/ec168-9295d36ab66e/v4l'
> make: *** [all] Error 2
>
>
>
>
>
>
>
>
> [vinicio@localhost ec168-9295d36ab66e]$ cat /etc/issue
> Fedora release 14 (Laughlin)
> Kernel \r on an \m (\l)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
