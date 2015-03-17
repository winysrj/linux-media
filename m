Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39932 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718AbbCQQJX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2015 12:09:23 -0400
Message-ID: <550851A7.8070004@xs4all.nl>
Date: Tue, 17 Mar 2015 17:09:11 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH v3 0/5] Signalling last decoded frame by V4L2_BUF_FLAG_LAST
 and -EPIPE
References: <1425637110-12100-1-git-send-email-p.zabel@pengutronix.de> <1426589206.3709.14.camel@pengutronix.de>
In-Reply-To: <1426589206.3709.14.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/17/2015 11:46 AM, Philipp Zabel wrote:
> Hi,
> 
> Am Freitag, den 06.03.2015, 11:18 +0100 schrieb Philipp Zabel:
>> At the V4L2 codec API session during ELC-E 2014, we agreed that for the decoder
>> draining flow, after a V4L2_DEC_CMD_STOP decoder command was issued, the last
>> decoded buffer should get dequeued with a V4L2_BUF_FLAG_LAST set. After that,
>> poll should immediately return and all following VIDIOC_DQBUF should return
>> -EPIPE until the stream is stopped or decoding continued via V4L2_DEC_CMD_START.
>> (or STREAMOFF/STREAMON).
>>
>> Changes since v2:
>>  - Made V4L2_BUF_FLAG_LAST known to trace events
>>
>> regards
>> Philipp
>>
>> Peter Seiderer (1):
>>   [media] videodev2: Add V4L2_BUF_FLAG_LAST
>>
>> Philipp Zabel (4):
>>   [media] videobuf2: return -EPIPE from DQBUF after the last buffer
>>   [media] coda: Set last buffer flag and fix EOS event
>>   [media] s5p-mfc: Set last buffer flag
>>   [media] DocBooc: mention mem2mem codecs for encoder/decoder commands
>>
>>  Documentation/DocBook/media/v4l/io.xml             | 10 ++++++++
>>  .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |  6 ++++-
>>  .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |  5 +++-
>>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |  8 +++++++
>>  drivers/media/platform/coda/coda-bit.c             |  4 ++--
>>  drivers/media/platform/coda/coda-common.c          | 27 +++++++++-------------
>>  drivers/media/platform/coda/coda.h                 |  3 +++
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |  1 +
>>  drivers/media/v4l2-core/v4l2-mem2mem.c             | 10 +++++++-
>>  drivers/media/v4l2-core/videobuf2-core.c           | 18 ++++++++++++++-
>>  include/media/videobuf2-core.h                     | 10 ++++++++
>>  include/trace/events/v4l2.h                        |  3 ++-
>>  include/uapi/linux/videodev2.h                     |  2 ++
>>  13 files changed, 84 insertions(+), 23 deletions(-)
> 
> are there any further changes that I should make to this series?

I'd like to see some Acks, esp. from Kamil and Pawel.

I'll take another look as well, probably on Friday.

Regards,

	Hans

