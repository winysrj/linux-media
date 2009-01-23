Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out112.alice.it ([85.37.17.112]:3085 "EHLO
	smtp-out112.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZAWRCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 12:02:08 -0500
From: "Wayne and Holly" <wayneandholly@alice.it>
To: <linux-media@vger.kernel.org>, <linux-dvb@linuxtv.org>
Subject: RE: [linux-dvb] Which firmware for cx23885 and xc3028?
Date: Fri, 23 Jan 2009 18:01:08 +0100
Message-ID: <000001c97d7c$3005c130$0202a8c0@speedy>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1232715400.13587.12.camel@novak.chem.klte.hu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-dvb-bounces@linuxtv.org 
> [mailto:linux-dvb-bounces@linuxtv.org] On Behalf Of Levente Novák
> Sent: Friday, 23 January 2009 1:57 p.m.
> To: linux-dvb@linuxtv.org
> Subject: [linux-dvb] Which firmware for cx23885 and xc3028?
> 
> 
> I am trying to make an AverMedia AverTV Hybrid Express (A577) 
> work under Linux. It seems all major chips (cx23885, xc3028 
> and af9013) are already supported, so it should be doable in 
> principle.
> 
> I am stuck a little bit since AFAIK both cx23885 and xc3028 
> need an uploadable firmware. Where should I download/extract 
> such firmware from? I tried Steven Toth's repo (the Hauppauge 
> HVR-1400 seems to be built around these chips as well) but 
> even after copying the files under /lib/firmware it didn't 
> really work. I tried to specify different cardtypes for the 
> cx23885 module. For cardtype=2 I got a /dev/video0 and a 
> /dev/video1 (the latter is of course unusable, I don't have a 
> MPEG encoder chip on my card) but tuning was unsuccesful. All 
> the other types I tried either didn't work at all or only 
> resulted in dvb devices detected. For the moment, I am fine 
> without DVB, and are interested mainly in analog devices.
> 
> Maybe I should locate the windows driver of my card and 
> extract the firmware files from it? If so, how do I proceed?
> 
> Thanks in advance!
> 
> Levente
> 
> 


Have you followed these instructions?:
http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the
_Firmware

Cheers
Wayne

