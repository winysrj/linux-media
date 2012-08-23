Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37852 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395Ab2HWLNC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 07:13:02 -0400
Subject: Re: RFC: Core + Radio profile
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mike Isely at pobox <isely@pobox.com>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Date: Thu, 23 Aug 2012 07:12:24 -0400
In-Reply-To: <50352044.7040104@redhat.com>
References: <201208221140.25656.hverkuil@xs4all.nl>
	 <201208221211.47842.hverkuil@xs4all.nl> <5034E1C2.30205@redhat.com>
	 <alpine.DEB.2.00.1208221013110.8031@cnc.isely.net>
	 <50352044.7040104@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1345720345.2484.11.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-08-22 at 15:09 -0300, Mauro Carvalho Chehab wrote:
> Em 22-08-2012 12:19, Mike Isely escreveu:
> > On Wed, 22 Aug 2012, Mauro Carvalho Chehab wrote:
> > 
> >> Em 22-08-2012 07:11, Hans Verkuil escreveu:
> >>> I've added some more core profile requirements.
> >>
> >>>>
> >>>> Streaming I/O is not supported by radio nodes.
> >>
> >> 	Hmm... pvrusb2/ivtv? Ok, it makes sense to move it to use the alsa
> >> mpeg API there. If we're enforcing it, we should deprecate the current way
> >> there, and make it use ALSA.
> > 
> > I am unaware of any ALSA MPEG API.  It's entirely likely that this is 
> > because I haven't been paying attention.  Nevertheless, can you please 
> > point me at any documentation on this so I can get up to speed?
> 
> 
> I don't know much about that. A grep at sound might help:
> 
> $ git grep -i mpeg sound/
> sound/core/oss/pcm_oss.c: case AFMT_MPEG:         return SNDRV_PCM_FORMAT_MPEG;
> sound/core/oss/pcm_oss.c: case SNDRV_PCM_FORMAT_MPEG:             return AFMT_MPEG;
> sound/core/pcm.c: FORMAT(MPEG),
> sound/core/pcm.c: case AFMT_MPEG:
> sound/core/pcm.c:         return "MPEG";
> sound/core/pcm_misc.c:    [SNDRV_PCM_FORMAT_MPEG] = {

> sound/usb/format.c:       case UAC_FORMAT_TYPE_II_MPEG:
> sound/usb/format.c:               fp->formats = SNDRV_PCM_FMTBIT_MPEG;
> sound/usb/format.c:               snd_printd(KERN_INFO "%d:%u:%d : unknown format tag %#x is detected.  processed as MPEG.\n",
> sound/usb/format.c:               fp->formats = SNDRV_PCM_FMTBIT_MPEG;
> 
> 
> > 
> > Currently the pvrusb2 driver does not attempt to perform any processing 
> > or filtering of the data stream, so radio data is just the same mpeg 
> > stream as video (but without any real embedded video data).  If I have 
> > to get into the business of processing the MPEG data in order to adhere 
> > to this proposal, then that will be a very big deal for this driver.
> 
> I _suspect_ that it is just a matter of adding something like em28xx-audio
> at pvrusb2, saying that the format is MPEG, instead of raw PCM. In-kernel
> processing is likely not needed/wanted.

The ivtv and cx18 drivers ask the CX2341[568] to produce a raw PCM audio
stream and provide that PCM audio via the legacy /dev/video24 device,
and via ALSA as well in the case of cx18.

>From what I can tell, the pvrusb2 driver does not use the raw PCM stream
the CX23416/7 is able to produce.  Instead, pvrusb2 appears to "mute"
the video and provides then whole MPEG-2 PS in radio mode.  That means
there is a full MPEG-2 PS container stream with both the audio ES and
video ES in it.

If something in user-space needs to get PCM or MPEG-1 Layer 3 audio from
that pvrusb2 "audio" stream via ALSA, something is going to need to
demux the MPEG-2 PS and possibly convert to PCM.  I'll bet ALSA
currently does not support that except maybe via some ALSA plug-in which
likely does not exist.

At that point, it might be easier just to use the PCM stream from the
CX23416 and add a pvrusb2-alsa module for the ALSA interface.

Regards,
Andy

> We may try to double check with Takashi during the KS media workshop.
> 
> Regards,
> Mauro


