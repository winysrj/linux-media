Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35993 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbbJMHn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2015 03:43:57 -0400
Received: by oihr205 with SMTP id r205so5020205oih.3
        for <linux-media@vger.kernel.org>; Tue, 13 Oct 2015 00:43:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1421938721.3084.35.camel@pengutronix.de>
References: <CAOMZO5BgYVQQY4_jJK0h1jMW-Tpb8DHqAkfi2MerhmndMSZr3w@mail.gmail.com>
 <1418308963.2320.14.camel@collabora.com> <5489AE9A.8030204@xs4all.nl> <1421938721.3084.35.camel@pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Tue, 13 Oct 2015 09:43:37 +0200
Message-ID: <CAH-u=80tqSeR36tbVrbPDbQd0H0TBZm7Z_ZD5RACKjDmdHfTCA@mail.gmail.com>
Subject: Re: coda: not generating EOS event
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	=?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

2015-01-22 15:58 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Hi,
>
> Am Donnerstag, den 11.12.2014, 15:47 +0100 schrieb Hans Verkuil:
>> Hi Pawel,
>>
>> On 12/11/14 15:42, Nicolas Dufresne wrote:
>> > Le jeudi 11 décembre 2014 à 11:00 -0200, Fabio Estevam a écrit :
>> >> Hi,
>> >>
>> >> I am running Gstreamer 1.4.4 with on a imx6q-sabresd board and I am
>> >> able to decode a video through the coda driver.
>> >>
>> >> The pipeline I use is:
>> >> gst-launch-1.0 filesrc
>> >> location=/home/H264_test1_Talkinghead_mp4_480x360.mp4 ! qtdemux !
>> >> h264parse ! v4l2video1dec ! videoconvert ! fbdevsink
>> >
>> > This is a known issue. The handling of EOS and draining is ill defined
>> > in V4L2 specification. We should be clarifying this soon. Currently
>> > GStreamer implements what was originally done in Exynos MFC driver. This
>> > consist of sending empty buffer to the V4L2 Output (the input), until we
>> > get an empty buffer (bytesused = 0) on the V4L2 Capture (output).
>> >
>> > The CODA driver uses the new method to initiate the drain, which is to
>> > send V4L2_DEC_CMD_STOP, this was not implemented by any driver when GST
>> > v4l2 support was added. This is the right thing to do. This is tracked
>> > at (contribution welcome of course):
>> >
>> > https://bugzilla.gnome.org/show_bug.cgi?id=733864
>> >
>> > Finally, CODA indicate that all buffer has been sent through an event,
>> > V4L2_EVENT_EOS. This event was designed for another use case, it should
>> > in fact be sent when the decoder is done with the encoded buffers,
>> > rather then when the last decoded buffer has been queued. When correctly
>> > implemented, this event cannot be used to figure-out when the last
>> > decoded buffer has been dequeued.
>> >
>> > During last workshop, it has been proposed to introduce a flag on the
>> > last decoded buffer, _LAST. This flag could also be put on an empty
>>
>> Are you planning to work on this? That was my assumption, but it's probably
>> a good idea to check in case we are waiting for one another :-)
>
> I had another look at the ELC-E 2014 V4L2 codec API document and have
> tried to implement the proposed decoder draining flow in an RFC:
> "Signalling last decoded frame by V4L2_BUF_FLAG_LAST and -EPIPE":
>
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/87152
>
> Are you planning to pour the workshop's codec API document into a V4L2
> documentation patch?

I am now working on the encoder part (for coda) which should do the same.
But everything is documented from a decoder POV, not the encoder's...
Is the mecanism already there, and the only thing which should be
added is the ENC_CMD_STOP command ?

Thanks,
JM
