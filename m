Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65533 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab0AVQ1T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 11:27:19 -0500
Received: by bwz27 with SMTP id 27so1235986bwz.21
        for <linux-media@vger.kernel.org>; Fri, 22 Jan 2010 08:27:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <135ab3ff1001220818r3e10650fl80e873c441bffde4@mail.gmail.com>
References: <135ab3ff1001200926j9917d69x51eede94512fa664@mail.gmail.com>
	 <829197381001201000x58aadea5wab0948691d9a4c4f@mail.gmail.com>
	 <135ab3ff1001210155qad2c794rf6781c4ac28159c7@mail.gmail.com>
	 <d9def9db1001210407s6f14d637x1e32d34f7193a188@mail.gmail.com>
	 <4B587B91.9070300@koala.ie>
	 <135ab3ff1001220818r3e10650fl80e873c441bffde4@mail.gmail.com>
Date: Fri, 22 Jan 2010 11:27:17 -0500
Message-ID: <829197381001220827x243ae52cx44a8fa7b627c7184@mail.gmail.com>
Subject: Re: Drivers for Eyetv hybrid
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Morten Friesgaard <friesgaard@gmail.com>
Cc: Simon Kenyon <simon@koala.ie>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 22, 2010 at 11:18 AM, Morten Friesgaard
<friesgaard@gmail.com> wrote:
> Actually I don't understand why this em28xx driver is the only one
> being patched, guess that reduces backward compability!? :-P

There are many drivers actively being developed.  What I'm trying to
say is that the new version of the EyeTV Hybrid is not an em28xx based
hardware design.

> Well, I haven't given up, but no one has given me any pointers but /dev/null
> If this em28xx module would be startable with the usb id "0fd9:0018",
> I could tryout the old driver.
> If you say the hardware design is completely different, I guess it
> should still be possible to mount the usb device and fetch anything
> from the device (e.g. tvtime -d /dev/usbdev). The driver would be a
> matter of controlling the device to tune to the correct channel etc.

No, that is not how USB drivers work.  You have to know how to program
the various chips on the device (the bridge, demodulator, decoder,
tuner), as well as knowing how to decode the packets coming back from
the device.  If you want to get an understanding as to how complex the
drivers are then feel free to look at some of them in the v4l-dvb
source code.  You can get a better understanding as to how these
devices are designed here:

KernelLabs Blog:  How Tuners Work...
http://www.kernellabs.com/blog/?p=1045

> When new hardware is introduced, how do you guys break down the task
> and implement a driver? (how much can be borrow from the mac os x
> drivers?)

It largely depends on the device.  Usually you start by cracking it
open and seeing what chips it contains, and from there you can see
which components currently have a driver and which do not.  Whether
the various components are already supported usually drives whether a
whole new driver is required or just a board profile in an existing
driver.  And whether datasheets are available publicly dictates how
easy/hard it is to write a driver (the datasheets are usually *not*
available for modern devices, or only available under NDA).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
