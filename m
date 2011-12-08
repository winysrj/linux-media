Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44947 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab1LHOAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2011 09:00:55 -0500
Received: by eekd41 with SMTP id d41so1171557eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Dec 2011 06:00:54 -0800 (PST)
Message-ID: <4EE0C312.90401@gmail.com>
Date: Thu, 08 Dec 2011 15:00:50 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Subject: Re: HVR-930C DVB-T mode report
References: <CAKdnbx5JaCp71kqxH6sO4r35rb28UjOHmL7eD4e7bHtbYFgn5g@mail.gmail.com> <4EE08D88.2070806@redhat.com>
In-Reply-To: <4EE08D88.2070806@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/11 11:12, Mauro Carvalho Chehab wrote:
>> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
>> Scanning 7MHz frequencies...
>> 177500: (time: 00:00)
>> 184500: (time: 00:03)
>>
>> [...]
>> 834000: (time: 02:46) (time: 02:48)
>> 842000: (time: 02:50)
>> 850000: (time: 02:52) (time: 02:55)
>> 858000: (time: 02:56) (time: 02:58)
>>
>> ERROR: Sorry - i couldn't get any working frequency/transponder
>>   Nothing to scan!!
>
>
> With regards to Italy, w_scan does something different than scan. The 
> auto-italy
> table used by scan tries several channels with both 8MHz and 7MHz, 
> while w_scan
> only tries 7MHz for VHF. This might explain the issue, if you're still 
> able to
> scan/tune with scan and if you have a good antenna.
>>
>>
>> Regards
>>
>> Eddi
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Are there similar problems while scanning DVB-C nets with w_scan?

And, is there a "scan everything" table for dvbscan?

Regards,

Fredrik
