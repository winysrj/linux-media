Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65185 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab0KPCte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 21:49:34 -0500
Received: by wwa36 with SMTP id 36so234359wwa.1
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 18:49:33 -0800 (PST)
Message-ID: <4CE1F139.1030509@gmail.com>
Date: Tue, 16 Nov 2010 03:49:29 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Okkel Klaver <vbroek@iae.nl>
Subject: Re: af9015 and nxp tda182128 support
References: <4CE16387.3040103@iae.nl>
In-Reply-To: <4CE16387.3040103@iae.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Okkel Klaver wrote:
...
> I own a brandless hdtv usb dvb-t stick.
> 
> lsusb identifies it as:
> Bus 001 Device 005: ID 15a4:9016 Afatech Technologies, Inc. AF9015 DVB-T
> USB2.0 stick
> 
> I'm using debian with kernel 2.6.32. This kernel doesn't have support
> for the nxp tda18218 tuner on the stick.
> I compiled the latest v4l-dvb source tree from mercural. Now i get the
> following error message when i plugin the stick:
> af9015: tuner NXP TDA18218 not supported yet
> 
> Searching the archives of this list i found some messages concerning nxp
> tda18218 support. It seems to me that there is support for the nxp
> tda18218 in the current source tree, but support for the new tuner
> driver is lacking from the af9015 driver.
> 
> Now is my question: are there any plans to support the nxp tda18218
> tuner in the af9015 driver?
> 

==> [ANNOUNCE] new experimental building system <==
...
If you want to test the new building system, all you need to do is:

	$ git clone git://linuxtv.org/mchehab/new_build.git
	$ cd new_build
	$ ./build.sh

This will download the newest tarball from linuxtv.org, apply the 
backport patches
and build it.

After that, you may install the new drivers with:
	$ make install
...

Regards,
poma

