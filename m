Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58348 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933421Ab3CGVTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Mar 2013 16:19:16 -0500
References: <20130306183604.3015c1f0@endymion.delvare> <51379EB3.3040900@schinagl.nl>
In-Reply-To: <51379EB3.3040900@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: drxk driver statistics
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 07 Mar 2013 16:18:41 -0500
To: oliver+list@schinagl.nl, Jean Delvare <khali@linux-fr.org>
CC: Linux Media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Message-ID: <1682f22b-3a4a-4473-b22e-c8cce3477092@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oliver Schinagl <oliver@schinagl.nl> wrote:

>On 03/06/13 18:36, Jean Delvare wrote:
>> Hi all,
>>
>> I have a TerraTec Cinergy T PCIe Dual card, with DRX-3916K and
>> DRX-3913K frontends. I am thus using the drxk dvb-frontend driver.
>> While trying to find the best antenna, position and amplification, I
>> found that the statistics returned by the drxk driver look quite bad:
>>
>> $ femon -H 3
>> FE: DRXK DVB-T (DVBT)
>> status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 |
>FE_HAS_LOCK
>> status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 |
>FE_HAS_LOCK
>> status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 |
>FE_HAS_LOCK
>>
>> This is with TV looking reasonably good, so these figures are not
>> plausible.
>>
>> $ femon 10
>> FE: DRXK DVB-T (DVBT)
>> status SCVYL | signal 00de | snr 00f5 | ber 00000000 | unc 000097a6 |
>FE_HAS_LOCK
>> status SCVYL | signal 00f0 | snr 00f5 | ber 00000000 | unc 000097a6 |
>FE_HAS_LOCK
>> status SCVYL | signal 0117 | snr 00f6 | ber 00000000 | unc 000097a6 |
>FE_HAS_LOCK
>> status SCVYL | signal 00b6 | snr 00eb | ber 00000000 | unc 000097a6 |
>FE_HAS_LOCK
>> status SCVYL | signal 00d1 | snr 00e7 | ber 00000000 | unc 000097a6 |
>FE_HAS_LOCK
>> status SCVYL | signal 0073 | snr 00ea | ber 00000000 | unc 000097a6 |
>FE_HAS_LOCK
>> status SCVYL | signal 00a3 | snr 00ee | ber 00000000 | unc 000097a6 |
>FE_HAS_LOCK
>> status SCVYL | signal 00b5 | snr 00f4 | ber 00000000 | unc 000097a6 |
>FE_HAS_LOCK
>> status SCVYL | signal 00ba | snr 00f3 | ber 00000000 | unc 000097a6 |
>FE_HAS_LOCK
>> status SCVYL | signal 00be | snr 00f0 | ber 00000000 | unc 000097a6 |
>FE_HAS_LOCK
>>
>> Signal values are changing too much, snr is stable enough but way too
>> low, ber is apparently unimplemented, and unc is never reset AFAICS
>(it
>> started at 1 when the system started and has been only increasing
>since
>> then.) On my previous card, unc was an instant measurement, not a
>> cumulative value, not sure which is correct.
>Yes I found that out aswell, but since image quality has always been 
>very fine, I haven't looked what this all should be.
>>
>> I would like to see these statistics improved. I am willing to help,
>> however the drxk driver is rather complex (at least to my eyes) and I
>> do not have a datasheet so I wouldn't know where to start. Is there
>> anyone who can work on this and/or provide some guidance?
>>
>> Thanks,
>>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Unc should be a cumulative value and not reset after each read.  Then you can support a use case of 2 different apps monitoring the statistics.

I can't recall when exactly unc should be reset, but of frequency change sounds reasonable.

Regards,
Andy
