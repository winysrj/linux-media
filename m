Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail10.dotsterhost.com ([66.11.233.3]:41826 "HELO
	mail10.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751314AbZDNQMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 12:12:18 -0400
Message-ID: <49E4B5D9.20101@orthfamily.net>
Date: Tue, 14 Apr 2009 12:12:09 -0400
From: John Orth <john@orthfamily.net>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Pinnacle HD Stick (801e SE) and i2c issues
References: <49E40322.5040600@orthfamily.net>	 <412bdbff0904140552m52c0106q960f7c0ee40757c@mail.gmail.com>	 <49E492D0.3070101@orthfamily.net> <412bdbff0904140854x69a700a5pcbff84853ef9f8dd@mail.gmail.com>
In-Reply-To: <412bdbff0904140854x69a700a5pcbff84853ef9f8dd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm not much of a hardware guy (I know enough to get around) so 
hopefully I don't sound too inept here.
> I suspect this is probably some issue with the USB host chipset.  The
> error messages you provided suggest a problem sending commands to the
> dib0700 USB bridge, so this does not appear to be related to the
> s5h1411 or the xc5000.
>   
That was my initial thought as well, but I don't have a great 
understanding of what exactly the i2c bus does and how it works with the 
other hardware.  Is it possible that some other piece of hardware 
(non-USB, and non-USB host chipset) is impacting this?  The only reason 
I ask is that I have a PCI wireless card that is using the kernel 
rtl8185 driver (which thus far could best be described as "functional") 
and network traffic often gets dropped for several seconds.  Is it worth 
unloading the rtl8185 module and seeing if that makes a difference?

Also, would more output from dmesg (or any other command) be helpful?
> I'll have to take a look at the code and see what I can figure out.
> Do other high speed USB devices work with your host without any
> problem (like USB hard drives, etc?)
>   
The only other devices I have attempted to attach are a 2GB flash drive 
and a wireless keyboard/mouse combo.  Those devices work without any 
issues, but I don't think they qualify as "high speed."  I do have a USB 
2.0 hard drive, though.  I'll hook that up and see what happens.

Thanks again!
John

