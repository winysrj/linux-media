Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2929 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab1FHU7k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 16:59:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/13] Reduce the gap between DVBv5 API and the specs
Date: Wed, 8 Jun 2011 22:59:33 +0200
References: <20110608172311.0d350ab7@pedra>
In-Reply-To: <20110608172311.0d350ab7@pedra>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106082259.33770.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 08, 2011 22:23:11 Mauro Carvalho Chehab wrote:
> There's a huge gap between the DVB specs and the current implementation.
> This were caused by years of changes that happened at the code but
> no updates to the specs were done.
> 
> This patch series tries to reduce this gap.
> 
> Basically, the headers at include/linux/dvb were included at the API.
> The Makefile scripting auto-generate references for structs, typedefs
> and ioctls. With this, it is now easy to identify when something is
> missing.
> 
> After adding such logic, I've manually synchronized the specs with the
> header file and updated the data structures.
> 
> The work is not complete yet: there are still several ioctl's not
> documented at the specs:
> 
> Error: no ID for constraint linkend: AUDIO_BILINGUAL_CHANNEL_SELECT.
...
> Error: no ID for constraint linkend: VIDEO_GET_SIZE.
> Error: no ID for constraint linkend: VIDEO_GET_FRAME_RATE.
> Error: no ID for constraint linkend: VIDEO_GET_PTS.
> Error: no ID for constraint linkend: VIDEO_GET_FRAME_COUNT.
> Error: no ID for constraint linkend: VIDEO_COMMAND.
> Error: no ID for constraint linkend: VIDEO_TRY_COMMAND.

A lot of these video/audio commands should be converted to V4L ioctls.

VIDEO_COMMAND and VIDEO_TRY_COMMAND should become VIDIOC_(TRY_)DECODER_CMD,
the others can either be integrated into VIDIOC_DECODER_CMD or become
(read-only) controls or something similar. Or just dropped if no apps use them.

The only drivers that use these at the moment are ivtv and av7110. At least for
ivtv I'd love to switch to V4L ioctls (documented and all) and leave the old
VIDEO/AUDIO ioctls as specific to av7110 (just like osd.h).

Realistically this would be a job for me, but I am still way too busy to
tackle something like this.

> I also opted to not add the osd.h header into the DocBook, as it seemed
> odd on my eyes, and it is used only by one legacy hardware.
> 
> While here, I noticed that one audio ioctl is not used anyware
> (AUDIO_GET_PTS). There is just the ioctl definition and that's it. 
> I just removed this definition, as removing it won't cause any 
> regression, as no in-kernel driver or dvb-core uses it.

It was originally planned to be used in ivtv, but this never happened.

> Btw, there are several ioctl's and correponding data structures that
> are used on just one or two old drivers. I think we should consider
> to deprecate those old stuff.

Which? If you have a list of those, then that would make for an interesting
RFC.

Regards,

	Hans

> 
> Mauro Carvalho Chehab (13):
>   [media] DocBook: Add the other DVB API header files
>   [media] DocBook/audio.xml: match section ID's with the reference links
>   [media] DocBook/audio.xml: synchronize attribute changes
>   [media] DocBook: Document AUDIO_CONTINUE ioctl
>   [media] dvb/audio.h: Remove definition for AUDIO_GET_PTS
>   [media] Docbook/ca.xml: match section ID's with the reference links
>   [media] DocBook/ca.xml: Describe structure ca_pid
>   [media] DocBook/demux.xml: Fix section references with dmx.h.xml
>   [media] DocBook/demux.xml: Add the remaining data structures to the API spec
>   [media] DocBook/net.xml: Synchronize Network data structure
>   [media] DocBook/Makefile: Remove osd.h header
>   [media] DocBook/video.xml: Fix section references with video.h.xml
>   [media] DocBook/video.xml: Document the remaining data structures
> 
>  Documentation/DocBook/media/Makefile       |   81 ++++++++++-
>  Documentation/DocBook/media/dvb/audio.xml  |  176 +++++++++++++++--------
>  Documentation/DocBook/media/dvb/ca.xml     |  106 ++++++++------
>  Documentation/DocBook/media/dvb/demux.xml  |  206 +++++++++++++++-----------
>  Documentation/DocBook/media/dvb/dvbapi.xml |   20 +++
>  Documentation/DocBook/media/dvb/intro.xml  |   19 +++-
>  Documentation/DocBook/media/dvb/net.xml    |   17 ++
>  Documentation/DocBook/media/dvb/video.xml  |  220 +++++++++++++++++-----------
>  include/linux/dvb/audio.h                  |   14 +--
>  9 files changed, 564 insertions(+), 295 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
