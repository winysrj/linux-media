Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34926 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbZAKRPp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 12:15:45 -0500
Message-ID: <496A293D.1060500@iki.fi>
Date: Sun, 11 Jan 2009 19:15:41 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Evan Nando <nando4eva@gmail.com>
CC: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Tuning probs qt1010/AF9005/Linux + XP driver for
 AF9005	qt1010
References: <4116f8730901110619v5108d14en7f59044091a7e99@mail.gmail.com> <4116f8730901110629s6d21b5b0td4dfd89044c977cd@mail.gmail.com>
In-Reply-To: <4116f8730901110629s6d21b5b0td4dfd89044c977cd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Evan Nando wrote:
> Hi everyone,
> 
> I have the qt1010 based AF9005 and find it has VERY unreliable tuning in 
> Linux. It just fails to lock onto channels, even after it has 
> successfully scanned them The problem does not exist at all in WindowsXP 
> using BlazeDVT. What I've discovered is the *XP driver* supplied on CD 
> with the AF9005 usb stick works very well with it, whereas other drivers 
> I've downloaded from the afatech website give poor tuning (giving less 
> bars in Signal Strength).
Current Linux qt1010 driver seems to perform better when signal is weak. 
With strong signals it does not lock very reliable.

> I did note on the LinuxTV/dvb-tv forums that others were having the same 
> problem, probably because of the qt1010 tuning (very choppy in Linux, 
> fine in Windows). There are no tweaks available as per the mt2060.
> 
> The driver that works very well with XP has been uploaded to 
> http://www.megaupload.com/?d=LU1E55EN (716kb)
Thanks. I will try to disasm it to see what is differently.

> Would anyone be willing to extract the firmware from it for use in 
> Linux? This would be specific qt1010 firmware. I've tried using usbsnoop 
> and various filters to try to replay the USB sequence and have not 
> gotten anywhere.
There is no firmware download needed by the qt1010.

> Any other tips on Linux qt1010/AF9005 tuning would be much appreciated. 
> I am hopeful the qt1010 specific firmware will give better results with 
> Linux. Would not need to boot into XP anymore to watch TV:)
You should wait a little. I am doing some work here slowly...


-- 
http://palosaari.fi/
