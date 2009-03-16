Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36782 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756441AbZCPUKw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 16:10:52 -0400
Message-ID: <49BEB20A.1030209@gmx.de>
Date: Mon, 16 Mar 2009 21:09:46 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: benjamin.zores@gmail.com
CC: BOUWSMA Barry <freebeer.bouwsma@gmail.com>,
	linux-media@vger.kernel.org,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [PATCH] add new frequency table for Strasbourg, France
References: <49BBEFC3.5070901@gmail.com> <alpine.DEB.2.00.0903160803030.4176@ybpnyubfg.ybpnyqbznva> <49BE9B50.5050506@gmail.com>
In-Reply-To: <49BE9B50.5050506@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Benjamin Zores wrote:
> BOUWSMA Barry wrote:
>
>> First, every frequency is given an offset from the nominal centre
>> frequency of the 8MHz envelope.  I am aware this is common in the
>> UK where the switchover is happening gradually so as not to
>> interfere with adjacent analogue services, and I also know that
>> last I checked, the number of french analogue services I could
>> receive weakly had dropped, but at least one was still visible.
>
> These were discovered through w_scan application.
>
>> +T 482167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
>>
If that information was found by w_scan, that information was found by 
parsing the NIT ot this channel.
Current w_scan doesn't use +/-167k offsets.
Since in Germany no transmitter uses any freq offsets, the information 
comes from the French one.

And for France finding that freq offsets is quite normal.

--wk
