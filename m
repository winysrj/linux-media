Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:63903 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZJENu4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 09:50:56 -0400
Date: Mon, 5 Oct 2009 15:50:13 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mario Bachmann <grafgrimm77@gmx.de>
cc: linux-media@vger.kernel.org
Subject: Re: dib3000mb dvb-t with kernel 2.6.32-rc3 do not work
In-Reply-To: <20091005095144.3551deb3@x2.grafnetz>
Message-ID: <alpine.LRH.1.10.0910051547130.29145@pub6.ifh.de>
References: <20091005095144.3551deb3@x2.grafnetz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mario,

On Mon, 5 Oct 2009, Mario Bachmann wrote:
> with kernel 2.6.30.8 my "TwinhanDTV USB-Ter USB1.1 / Magic Box I"
> worked.
>
> Now with kernel 2.6.32-rc3 (and 2.6.31.1) the modules seems to be
> loaded fine, but tzap/kaffeine/mplayer can not tune to a channel:
>
> dmesg says:
> dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device' in warm state.
> dvb-usb: will use the device's hardware PID filter (table count: 16).
> DVB: registering new adapter (TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device)
> DVB: registering adapter 0 frontend 0 (DiBcom 3000M-B DVB-T)...
> dibusb: This device has the Thomson Cable onboard. Which is default.
> input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:04.0/usb4/4-2/input/input5
> dvb-usb: schedule remote query interval to 150 msecs.
> dvb-usb: TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device successfully initialized and connected.
> usbcore: registered new interface driver dvb_usb_dibusb_mb
>
> [..]
> and so on. The signal-values are zero or near zero, but when i boot the old kernel 2.6.30.8, t can tune without problems.

In a personal email to me you are saying that the differences between 
dibusb-common.c in 2.6.30.8 and 2.6.32-rc3 are the main cause for the 
problem.

Is it possible for you find out which exact change is causing the trouble?

With the v4l-dvb-hg-repository it is possible to get each intemediate 
version of this file. Afaics, there is only 3 modifications for the 
timeframe we are talking about.

best regards,

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
