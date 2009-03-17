Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35849 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754501AbZCQVQy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 17:16:54 -0400
Message-ID: <49C01341.9000501@gmx.de>
Date: Tue, 17 Mar 2009 22:16:49 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: benjamin.zores@gmail.com
CC: BOUWSMA Barry <freebeer.bouwsma@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] add new frequency table for Strasbourg, France
References: <49BBEFC3.5070901@gmail.com> <alpine.DEB.2.00.0903160803030.4176@ybpnyubfg.ybpnyqbznva> <49BE9B50.5050506@gmail.com> <49BEB20A.1030209@gmx.de> <alpine.DEB.2.00.0903170237550.4176@ybpnyubfg.ybpnyqbznva> <49BFDC24.8050905@gmx.de> <49BFFFB9.2090903@gmail.com>
In-Reply-To: <49BFFFB9.2090903@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Benjamin Zores schrieb:
> wk wrote:
>>
>>> Then there must be something ``wrong'' with `w_scan' making
>>> incorrect assumptions about the data which it's parsing.
>>>
>>>   
>> No - i do not think so.
>> All of the frequencies found are with 166kHz offset.
>> w_scan does not use any of these 166k offsets, that means this 
>> frequency data was transmitted as exactly such a number in some NIT 
>> w_scan parsed.
>>
>> w_scan calculates DVB-T center freqs as "center freq = (306000000 + 
>> channel * 8000000) Hz" for this range.
>> And NIT parsing is the same as dvbscan.
>>
>>> What has disturbed me is how this offset has been applied
>>> across the board by `w_scan',
>> Again, w_scan does not use these offsets.
>
> Again, I've added these offsets to w_scan results as it was written in 
> linuxtv wiki.
>
> Ben
>

If you manually edited the frequencies, we can stop searching here. This 
is definitely wrong.

If somebody wrote something like this to linuxtv wiki, we should remove 
that lines.

