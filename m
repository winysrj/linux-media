Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp124.rog.mail.re2.yahoo.com ([206.190.53.29]:29390 "HELO
	smtp124.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752884AbZAKVWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 16:22:22 -0500
Message-ID: <496A630C.6050807@rogers.com>
Date: Sun, 11 Jan 2009 16:22:20 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [Fwd: Re: [linux-dvb] Post:/dev directory not populated while trying
 to use a	Cinergy DT USB XS Diversity USB TV tuner]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pierre-Jean BELIN wrote:

> Hello
>
> I am trying to use a TerraTec Cinergy DT USB XS Diversity USB key to
> broadcast video on my private network.
>
> I have followed tutorials from www.linuxtv.org but impossible to start
> the device.
>
> The key works correctly on Vista, so I am sure that the device is not
> out of order.
>
> My OS is a Fedora Sulfur ; kernel version : 2.6.27.9-73.fc9; my box is a 64bits
>
> 1) I describe hereunder all the steps I followed to (unsuccessfully)
> start the key.
>
> Everything is based on www.linuxtv.org tutos.
>
> a) Installation of Mercurial and download of all the sources to
> compile the modules.
> b) As mentioned in the description of the key
> (http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity#Firmware)
> my device id is 0081 instead of 005a. Thus, I have modified (only
> replace 005a by 0081) the file
> linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h to take into account
> this change.
>
> Old line
> ==================================================================
>  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY        0x005a
> ==================================================================
> New line
> ==================================================================
>  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY        0x0081
> ==================================================================

Pierre,

It requires a little bit more more changes to the source code. See
Nicolas' patch, which he resubmitted (and hopefully gets picked up this
time) a few hours after your message:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg00138.html




