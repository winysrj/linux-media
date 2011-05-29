Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab1E2M6k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 08:58:40 -0400
Message-ID: <4DE242FA.8010400@redhat.com>
Date: Sun, 29 May 2011 09:58:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
Subject: Re: [RFCv2] Add a library to retrieve associated media devices -
 was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <4DE120D1.2020805@redhat.com> <4DE19AF7.2000401@redhat.com> <201105291319.47207.hverkuil@xs4all.nl> <bcae2b56-57c0-4936-b4c5-1d57f65125fc@email.android.com>
In-Reply-To: <bcae2b56-57c0-4936-b4c5-1d57f65125fc@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-05-2011 08:47, Andy Walls escreveu:
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> Each device type that is known by the API is defined inside enum
>> device_type,
>>> currently defined as:
>>>
>>> 	enum device_type {
>>> 		UNKNOWN = 65535,
>>> 		NONE    = 65534,
>>> 		MEDIA_V4L_VIDEO = 0,
>>
>> Can you add MEDIA_V4L_RADIO as well? And MEDIA_V4L_SUBDEV too.
>>
>>> 		MEDIA_V4L_VBI,
>>> 		MEDIA_DVB_FRONTEND,
>>
>> It might be better to start at a new offset here, e.g.
>> MEDIA_DVB_FRONTEND = 100
>> Ditto for SND. That makes it easier to insert new future device nodes.
>>
>>> 		MEDIA_DVB_DEMUX,
>>> 		MEDIA_DVB_DVR,
>>> 		MEDIA_DVB_NET,
>>> 		MEDIA_DVB_CA,
>>> 		MEDIA_SND_CARD,
>>> 		MEDIA_SND_CAP,
>>> 		MEDIA_SND_OUT,
>>> 		MEDIA_SND_CONTROL,
>>> 		MEDIA_SND_HW,
>>

> Framebuffer devices are missing from the list.  Ivtv provides one at the moment.

Please send us a patch adding it against v4l-utils. I'm not sure how fb devices 
appear at sysfs.

Thanks,
Mauro
