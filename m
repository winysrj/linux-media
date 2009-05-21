Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:43518 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZEUPYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 11:24:14 -0400
Received: by ewy24 with SMTP id 24so1269414ewy.37
        for <linux-media@vger.kernel.org>; Thu, 21 May 2009 08:24:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A156184.1070501@gmail.com>
References: <4A128A19.40601@gmail.com>
	 <37219a840905200608q42b4fc0fife8f9aad7056145b@mail.gmail.com>
	 <4A1424F8.9010706@gmail.com>
	 <37219a840905201219x576fe229g6d95f1cf7dc80a08@mail.gmail.com>
	 <4A156184.1070501@gmail.com>
Date: Thu, 21 May 2009 11:24:13 -0400
Message-ID: <37219a840905210824r7b76d865n57325389d6c74b89@mail.gmail.com>
Subject: Re: Hauppauge HVR 1110 and DVB
From: Michael Krufky <mkrufky@kernellabs.com>
To: Antonio Beamud Montero <antonio.beamud@gmail.com>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 21, 2009 at 10:13 AM, Antonio Beamud Montero
<antonio.beamud@gmail.com> wrote:
> Thanks for the patch. Seems to load fine, the problem arises when try load
> the firmware.
[snip]
> DVB: registering new adapter (saa7133[0])
> DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
> tda10048_firmware_upload: waiting for firmware upload
> (dvb-fe-tda10048-1.0.fw)...
> tda10048_firmware_upload: firmware read 24878 bytes.
> tda10048_firmware_upload: firmware uploading
> tda10048_firmware_upload: firmware upload failed
> saa7134 ALSA driver for DMA sound loaded
> saa7133[0]/alsa: saa7133[0] at 0xfc4ff800 irq 65 registered as card -1
>
> ---
>
> I've tried to extract the firmware from the windows drivers, but all my
> experiments failed.
> How I can get the correct firmware?

You can get the firmware from here:

http://www.steventoth.net/linux/hvr1200

Regards,

Mike
