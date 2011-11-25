Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1KYQAc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 11:00:32 -0500
Message-ID: <4ECFBB9C.3060100@redhat.com>
Date: Fri, 25 Nov 2011 14:00:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andreas Oberritter <obi@linuxtv.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <4ECF9038.6050208@linuxtv.org> <4ECFB1DC.2090304@redhat.com> <201111251625.44135.hverkuil@xs4all.nl>
In-Reply-To: <201111251625.44135.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-11-2011 13:25, Hans Verkuil escreveu:
> On Friday, November 25, 2011 16:18:52 Mauro Carvalho Chehab wrote:
>> The V4L2 API complements the ALSA API. Audio streaming, audio format negotiation
>> etc are via the ALSA API.
>>
>>> Can you control pass-through of digital audio to SPDIF for example? Can
>>> you control which decoder should be the master when synchronizing AV?
>>
>> Patches for that are being proposed and should be merged soon. They are part
>> of the set of patches under discussion with ALSA people, as part of the Media
>> Controller API.
> 
> Can you provide a link to those patches? I haven't seen anything cross-posted
> to linux-media.

That was my understanding when I was discussing with Sakari about the MC presentation
for KS. I'll double check with him if he can provide us more details about the
status of this subject.

Regards,
Mauro
