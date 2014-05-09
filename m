Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.udag.de ([62.146.106.30]:54768 "EHLO smtp04.udag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbaEIB40 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 May 2014 21:56:26 -0400
Received: from [192.168.0.10] (ip-5-146-193-63.unitymediagroup.de [5.146.193.63])
	by smtp04.udag.de (Postfix) with ESMTPA id 52DCE3FCAB
	for <linux-media@vger.kernel.org>; Fri,  9 May 2014 03:48:52 +0200 (CEST)
Message-ID: <536C3403.8010402@cevel.net>
Date: Fri, 09 May 2014 03:48:51 +0200
From: Tolga Cakir <tolga@cevel.net>
Reply-To: tolga@cevel.net
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Support for Elgato Game Capture HD / MStar MST3367CMK
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone!

Over the past weeks, I've been busy capturing USB packets between the 
Elgato Game Capture HD and my PC. It's using the MStar MST3367CMK chip, 
which seems to have proprietary Linux support available only for 
hardware vendors in form of an SDK. Problem is, that this SDK is 
strictly kept under an NDA, making it kinda impossible for us to get our 
hands on.

So, I got my hands dirty and have found some very good stuff! First of 
all, in contrast to many sources, the Elgato Game Capture HD outputs 
compressed video and audio via USB! It's already encoded, so there is no 
need for reencoding, this will save CPU power. For testing purposes, 
I've only tried capturing 720p data for now, but this should be more 
than enough.

Basically, we need to read raw USB traffic, write an MPEG-TS file 
header, put in the raw USB data and close the file. I'm not super 
experienced in C / kernel development (especially V4L), but I'll give my 
best to get this project forward. My next step is getting a prototype 
working with libusb in userland; after that's done, I'll try porting it 
over to kernel / V4L.

Project page can be found here:
https://github.com/tolga9009/elgato-gchd

USB logs and docs:
v1.0 as 7zip: https://docs.google.com/file/d/0B29z6-xPIPLEQVBMTWZHbUswYjg
v1.0 as rar: https://docs.google.com/file/d/0B29z6-xPIPLEcENMWnh1MklPdTQ
v1.0 as zip: https://docs.google.com/file/d/0B29z6-xPIPLEQWtibWk3T3AtVjA

Is anyone interested in getting involved / taking over? Overall, it 
seems doable and not too complex. I'd be happy about any help! Also, if 
you need more information, just ask me. I'll provide you everything I 
have about this little device.

Cheers,
Tolga Cakir
