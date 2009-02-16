Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:37598 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZBPO5T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 09:57:19 -0500
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KF500942YVFMGK0@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 16 Feb 2009 09:57:15 -0500 (EST)
Date: Mon, 16 Feb 2009 09:57:14 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [linux-dvb] DViCO FusionHDTV7 Dual Express
In-reply-to: <1234772447.26272.0.camel@novak.chem.klte.hu>
To: linux-media@vger.kernel.org
Cc: CityK <cityk@rogers.com>, linux-dvb@linuxtv.org
Message-id: <49997ECA.9020106@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
References: <e32e0e5d0902051548x3023851cua78424304a09cb7e@mail.gmail.com>
 <49989D42.8040008@rogers.com> <1234772447.26272.0.camel@novak.chem.klte.hu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Levente Novák wrote:
> 2009. 02. 15, vasárnap keltezéssel 17.54-kor CityK ezt írta:
>> Tim Lucas wrote:
>>> My cable system was recently updated to time warner so I thought I
>>> would try to get the mythbuntu box working again.  
>>> I have the DViCO FusionHDTV7 Dual Express card which seems to be
>>> recognized by my system but I still cannot tune channels. I tried
>>> using tvtime and got the following error
>>>
>>> I/O error : Permission denied
>>> Cannot change owner of /home/lucas/.tvtime/tvtime.xml: Permission denied.
>>> videoinput: Cannot open capture device /dev/video0: No such file or
>>> directory.
>> Analog is currently not supported by the cx23885 driver
> 
> Only for the DViCO FusionHDTV7 Dual Express or for all cx23885-based
> cards?

We support analog on some cx23885 boards, not the dvico.

- Steve
