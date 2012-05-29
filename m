Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab2E2IVQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 04:21:16 -0400
Message-ID: <4FC48703.6060104@redhat.com>
Date: Tue, 29 May 2012 10:21:23 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	halli manjunatha <hallimanju@gmail.com>
Subject: Re: [RFCv2 PATCH 0/5] Add hwseek caps and frequency bands
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl> <4FC35F8F.7090703@redhat.com> <201205281358.40725.hverkuil@xs4all.nl>
In-Reply-To: <201205281358.40725.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/28/2012 01:58 PM, Hans Verkuil wrote:
> On Mon May 28 2012 13:20:47 Hans de Goede wrote:
>> Hi,
>>
>> Looks good, the entire series is:
>>
>> Acked-by: Hans de Goede<hdegoede@redhat.com>
>>
>> I was thinking that it would be a good idea to add a:
>> #define V4L2_TUNER_CAP_BANDS_MASK 0x001f0000
>>
>> to videodev2.h, which apps can then easily use to test
>> if the driver supports any bands other then the default,
>> and decide to show band selection elements of the UI or
>> not based on a test on the tuner-caps using that mask.
>>
>> This can be done in a separate patch, or merged into
>> "PATCH 4/6 videodev2.h: add frequency band information"
>
> Good idea, I've merged it into patch 4 and 5 (documenting it).
>
> It's here:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/bands

New version still look good, so the entire series still is:

Acked-by: Hans de Goede<hdegoede@redhat.com>

:)

Regards,

Hans
