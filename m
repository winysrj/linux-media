Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab1LJLSs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 06:18:48 -0500
Message-ID: <4EE34013.7030803@redhat.com>
Date: Sat, 10 Dec 2011 09:18:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>
Subject: Re: [PATCHv2] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
References: <4EE252E5.2050204@iki.fi> <1323457212-13507-1-git-send-email-mchehab@redhat.com> <201112100500.13365@orion.escape-edv.de>
In-Reply-To: <201112100500.13365@orion.escape-edv.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10-12-2011 02:00, Oliver Endriss wrote:
> On Friday 09 December 2011 20:00:12 Mauro Carvalho Chehab wrote:
>> The DRX-K doesn't change the delivery system at set_properties,
>> but do it at frontend init. This causes problems on programs like
>> w_scan that, by default, opens both frontends.
>>
>> Use adap->mfe_shared in order to prevent this, and be sure that Annex A
>> or C are properly selected.
>>
>> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>> ---
>>
>> v2: Use mfe_shared
>>
>>   drivers/media/dvb/frontends/drxk_hard.c |   16 ++++++++++------
>>   drivers/media/dvb/frontends/drxk_hard.h |    2 ++
>>   drivers/media/video/em28xx/em28xx-dvb.c |    4 ++++
>>   3 files changed, 16 insertions(+), 6 deletions(-)
> ...
>
> Please commit Manu's patch to 'Query DVB frontend delivery capabilities'.
> Then you will no longer have to struggle with multi-frontend problems.

I was waiting for him to submit the new version, as there were several
comments on the last series. Just checked that he submitted the new
version today. That will be a great improvement!

> We could finally get rid of having 2 mutual-exclusive frontends, which
> is just an ugly workaround, barely covered by the API spec...

Agreed.

Regards,
Mauro.
