Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm24-vm7.bullet.mail.ird.yahoo.com ([212.82.109.198]:37967 "HELO
	nm24-vm7.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932689Ab3EFWwh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 May 2013 18:52:37 -0400
References: <1367840892.39557.YahooMailNeo@web28904.mail.ir2.yahoo.com> <5187D1BC.8030204@gmail.com>
Message-ID: <1367880378.47575.YahooMailNeo@web28901.mail.ir2.yahoo.com>
Date: Mon, 6 May 2013 23:46:18 +0100 (BST)
From: marco caminati <marco.caminati@yahoo.it>
Reply-To: marco caminati <marco.caminati@yahoo.it>
Subject: Re: rtl2832u+r820t dvb-t usb kernel crash
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <5187D1BC.8030204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> Hi Marco,
> I have the same device and the same issue on a 2.6.32 32 bit kernel.
> However, I was able to run the driver successfully on 3.2.44 and 3.9.0
> kernels (both 32 and 64 bit).
> Also, I can run a similar device with a e4000 tuner with no problem even
> on the old 2.6.32 kernel.

> I just posted a few patches for the r820t tuner, can you try them and
> check if they fix your problem?

Thanks for your prompt work!

I patched and built the modules in the same host OS.
The system still crashes badly.
Moreover, this time I get no crash log via klogd: last line in the log is 

May  7 00:01:54 box user.info kernel: usbcore: registered new interface driver dvb_usb_rtl28xxu

So I have no error messages this time. If it's useful, I can try to set up netconsole to get them.

Concurrently, I will build a more recent kernel to test the device, as suggested by Mauro.

Cheers,
Marco

