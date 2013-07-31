Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3GaK66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 06:58:58 -0400
Date: Wed, 31 Jul 2013 07:58:50 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: =?ISO-8859-15?Q?B=E5rd_Eirik_Winther?= <bwinther@cisco.com>
cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv2 FINAL 0/6] qv4l2: add OpenGL rendering and window
 fixes
In-Reply-To: <20227492.r4Kl03Wv4H@bwinther>
Message-ID: <alpine.LFD.2.03.1307310757390.3051@infradead.org>
References: <1375172124-14439-1-git-send-email-bwinther@cisco.com> <20130730101233.2c78cbae@samsung.com> <20227492.r4Kl03Wv4H@bwinther>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-30455688-1375268330=:3051"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-30455688-1375268330=:3051
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 31 Jul 2013, Bård Eirik Winther wrote:

> On Tuesday, July 30, 2013 10:12:33 AM you wrote:
>> Em Tue, 30 Jul 2013 10:15:18 +0200
>> Bård Eirik Winther <bwinther@cisco.com> escreveu:
>>
>> ...
>>
>>> Performance:
>>> All tests are done on an Intel i7-2600S (with Turbo Boost disabled) using the
>>> integrated Intel HD 2000 graphics processor. The mothreboard is an ASUS P8H77-I
>>> with 2x2GB CL 9-9-9-24 DDR3 RAM. The capture card is a Cisco test card with 4 HDMI
>>> inputs connected using PCIe2.0x8. All video input streams used for testing are
>>> progressive HD (1920x1080) with 60fps.
>>
>> I did a quick test here with a radeon HD 7750 GPU on a i7-3770 CPU, using an UVC
>> camera at VGA resolution and nouveau driver (Kernel 3.10.3).
>>
>> qv4l2 CPU usage dropped from 13% to 3,75%.
>>
>> It sounds a nice improvement!
>>
>>
> That is good to hear. My results where achived using the 3.9 and 3.10 kernels
> although I belive that the hardware and opengl driver affects performance the most.
>
> With such a good hardware and relatively low resolution, you wont see that much of a differance :-),

Yes, I know ;)

> but it is a nice improvement indeed. Anyway, nice to get additional tests!

Yeah, that was mainly the reason for the tests: to reproduce it with a 
different setup than yours.

Cheers,
Mauro
--8323328-30455688-1375268330=:3051--
