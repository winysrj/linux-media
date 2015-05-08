Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35838 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbbEHNV4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 09:21:56 -0400
Message-ID: <554CB863.1040006@xs4all.nl>
Date: Fri, 08 May 2015 15:21:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 07/18] media controller: rename the tuner entity
References: <cover.1431046915.git.mchehab@osg.samsung.com>	<6d88ece22cbbbaa72bbddb8b152b0d62728d6129.1431046915.git.mchehab@osg.samsung.com>	<554CA862.8070407@xs4all.nl> <20150508095754.1c39a276@recife.lan>
In-Reply-To: <20150508095754.1c39a276@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/08/2015 02:57 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 08 May 2015 14:13:22 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
>>> Finally, let's rename the tuner entity. inside the media subsystem,
>>> a tuner can be used by AM/FM radio, SDR radio, analog TV and digital TV.
>>> It could even be used on other subsystems, like network, for wireless
>>> devices.
>>>
>>> So, it is not constricted to V4L2 API, or to a subdev.
>>>
>>> Let's then rename it as:
>>> 	MEDIA_ENT_T_V4L2_SUBDEV_TUNER -> MEDIA_ENT_T_TUNER
>>
>> See patch 04/18.
> 
> Mapping the tuner as a V4L2_SUBDEV is plain wrong. We can't assume
> that a tuner will always be mapped via V4L2 subdev API.

True. Today we have subdevs that have no device node to control them, so
in that case it would just be a SUBDEV entity. There are subdevs that make
a v4l-subdev device node, so those can be V4L(2)_SUBDEV entities.

The question is: what are your ideas for e.g. DVB-only tuners? Would they
get a DVB-like device node? (so DTV_SUBDEV) Would hybrid tuners have two
device nodes? One v4l-subdev, one dvb/dtv-subdev?

Just curious what your thoughts are.

Brainstorming:

It might be better to map each device node to an entity and each hardware
component (tuner, DMA engine) to an entity, and avoid this mixing of
hw entity vs device node entity.

Hmm, we need a another brainstorm meeting...

Regards,

	Hans
