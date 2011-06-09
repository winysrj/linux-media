Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4930 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab1FIH63 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 03:58:29 -0400
Message-ID: <787a017d1dbd311ae8ad7e1290724578.squirrel@webmail.xs4all.nl>
In-Reply-To: <201106090908.41992.hverkuil@xs4all.nl>
References: <20110608172311.0d350ab7@pedra> <4DF01FEB.4050205@redhat.com>
    <201106090908.41992.hverkuil@xs4all.nl>
Date: Thu, 9 Jun 2011 09:58:26 +0200
Subject: Re: RFC] Media kernelspace-userspace API specs (V4L/DVB/IR) - Was:
 Re: [PATCH 00/13] Reduce the gap between DVBv5 API and the specs
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>> AUDIO_SET_EXT_ID
>> AUDIO_SET_ATTRIBUTES
>> AUDIO_SET_KARAOKE
>> VIDEO_SET_SYSTEM
>> VIDEO_SET_HIGHLIGHT
>> VIDEO_SET_SPU
>> VIDEO_SET_SPU_PALETTE
>> VIDEO_GET_NAVI
>> VIDEO_SET_ATTRIBUTES
>> VIDEO_SET_ID
>> VIDEO_GET_FRAME_RATE
>
> These are only seen in audio.h/video.h and fs/compat_ioctl.c. Remove these
> ioctls + associated structs?

I meant of course: 'mark for removal'.

Basically all the AUDIO, VIDEO and OSD ioctls should be removed eventually
as a general API: they are really a poor-man's V4L and have nothing to do
with DVB.

The first step is to get ivtv converted so that av7110 is the only one
still using them. ivtv will still need to have a small backwards
compatibility layer, but at least there is no more need to keep these
ioctls in DocBook.

Regards,

     Hans

