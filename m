Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38056 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbZDTL4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 07:56:34 -0400
Date: Mon, 20 Apr 2009 08:56:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: linux-media@vger.kernel.org
Cc: roman.pena.perez@gmail.com, David Woodhouse <dwmw2@infradead.org>,
	linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] firmware: convert av7110 driver to
 request_firmware()
Message-ID: <20090420085628.31512f60@pedra.chehab.org>
In-Reply-To: <28a25ce0904191441h3adc43b3y8265a639e8c025cc@mail.gmail.com>
References: <1214127575.4974.7.camel@jaswinder.satnam>
	<a3ef07920904191055j4205ad8du3173a8a2328a214e@mail.gmail.com>
	<1240167036.3589.310.camel@macbook.infradead.org>
	<a3ef07920904191214p7be3a0eem7f7abd91ffb374d2@mail.gmail.com>
	<1240170449.3589.334.camel@macbook.infradead.org>
	<a3ef07920904191340x6a4e9c5o5c51fe0169cbddab@mail.gmail.com>
	<1240174908.3589.387.camel@macbook.infradead.org>
	<28a25ce0904191441h3adc43b3y8265a639e8c025cc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 19 Apr 2009 23:41:58 +0200
Román <roman.pena.perez@gmail.com> wrote:

> 2009/4/19 David Woodhouse <dwmw2@infradead.org>:
> > On Sun, 2009-04-19 at 13:40 -0700, VDR User wrote:
> >>
> >> To be absolutely clear; users compiling dvb drivers outside of the
> >> kernel should copy v4l-dvb/linux/firmware/av7110/bootcode.bin.ihex to
> >> /lib/firmware/av7110/bootcode.bin correct?
> >
> > Run 'objcopy -Iihex -Obinary bootcode.bin.ihex bootcode.bin' first, then
> > copy the resulting bootcode.bin file to /lib/firmware/av7110/
> >
> 
> That doesn't seem very *obvious* to me, actually.

If you see INSTALL file at v4l-dvb tree, you'll see:

...
Firmware rules:

firmware        - Create the firmware files that are enclosed at the
                  tree.
                  Notice: Only a very few firmwares are currently here

firmware_install- Install firmware files under /lib/firmware
...

So, all you would need to do to install firmwares with -hg is to run:
	make firmware_install

Anyway, since firmware install is very fast, and in order to avoid such issues,
I've just committed a patch that will run firmware_install when you do a "make
install".



Cheers,
Mauro
