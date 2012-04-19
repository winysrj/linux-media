Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab2DSN7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 09:59:05 -0400
Message-ID: <4F901A1A.9020908@redhat.com>
Date: Thu, 19 Apr 2012 10:58:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Sakari Ailus'" <sakari.ailus@iki.fi>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH] v4l: added V4L2_BUF_FLAG_EOS flag indicating the
 last frame in the stream
References: <1334051442-28359-1-git-send-email-a.hajda@samsung.com> <003801cd1992$ddcece50$996c6af0$%debski@samsung.com>
In-Reply-To: <003801cd1992$ddcece50$996c6af0$%debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-04-2012 13:31, Kamil Debski escreveu:
> Hi,
> 
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> Sent: 10 April 2012 11:51
>>
>> v4l: added V4L2_BUF_FLAG_EOS flag indicating the last frame in the stream
>>
>> Some devices requires indicator if the buffer is the last one in the
>> stream.
>> Applications and drivers can use this flag in such case.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>
>> Hello,
>>
>> This patch adds new v4l2_buffer flag V4L2_BUF_FLAG_EOS. This flag is set
>> by applications on the output buffer to indicate the last buffer of the
>> stream.
>>
>> Some devices (eg. s5p_mfc) requires presence of the end-of-stream
>> indicator
>> together with the last buffer.
>> Common practice of sending empty buffer to indicate end-of-strem do not
>> work in
>> such case.
>>
>> I would like to ask for review and comments.
>>
>> Apologies for duplicated e-mails - sendmail problems.
>>
>> Regards
>> Andrzej Hajda
>>
> 
> [snip]
> 
> Maybe I could throw some more light at the problem.
> 
> The problem is that when the encoding is done it is necessary to mark the
> last frame of the video that is encoded. It is needed because the hardware
> may need to return some encoded buffers that are kept in the hardware.

Are you talking only about V4L2_BUF_TYPE_VIDEO_OUTPUT? 

> Why the buffers are kept in hardware one might ask? The answer to this
> question is following. The video frames are enqueued in MFC in presentation
> order and the encoded frames are dequeued in decoding order.
> 
> Let's see an example:
> 			           1234567
> The presentation order is:   IBBPBBP--
> The decoding order here is:  --IPBBPBB
> (the P frames have to be decoded before B frames as B frames reference
> both preceding and following frame; when no B frames are used then
> there is no delay)
> 
> So there is a delay of two buffers returned on the CAPTURE side to the
> OUTPUT queue. After the last frame is encoded these buffers have to be
> returned to the user. Our hardware needs to know that it is the last frame
> before it is encoded, so the idea is to add a flag that would mark the
> buffer as the last one.
> 
> The flag could also be used to mark the last frame during decoding - now
> it is done by setting bytesused to 0. The EOS flag could be used in addition
> to that.
> 
> Comments are welcome.

For V4L2_BUF_TYPE_VIDEO_CAPTURE, a change like the one proposed has issues
to be considered: this kind of issue may happen on any driver delivering MPEG
format. 

So, if we're willing to introduce flags for MPEG-specific handling like that, 
then all drivers delivering mpeg outputs should be patched, and not only the
drivers you're maintaining, otherwise userspace applications can't trust that 
this feature is there.

Btw, the encoder API, designed to mpeg encoders addresses it on a different way:
V4L2_ENC_CMD_STOP stops an mpeg stream, but it waits until the end of a group
of pictures:
    http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-encoder-cmd.html

At least for video capture, this seems to work fine.

For video output, it could make sense to have a flag mark the end of a GoP,
but, again, if we're thinking that the source could be a V4L2 capture, the
GoP end should be marked there, and the patches adding support for it will
need to touch the existing drivers that have mpeg encoders/decoders, in order
to be sure that, after a certain V4L2 API, all of them will support such
feature.

Regards,
Mauro
