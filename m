Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58203 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161912AbbKTOll (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 09:41:41 -0500
Subject: Re: PID filter testing
To: Benjamin Larsson <benjamin@southpole.se>,
	=?UTF-8?Q?Honza_Petrou=c5=a1?= <jpetrous@gmail.com>
References: <564EFD40.8050504@southpole.se>
 <CAJbz7-2=-ufqdE0YyPUAhV+UybMsmEv7=FuFhrn6o9G7yvXZOg@mail.gmail.com>
 <564F2D77.9080301@southpole.se>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <564F3123.8040109@iki.fi>
Date: Fri, 20 Nov 2015 16:41:39 +0200
MIME-Version: 1.0
In-Reply-To: <564F2D77.9080301@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/20/2015 04:25 PM, Benjamin Larsson wrote:
> On 11/20/2015 02:27 PM, Honza Petrouš wrote:
>> 2015-11-20 12:00 GMT+01:00 Benjamin Larsson <benjamin@southpole.se>:
>>> Hi, what tools can I use to test pid filter support in the drivers ?
>>
>> Zap utility from dvbapps seems to be some simpler way - you can pass them
>> the fixed pids and record filtered data by simple command.
>>
>> See at:
>> http://www.linuxtv.org/wiki/index.php/Zap
>>
>> /Honza
>
> Hi, can you elaborate with a command line example ? To start with I want
> only the 0x1fff pid from a random dvb-c mux.

hmm, that is null pid for padding ts to correct size IIRC. Take into 
account that some pid filters / bridges automatically filter it out. 
Usually it is there though.

So it is not very good pid to test. If you want test some pid which is 
always there look those mandatory pids which are pids numbered near 0.

regards
Antti

-- 
http://palosaari.fi/
