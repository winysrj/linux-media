Return-path: <linux-media-owner@vger.kernel.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]:7294 "EHLO
	ctsmtpout4.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751391AbZHaK13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 06:27:29 -0400
Received: from ctps3 (10.20.100.15) by ctsmtpout4.frontal.correo (7.2.056.6)
        id 4A4B30EA00E2F64C for linux-media@vger.kernel.org; Mon, 31 Aug 2009 12:27:30 +0200
Message-ID: <18203149.1251714450755.JavaMail.root@ctps3>
Date: Mon, 31 Aug 2009 12:27:30 +0200 (MEST)
From: "DCRYPT@telefonica.net" <DCRYPT@telefonica.net>
Reply-To: DCRYPT@telefonica.net
To: <linux-media@vger.kernel.org>
Subject: Re: [linux-dvb] saa 7162 chip, recording from s-video
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Eduard,

Could you please specify what to do in order to add a PCI ID to the 
driver list? I was investigating by myself some time ago, but could not 
manage to do it.

Regards.

>----Mensaje original----
>De: eduard.budulea@axigen.com
>Recibido: 31/08/2009 11:35
>Para: <linux-dvb@linuxtv.org>
>Asunto: [linux-dvb] saa 7162 chip, recording from s-video
>
>Hi, I have this card:Kworld DVB-T PE310.
>On a ubuntu 9.4 system with linux 2.6.28-15-generic.
>I've managed to compile and install the drivers from:
>http://www.jusst.de/hg/saa716x/
>I've added my pci id to the driver list (used atlantis config 
structure)
>I also added my tda10046 (actually my chips are tda 100046A, why the
>extra 0?) id (whitch is 0xFF, not 0x46) in tda10046_attach function.
>It kind of worked, because it has not crashed and the w_scan give 
output
>like is working.
>How ever, I don't know if in my region I have dvb-t.
>I have gotten this board because the motherboard has only pci 
express.
>What I want is to be able to record from an s-video source.
>It should be possible with this card.
>But the card does not export a /dev/videox file (no v4l?)
>It only creates /dev/dvb/adapterx thing.
>So how can I record s-video with this card?
>
>Thanks, I am willing to do testing for the driver development.
>
>
>_______________________________________________
>linux-dvb users mailing list
>For V4L/DVB development, please use instead linux-media@vger.kernel.
org
>linux-dvb@linuxtv.org
>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-------------------------------
dCrypt


