Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55153 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab0IPQ4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 12:56:42 -0400
Received: by qwh6 with SMTP id 6so1109896qwh.19
        for <linux-media@vger.kernel.org>; Thu, 16 Sep 2010 09:56:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=C5vbVqcDe1JDcz7WxRRO3YeL-RKwQh5Bpv79G@mail.gmail.com>
References: <AANLkTi=7fPmqkkhGpPEXP9b6od+QRMTF_Xwh-i=BjEku@mail.gmail.com>
	<AANLkTi=C5vbVqcDe1JDcz7WxRRO3YeL-RKwQh5Bpv79G@mail.gmail.com>
Date: Thu, 16 Sep 2010 13:56:41 -0300
Message-ID: <AANLkTi=otOpFHMGKg9=wkMZKgY_KHOkBDAUq93-18fzb@mail.gmail.com>
Subject: Re: Hello and question about firmwares
From: =?UTF-8?B?4pyOxqZhZmFlbCBWaWVpcmHimaY=?= <rafastv@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I realize now that I was kind of fast foward :) So nice to meet you all.
I hope someday, I'm able to help you guys.
Let me give you some more data from the device, although is not
directly related to my questions.

The two devices:

http://www.pixelview.com.br/play_tv_usb_sbtvd_fullseg.asp (works already)

http://www.pixelview.com.br/playtv_usb_hybrid.asp (I'm trying to get it to work)


The two boards even seems to be the same(lsusb output is the same from the two):

(from #lsusb)
Bus 001 Device 005: ID 1554:5010 Prolink Microsystems Corp.

(from dmesg)
[10994.296447] dvb-usb: found a 'Prolink Pixelview SBTVD' in cold
state, will try to load a firmware
[10994.296461] usb 1-3: firmware: requesting dvb-usb-dib0700-1.20.fw
[10994.354616] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[10994.354639] dib0700: firmware download failed at 7 with -22

So, the problem to me seems to be only the firmware.
I've upload the file (merlinD.rom) to here.

http://www.2shared.com/file/URb2IeUi/merlinD.html

If anyone care to take a look.

Best wishes and many thanks for any help,

Rafael Vieira - programmer and student.
