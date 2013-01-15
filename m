Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36477 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3AOJfO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 04:35:14 -0500
Message-ID: <50F522AD.8000109@iki.fi>
Date: Tue, 15 Jan 2013 11:34:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/15/2013 04:30 AM, Mauro Carvalho Chehab wrote:

>      v6: Add DocBook documentation.
>      v7: Some fixes as suggested by Antti
>      v8: Documentation fix, compilation fix and name the stats struct,
>          for its reusage inside the core
>      v9: counters need 32 bits. So, change the return data types to
>          s32/u32 types
>      v10: Counters changed to 64 bits for monotonic increment
> 	 Don't create a separate get_stats callback. get_frontend
> 	 is already good enough for it.

Is there way to return BER as rate, or should it be calculated by the 
application (from total and error bit counts)?

You seems to change value to 64 bit already, which is enough. 32bit is 
absolutely too small, it will overflow in seconds (practically around 
10sec when there is radio channel of 32MHz and quite optimal conditions).

It is 64bit returned to userspace, is it? Does 64bit calculations causes 
any complexity of Kernel or app space?

Basically, that API is more complex that I would like to see, but I can 
live with it. I still fear making too complex API causes same problems 
as we has currently... lack of app support.

regards
Antti

-- 
http://palosaari.fi/
