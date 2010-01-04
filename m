Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:36021 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab0ADJSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 04:18:30 -0500
Date: Mon, 4 Jan 2010 10:19:27 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Bill Whiting <textux@bellsouth.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Lenovo compact webcam 17ef:4802
Message-ID: <20100104101927.087aa290@tele>
In-Reply-To: <4B413B99.3020604@bellsouth.net>
References: <4B413B99.3020604@bellsouth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 03 Jan 2010 19:51:37 -0500
Bill Whiting <textux@bellsouth.net> wrote:

> I have not been able to get an image from a Lenovo webcam under
> Fedora 11. It reports to the kernel with USB id 17ef:4802 as below:
> 
>   kernel: usb 1-3: new high speed USB device using ehci_hcd and
> address 9 kernel: usb 1-3: New USB device found, idVendor=17ef,
> idProduct=4802 kernel: usb 1-3: New USB device strings: Mfr=1,
> Product=2, SerialNumber=0 kernel: usb 1-3: Product: Lenovo USB Webcam
>   kernel: usb 1-3: Manufacturer: Primax
>   kernel: usb 1-3: configuration #1 chosen from 1 choice
>   kernel: gspca: probing 17ef:4802
>   kernel: vc032x: check sensor header 20
>   kernel: vc032x: Sensor ID 143a (3)
>   kernel: vc032x: Find Sensor MI1310_SOC
>   kernel: gspca: probe ok
	[snip]

Hello Bill,

I don't know which version of gspca is included in your kernel.
First, do you use the v4l library when running cheese or skype?
Then, may you get the last video stuff from LinuxTv.org and check if it
works?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
