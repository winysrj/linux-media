Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56827 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbbCRQUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 12:20:16 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NLF00D8K1KIWV80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Mar 2015 16:24:18 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Philipp Zabel' <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, 'Pawel Osciak' <pawel@osciak.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Sakari Ailus' <sakari.ailus@linux.intel.com>,
	'Nicolas Dufresne' <nicolas.dufresne@collabora.com>
References: <1425637110-12100-1-git-send-email-p.zabel@pengutronix.de>
 <1426589206.3709.14.camel@pengutronix.de> <550851A7.8070004@xs4all.nl>
In-reply-to: <550851A7.8070004@xs4all.nl>
Subject: RE: [PATCH v3 0/5] Signalling last decoded frame by V4L2_BUF_FLAG_LAST
 and -EPIPE
Date: Wed, 18 Mar 2015 17:20:12 +0100
Message-id: <016b01d06197$69e7f6b0$3db7e410$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, March 17, 2015 5:09 PM
> 
> On 03/17/2015 11:46 AM, Philipp Zabel wrote:
> > Hi,
> >
> > Am Freitag, den 06.03.2015, 11:18 +0100 schrieb Philipp Zabel:
> >> At the V4L2 codec API session during ELC-E 2014, we agreed that for
> >> the decoder draining flow, after a V4L2_DEC_CMD_STOP decoder command
> >> was issued, the last decoded buffer should get dequeued with a
> >> V4L2_BUF_FLAG_LAST set. After that, poll should immediately return
> >> and all following VIDIOC_DQBUF should return -EPIPE until the stream
> is stopped or decoding continued via V4L2_DEC_CMD_START.
> >> (or STREAMOFF/STREAMON).
> >>
> >> Changes since v2:
> >>  - Made V4L2_BUF_FLAG_LAST known to trace events
> >>
> >> regards
> >> Philipp
> >>
> >> Peter Seiderer (1):
> >>   [media] videodev2: Add V4L2_BUF_FLAG_LAST
> >>
> >> Philipp Zabel (4):
> >>   [media] videobuf2: return -EPIPE from DQBUF after the last buffer
> >>   [media] coda: Set last buffer flag and fix EOS event
> >>   [media] s5p-mfc: Set last buffer flag
> >>   [media] DocBooc: mention mem2mem codecs for encoder/decoder
> >> commands
> >>
> >>  Documentation/DocBook/media/v4l/io.xml             | 10 ++++++++
> >>  .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |  6 ++++-
> >>  .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |  5 +++-
> >>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |  8 +++++++
> >>  drivers/media/platform/coda/coda-bit.c             |  4 ++--
> >>  drivers/media/platform/coda/coda-common.c          | 27 +++++++++--
> -----------
> >>  drivers/media/platform/coda/coda.h                 |  3 +++
> >>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |  1 +
> >>  drivers/media/v4l2-core/v4l2-mem2mem.c             | 10 +++++++-
> >>  drivers/media/v4l2-core/videobuf2-core.c           | 18
> ++++++++++++++-
> >>  include/media/videobuf2-core.h                     | 10 ++++++++
> >>  include/trace/events/v4l2.h                        |  3 ++-
> >>  include/uapi/linux/videodev2.h                     |  2 ++
> >>  13 files changed, 84 insertions(+), 23 deletions(-)
> >
> > are there any further changes that I should make to this series?
> 
> I'd like to see some Acks, esp. from Kamil and Pawel.
> 
> I'll take another look as well, probably on Friday.

The patches look good IMHO. I am not sure about the order - should the 
patch with code follow the documentation or should it be the other way around?
Anyway, it should be consistent. Here the documentation patches are first and
last, such that first precedes the code and then second follows the change.

Maybe the documentation should be in the same patch that makes the API change?

In the "DocBooc: mention mem2mem codecs for encoder/decoder commands" I would
mention that dequeue can return EPIPE.
 
> Regards,
> 
> 	Hans

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

