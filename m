Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab1LHPGR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Dec 2011 10:06:17 -0500
Message-ID: <4EE0D264.4090306@redhat.com>
Date: Thu, 08 Dec 2011 13:06:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Fredrik Lingvall <fredrik.lingvall@gmail.com>
CC: Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Subject: Re: HVR-930C DVB-T mode report
References: <CAKdnbx5JaCp71kqxH6sO4r35rb28UjOHmL7eD4e7bHtbYFgn5g@mail.gmail.com> <4EE08D88.2070806@redhat.com> <4EE0C312.90401@gmail.com>
In-Reply-To: <4EE0C312.90401@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08-12-2011 12:00, Fredrik Lingvall wrote:
> On 12/08/11 11:12, Mauro Carvalho Chehab wrote:
>>> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
>>> Scanning 7MHz frequencies...
>>> 177500: (time: 00:00)
>>> 184500: (time: 00:03)
>>>
>>> [...]
>>> 834000: (time: 02:46) (time: 02:48)
>>> 842000: (time: 02:50)
>>> 850000: (time: 02:52) (time: 02:55)
>>> 858000: (time: 02:56) (time: 02:58)
>>>
>>> ERROR: Sorry - i couldn't get any working frequency/transponder
>>> Nothing to scan!!
>>
>>
>> With regards to Italy, w_scan does something different than scan. The auto-italy
>> table used by scan tries several channels with both 8MHz and 7MHz, while w_scan
>> only tries 7MHz for VHF. This might explain the issue, if you're still able to
>> scan/tune with scan and if you have a good antenna.
>>>
>>>
>>> Regards
>>>
>>> Eddi
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> Are there similar problems while scanning DVB-C nets with w_scan?
>
> And, is there a "scan everything" table for dvbscan?

No. Both w_scan/dvbscan get the same channels, and they match the channels
available at the STB and with other boards.

Btw, drivers/media/common/tuners/xc5000.c doesn't support 7MHz for DVB-T:

		case BANDWIDTH_7_MHZ:
			printk(KERN_ERR "xc5000 bandwidth 7MHz not supported\n");
			return -EINVAL;

This may explain why you're getting so few channels on it. Only channels marked as
8MHz will be tuned.

I _suspect_ that:
		case BANDWIDTH_7_MHZ:
		case BANDWIDTH_8_MHZ:
			priv->bandwidth = BANDWIDTH_8_MHZ;
			priv->video_standard = DTV8;
			priv->freq_hz = params->frequency - 2750000;
			break;

would be the right thing to do.

Regards,
Mauro
