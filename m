Return-path: <linux-media-owner@vger.kernel.org>
Received: from [193.252.22.192] ([193.252.22.192]:6524 "EHLO
	smtp6.freeserve.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754373AbZHUP0h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 11:26:37 -0400
From: "Christopher Thornley" <c.j.thornley@coolrose.fsnet.co.uk>
To: "'Bert Haverkamp'" <bert@bertenselena.net>,
	<linux-media@vger.kernel.org>
References: <1250678707.14727.12.camel@McM> <20090819200127.15831t9vff8irzfo@www.kjellerup-hansen.dk> <1e68a10b0908191317g4a442729i18aa9737b82c7996@mail.gmail.com>
In-Reply-To: <1e68a10b0908191317g4a442729i18aa9737b82c7996@mail.gmail.com>
Subject: RE: [linux-dvb] USB technotrend CT-3650
Date: Fri, 21 Aug 2009 16:26:27 +0100
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAACALqAb95DxLgRY4ishQnccBAAAAAA==@coolrose.fsnet.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I can confirm DVB-C does not work.
Tried with Kaffine and a custom transponder list for my aera and with w_scan
which takes an age to change between frequencies.

Chris 


               />      Christopher J. Thornley is cjt@coolrose.fsnet.co.uk
  (           //------------------------------------------------------,
 (*)OXOXOXOXO(*>=*=O=S=U=0=3=6=*=---------                             >
  (           \\------------------------------------------------------'
               \>       Home Page :-http://www.coolrose.fsnet.co.uk
 
-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Bert Haverkamp
Sent: 19 August 2009 21:17
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] USB technotrend CT-3650


Hello Jens,

I'm also looking into the CT-3650. I posted a few days back about the
support for this device for dvb-c. Are you trying to get dvb-c working or
dvb-t?

Can anyone else answer if dvb-c is indeed working with current linux?

Regards,

Bert

> Wed, Aug 19, 2009 at 8:01 PM, Jens Kjellerup<jens@kjellerup-hansen.dk>
wrote:
> I am not a developer and my programming skills dates back to the late 
> 1970's where i programmed insurance applications i Cobol - so they are a
bit rusty.
>
> I have been given a Technotrend connect CT-3650 CI device as a 
> birthday present for my myth server (don't ask for my age). I run
Mythbuntu 9.04.
>
> I have searched for drivers to get the unit up and running but can't 
> find any. I have read:
> http://osdir.com/ml/linux-media/2009-03/msg01137.html
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg08610.html
> http://www.spinics.net/linux/lists/linux-dvb/msg27678.html
> and several others, but i haven't found any workable solution.
>
> I have tried to follow the recipee on this device - a sister product 
> for
> dvb-s2
> http://linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI
>
> Up until now i have found no way to get the device running.
> I have compiled and installed the newest v4l repository with no 
> further luck. I have extracted the newest firmware from the latest BDA 
> files on the the Technotrend site www.tt-pc.de
>
>
> Dmesg only shows that the usb bus is detecting a tehcnotrend device 
> Lsusb shows the same.
>
> Can anyone point me in a direction to get it working patches, drivers etc.
>
> Alternatively has the community all together given up on this device.
>
> Sorry for this "non development" question but i don't know where else 
> to turn to. If someone would help me i could make the testing and 
> documentation for the linuxtv site.
>
> Thank you in advance
> JK
>
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead 
> linux-media@vger.kernel.org linux-dvb@linuxtv.org 
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



--
-----------------------------------------------------
38 is NOT a random number!!!!
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html



