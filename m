Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34621 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaCLKI5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 06:08:57 -0400
Message-ID: <53203232.2060203@gentoo.org>
Date: Wed, 12 Mar 2014 11:08:50 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Jan Gebhardt <h.smith05@gmail.com>, linux-media@vger.kernel.org
Subject: Re: problems with Cinergy HTC HD Rev. 2 (0x0ccd:0x0101) Conexant
 231xx
References: <531D8B39.9010504@gmail.com>
In-Reply-To: <531D8B39.9010504@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10.03.2014 10:51, Jan Gebhardt wrote:
> Hi,
> 
> i have some problems using the Terratec Cinergy HTC Stick HD Rev. 2 .
> 
> The driver or the specification is currenty not implemented into
> driverset of media-build.

That means nothing happened when plugging the stick in?
> 
> All i know is, that there is a buildin Conexant Chip (I think the
> CX23102) and a SiliconLabs Tuner (SI2173). I already tried to adapt this
> knownledge combined with the configuration of the windows driver to the
> driver(cx231xx) but sadly without success.

How did you check the chips that are present?
Did you read through the inf file of the windows driver or open the device?

Looking at the inf file you attached, it most likely has a si2165
dvb-c/t demod.

I wrote a first driver for this demod.

But I think the tuner is unsupported (si2173 or si2170 as inf file says).
Google only found these documents:
- https://www.silabs.com/Support%20Documents/TechnicalDocs/Si2173-short.pdf
- http://electronix.ru/forum/index.php?act=attach&type=post&id=66442

But both documents skip the detailed programming.

And I found this driver for si2176:
https://github.com/fards/AMlogic_Meson6_030812release/blob/master/drivers/amlogic/tuners/si2176_func.c
But I am not sure about the relation between si2170, si2173 and si2176


For adding support your device, you need to go through the normal
process described in the wiki.
Part of this is recording usb traffic.
This can then partially be matched to the existing drivers.

Regards
Matthias


