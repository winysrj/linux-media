Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38699 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbbDHKZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 06:25:51 -0400
Received: by wiun10 with SMTP id n10so52402781wiu.1
        for <linux-media@vger.kernel.org>; Wed, 08 Apr 2015 03:25:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <027f01d07141$4b600020$e2200060$%debski@samsung.com>
References: <1425637110-12100-1-git-send-email-p.zabel@pengutronix.de>
 <1426589206.3709.14.camel@pengutronix.de> <550851A7.8070004@xs4all.nl> <027f01d07141$4b600020$e2200060$%debski@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Wed, 8 Apr 2015 19:19:29 +0900
Message-ID: <CAMm-=zDxfig-8O9PMvN_ZX86rQka8iyufBYptEG6G0KHGYTPfA@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Signalling last decoded frame by
 V4L2_BUF_FLAG_LAST and -EPIPE
To: Kamil Debski <k.debski@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	LMML <linux-media@vger.kernel.org>, kernel@pengutronix.de,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Apr 7, 2015 at 11:44 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Hi,
>
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, March 17, 2015 5:09 PM
>>
>> On 03/17/2015 11:46 AM, Philipp Zabel wrote:
>> > Hi,
>> >
>> > Am Freitag, den 06.03.2015, 11:18 +0100 schrieb Philipp Zabel:
>> >> At the V4L2 codec API session during ELC-E 2014, we agreed that for
>> >> the decoder draining flow, after a V4L2_DEC_CMD_STOP decoder command
>> >> was issued, the last decoded buffer should get dequeued with a
>> >> V4L2_BUF_FLAG_LAST set. After that, poll should immediately return
>> >> and all following VIDIOC_DQBUF should return -EPIPE until the stream
>> is stopped or decoding continued via V4L2_DEC_CMD_START.
>> >> (or STREAMOFF/STREAMON).
>> >>
>> >> Changes since v2:
>> >>  - Made V4L2_BUF_FLAG_LAST known to trace events
>> >>
>> >> regards
>> >> Philipp
>> >>
>> >> Peter Seiderer (1):
>> >>   [media] videodev2: Add V4L2_BUF_FLAG_LAST
>> >>
>> >> Philipp Zabel (4):
>> >>   [media] videobuf2: return -EPIPE from DQBUF after the last buffer
>> >>   [media] coda: Set last buffer flag and fix EOS event
>> >>   [media] s5p-mfc: Set last buffer flag
>> >>   [media] DocBooc: mention mem2mem codecs for encoder/decoder
>> >> commands
>> >>
>> >>  Documentation/DocBook/media/v4l/io.xml             | 10 ++++++++
>> >>  .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |  6 ++++-
>> >>  .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |  5 +++-
>> >>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |  8 +++++++
>> >>  drivers/media/platform/coda/coda-bit.c             |  4 ++--
>> >>  drivers/media/platform/coda/coda-common.c          | 27 +++++++++--
>> -----------
>> >>  drivers/media/platform/coda/coda.h                 |  3 +++
>> >>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |  1 +
>> >>  drivers/media/v4l2-core/v4l2-mem2mem.c             | 10 +++++++-
>> >>  drivers/media/v4l2-core/videobuf2-core.c           | 18
>> ++++++++++++++-
>> >>  include/media/videobuf2-core.h                     | 10 ++++++++
>> >>  include/trace/events/v4l2.h                        |  3 ++-
>> >>  include/uapi/linux/videodev2.h                     |  2 ++
>> >>  13 files changed, 84 insertions(+), 23 deletions(-)
>> >
>> > are there any further changes that I should make to this series?
>>
>> I'd like to see some Acks, esp. from Kamil and Pawel.
>>
>> I'll take another look as well, probably on Friday.
>>
>
> The patches look good to me, the 4th version is already queued in my tree.
> However I would like to see your opinion. Especially from you Pawel :)

Sorry for the delay, I've been very busy lately, but I really need to
take a look at them. I'll do my best to review this weekend. Putting
on my calendar.
-- 
Regards,
Pawel
