Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:4005 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZCQTxe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 15:53:34 -0400
Received: by ey-out-2122.google.com with SMTP id 4so47628eyf.37
        for <linux-media@vger.kernel.org>; Tue, 17 Mar 2009 12:53:31 -0700 (PDT)
Message-ID: <49BFFFB9.2090903@gmail.com>
Date: Tue, 17 Mar 2009 20:53:29 +0100
From: Benjamin Zores <benjamin.zores@gmail.com>
Reply-To: benjamin.zores@gmail.com
MIME-Version: 1.0
To: wk <handygewinnspiel@gmx.de>
CC: BOUWSMA Barry <freebeer.bouwsma@gmail.com>,
	benjamin.zores@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] add new frequency table for Strasbourg, France
References: <49BBEFC3.5070901@gmail.com> <alpine.DEB.2.00.0903160803030.4176@ybpnyubfg.ybpnyqbznva> <49BE9B50.5050506@gmail.com> <49BEB20A.1030209@gmx.de> <alpine.DEB.2.00.0903170237550.4176@ybpnyubfg.ybpnyqbznva> <49BFDC24.8050905@gmx.de>
In-Reply-To: <49BFDC24.8050905@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

wk wrote:
> 
>> Then there must be something ``wrong'' with `w_scan' making
>> incorrect assumptions about the data which it's parsing.
>>
>>   
> No - i do not think so.
> All of the frequencies found are with 166kHz offset.
> w_scan does not use any of these 166k offsets, that means this frequency 
> data was transmitted as exactly such a number in some NIT w_scan parsed.
> 
> w_scan calculates DVB-T center freqs as "center freq = (306000000 + 
> channel * 8000000) Hz" for this range.
> And NIT parsing is the same as dvbscan.
> 
>> What has disturbed me is how this offset has been applied
>> across the board by `w_scan',
> Again, w_scan does not use these offsets.

Again, I've added these offsets to w_scan results as it was written in 
linuxtv wiki.

Ben
