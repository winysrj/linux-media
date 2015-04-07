Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53698 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbbDGOoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 10:44:07 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NMF00AXAYG0KC50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Apr 2015 15:48:00 +0100 (BST)
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
Date: Tue, 07 Apr 2015 16:44:03 +0200
Message-id: <027f01d07141$4b600020$e2200060$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
Sent: Tuesday, March 17, 2015 5:09 PM
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
> 

The patches look good to me, the 4th version is already queued in my tree.
However I would like to see your opinion. Especially from you Pawel :)

Best wishes,
Kamil 

