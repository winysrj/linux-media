Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46810 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbcCCK1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 05:27:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH for 4.5] media.h: use hex values for the range offsets, move connectors base up.
Date: Thu, 03 Mar 2016 12:27:35 +0200
Message-ID: <2536094.RaAQmbIGIp@avalon>
In-Reply-To: <56D80F76.4050009@xs4all.nl>
References: <56D3FB27.7000202@xs4all.nl> <8424145.Mo5klZhWrz@avalon> <56D80F76.4050009@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 03 March 2016 11:18:30 Hans Verkuil wrote:
> On 03/03/16 11:12, Laurent Pinchart wrote:
> > On Thursday 03 March 2016 11:03:02 Hans Verkuil wrote:
> >> On 03/03/16 10:52, Laurent Pinchart wrote:
> >>> On Monday 29 February 2016 09:02:47 Hans Verkuil wrote:
> >>>> Make the base offset hexadecimal to simplify debugging since the base
> >>>> addresses are hex too.
> >>>> 
> >>>> The offsets for connectors is also changed to start after the
> >>>> 'reserved' range 0x10000-0x2ffff.
> >>>> 
> >>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>> 
> >>>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> >>>> index 95e126e..79960ae 100644
> >>>> --- a/include/uapi/linux/media.h
> >>>> +++ b/include/uapi/linux/media.h
> >>>> @@ -66,17 +66,17 @@ struct media_device_info {
> >>>>  /*
> >>>>   * DVB entities
> >>>>   */
> >>>> -#define MEDIA_ENT_F_DTV_DEMOD		(MEDIA_ENT_F_BASE + 1)
> >>>> -#define MEDIA_ENT_F_TS_DEMUX		(MEDIA_ENT_F_BASE + 2)
> >>>> -#define MEDIA_ENT_F_DTV_CA		(MEDIA_ENT_F_BASE + 3)
> >>>> -#define MEDIA_ENT_F_DTV_NET_DECAP	(MEDIA_ENT_F_BASE + 4)
> >>>> +#define MEDIA_ENT_F_DTV_DEMOD		(MEDIA_ENT_F_BASE + 0x00001)
> >>>> +#define MEDIA_ENT_F_TS_DEMUX		(MEDIA_ENT_F_BASE + 0x00002)
> >>>> +#define MEDIA_ENT_F_DTV_CA		(MEDIA_ENT_F_BASE + 0x00003)
> >>>> +#define MEDIA_ENT_F_DTV_NET_DECAP	(MEDIA_ENT_F_BASE + 0x00004)
> >>>> 
> >>>>  /*
> >>>>   * I/O entities
> >>>>   */
> >>>> -#define MEDIA_ENT_F_IO_DTV		(MEDIA_ENT_F_BASE + 1001)
> >>>> -#define MEDIA_ENT_F_IO_VBI		(MEDIA_ENT_F_BASE + 1002)
> >>>> -#define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 1003)
> >>>> +#define MEDIA_ENT_F_IO_DTV		(MEDIA_ENT_F_BASE + 0x01001)
> >>>> +#define MEDIA_ENT_F_IO_VBI		(MEDIA_ENT_F_BASE + 0x01002)
> >>>> +#define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 0x01003)
> >>>> 
> >>>>  /*
> >>>>   * Analog TV IF-PLL decoders
> >>>> @@ -84,23 +84,23 @@ struct media_device_info {
> >>>>   * It is a responsibility of the master/bridge drivers to create links
> >>>>   * for MEDIA_ENT_F_IF_VID_DECODER and MEDIA_ENT_F_IF_AUD_DECODER.
> >>>>   */
> >>>> -#define MEDIA_ENT_F_IF_VID_DECODER	(MEDIA_ENT_F_BASE + 2001)
> >>>> -#define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 2002)
> >>>> +#define MEDIA_ENT_F_IF_VID_DECODER	(MEDIA_ENT_F_BASE + 0x02001)
> >>>> +#define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 0x02002)
> >>>> 
> >>>>  /*
> >>>>   * Audio Entity Functions
> >>>>   */
> >>>> -#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 3000)
> >>>> -#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 3001)
> >>>> -#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 3002)
> >>>> +#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 0x03000)
> >>> 
> >>> Why does this one start at 0x*000 while the others start at 0x*0001 ? I
> >>> know that the problem predates your patch.
> >> 
> >> I hadn't noticed. It is my personal preference not to start with 0.
> >> But it is not needed in this case, at least not today.
> >> 
> >> I think starting with 1 will help if we ever want to do AND operations
> >> on the ID. Then it is nice that the lower 16 bits can't be 0 for valid
> >> IDs.
> > 
> > I'm fine starting at 1, would you like to resubmit this patch to change
> > that ?
> >
> >>>> +#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 0x03001)
> >>>> +#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 0x03002)
> >>>> 
> >>>>  /*
> >>>>  
> >>>>   * Connectors
> >>>>   */
> >>>>  
> >>>>  /* It is a responsibility of the entity drivers to add connectors and
> >>>>  links
> >>>> 
> >>>> */ -#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 10001)
> >>>> -#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 10002)
> >>>> -#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
> >>>> +#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 0x30001)
> >>> 
> >>> Anything wrong with 0x4xxx ?
> >> 
> >> Possibly overkill, but Sakari preferred to make more generous use of the
> >> 32 bit space. And since there may potentially be a lot of connector types
> >> I thought I gave it plenty of space. Of course, if we ever need that
> >> many, then something is seriously wrong...
> > 
> > And you'd need space *after* the existing connector IDs, not before. Using
> > 0x30000 instead of 0x4000 has the effect of reserving plenty of space for
> > audio functions, not for connectors. I think 0x4000 should be fine.
> 
> Huh? Connectors start at 0x30000, audio entities are 0x03000. I think you
> got confused by that. Connectors can now go from 0x30000-0xffffffff :-)
> Definitely more space than 0x4000-0xffff.

But less than 0x4000-0xffffffff :-) There's no information about how the range 
is supposed to be split. And 4096 connector functions should be more than 
enough.

On a side note, writing "connector functions" really doesn't feel right. We're 
not there yet, this API isn't correct.

> >>>> +#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 0x30002)
> >>>> +#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 0x30003)
> >>>> 
> >>>>  /*
> >>>>   * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and

-- 
Regards,

Laurent Pinchart

