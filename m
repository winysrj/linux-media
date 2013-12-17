Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52927 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab3LQQqJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 11:46:09 -0500
Message-ID: <52B07FCF.9070404@iki.fi>
Date: Tue, 17 Dec 2013 18:46:07 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v3 0/7] SDR API
References: <1387231688-8647-1-git-send-email-crope@iki.fi> <52AFFF1B.4070809@xs4all.nl>
In-Reply-To: <52AFFF1B.4070809@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.12.2013 09:36, Hans Verkuil wrote:
> On 12/16/2013 11:08 PM, Antti Palosaari wrote:
>> Now with some changes done requested by Hans.
>> I did not agree	very well that VIDIOC_G_FREQUENCY tuner type check
>> exception, but here it is...
>>
>> Also two patches, as example, conversion of msi3101 and rtl2832_sdr
>> drivers to that API.
>>
>> regards
>> Antti
>>
>> Antti Palosaari (7):
>>    v4l: add new tuner types for SDR
>>    v4l: 1 Hz resolution flag for tuners
>>    v4l: add stream format for SDR receiver
>>    v4l: define own IOCTL ops for SDR FMT
>>    v4l: enable some IOCTLs for SDR receiver
>
> Is it just too early in the day or is the patch adding VFL_TYPE_SDR and
> the swradio device missing in this patch series?

My mistake. Just selected off-by-one starting patch. I will add that to 
next try at the same time I send documentation changes.

regards
Antti

-- 
http://palosaari.fi/
