Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp119.rog.mail.re2.yahoo.com ([68.142.224.74]:20909 "HELO
	smtp119.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750769AbZAYSco (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 13:32:44 -0500
Message-ID: <497CB04C.1010603@rogers.com>
Date: Sun, 25 Jan 2009 13:32:44 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl> <200901182241.10047.hverkuil@xs4all.nl> <4973BD03.4060702@rogers.com> <200901190853.19327.hverkuil@xs4all.nl> <497CAB2F.7080700@rogers.com>
In-Reply-To: <497CAB2F.7080700@rogers.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CityK wrote:
> Hans wrote:
>> CityK wrote:
>>     
>>> In regards to the tuner type being set twice, that is precisely my point
>>> -- its peculiar and not symptomatic of normal behaviour.  That is why I
>>> asked whether you expected it to do this    
>>>       
>> I think it is OK. The second setup is probably done by dvb_attach() in 
>> saa7134-dvb.c, line 1191. Can you verify that with a debug message?  
>>     
> Could not verify.  (dmesg output provided below at end).
>   

Actually, looking at the dmesg output now, it is apparent that you are
correct:

dvb_init() allocating 1 frontend

So, its a case of a bit of redundancy now.
