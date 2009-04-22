Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail10.dotsterhost.com ([66.11.233.3]:60978 "HELO
	mail10.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757073AbZDVTMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2009 15:12:19 -0400
Message-ID: <49EF6C0C.5090305@orthfamily.net>
Date: Wed, 22 Apr 2009 15:12:12 -0400
From: John Orth <john@orthfamily.net>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Pinnacle HD Stick (801e SE) and i2c issues
References: <49E40322.5040600@orthfamily.net>	 <412bdbff0904140552m52c0106q960f7c0ee40757c@mail.gmail.com>	 <49E492D0.3070101@orthfamily.net> <412bdbff0904140854x69a700a5pcbff84853ef9f8dd@mail.gmail.com> <49E4B5D9.20101@orthfamily.net>
In-Reply-To: <49E4B5D9.20101@orthfamily.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It turns out that the issues I was having with the Asus M3A78-EM and 
Pinnacle HDTV Stick 801e SE were completely unrelated to the v4l 
driver.  I added a PCI USB 2.0 card and plugged the tuner stick into 
that and things are working, and working very well I might add. 

The original issue was that, after a seemingly random time of usage, 
dmesg would get filled with:

---
s5h1411_writereg: writereg error 0x19 0xf5 0x0000, ret == 0)
dib0700: i2c write error (status = -108)
---

and the tuner would cease to work in any fashion without a cold boot and 
switching the USB port to which the tuner was attached.

Thanks much to Devin Heitmueller for all his help.  This actually is an 
issue with the USB host controller on the AMD SB700, so the PCI card was 
a great and inexpensive (~10 USD) workaround.

John
