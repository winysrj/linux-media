Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:53213 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbZIJPpN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 11:45:13 -0400
Date: Thu, 10 Sep 2009 17:44:57 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Heinrich Langos <henrik-vdr@prak.org>
Subject: Re: DVB USB stream parameters
In-Reply-To: <4AA26587.7000506@iki.fi>
Message-ID: <alpine.LRH.1.10.0909101651400.5940@pub3.ifh.de>
References: <4AA26587.7000506@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

sorry for answering with delay.

On Sat, 5 Sep 2009, Antti Palosaari wrote:

> What are preferred BULK stream parameters, .count and .buffersize?
>
> for USB2.0?
> for USB1.1?
>
> buffersize, which is URB size, have great effect to system load. For example 
> 512 bytes generates about 10x more wakeups than 5120. It is quite clear that 
> 512 is too small for whole DVB stream. I did some test and looks like all 
> USB2.0 devices I have here allow x512 or x188 sizes.
> Heinrich Langos did some measurements and results can be seen here:
> http://www.linuxtv.org/wiki/index.php/User:Hlangos
>
> In my understanding we should found some balance between URB size and 
> transferred stream bandwidth. For example DVB-T stream, when common 
> transmission parameters are used, is more than 20Mbit/sec.
>
> There is also USB bridge chips which does have two or more different standard 
> frontends needed different stream bandwidths.
>
> Should we add new module param for override module default?
>
> a800        BULK  7x 4096= 28672
> af9005      BULK 10x 4096= 40960 USB1.1 BUGFIX: x512=>x188
> af9015      BULK  6x 3072=  3072 BUGFIX: x512=>x188
> anysee      BULK  8x  512=  4096
> ce6230      BULK  6x  512=  3072
> cinergyT2   BULK  5x  512=  2560
> cxusb       BULK  5x 8192= 40960
> cxusb       BULK  7x 4096= 28672
> dib0700     BULK  4x39480=157920 210x188 !!HUGE!!
> dibusb-mb   BULK  7x 4096= 28672  56x512
> dibusb-mc   BULK  7x 4096= 28672
> digitv      BULK  7x 4096= 28672
> dtt200u     BULK  7x 4096= 28672
> dtv5100     BULK  8x 4096= 32768
> dw2102      BULK  8x 4096= 32768
> gl861       BULK  7x  512=  3584
> gp8psk      BULK  7x 8192= 57344
> m920x       BULK  8x  512=  4096
> m920x       BULK  8x16384=131072 256x512 !!HUGE!!
> nova-t-usb2 BULK  7x 4096= 28672
> opera1      BULK 10x 4096= 40960
> umt-010     BULK 10x  512=  5120
> vp702x      BULK 10x 4096= 40960
> vp7045      BULK  7x 4096= 28672
>
> au6610      ISOC  5 frames 40 size 942
> ttusb2      ISOC  5 frames  4 size 942

I don't know exactly why (the USB/HW background for that is not present in 
my brain), but at some point having less than 39480B for one (high-level) 
URB for the dib0700 resulted in never having any URB returning from the 
USB stack. I chose 4 of them because .. I don't remember. It seems even 1 
is working.

I remember someone telling me that this is due to something in the 
firmware. I need to wait for some people to be back from whereever they 
are to know exactly what's going on (that's why I haven't responded yet).


--

Patrick 
http://www.kernellabs.com/
