Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56620 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab0E0Lny (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 07:43:54 -0400
Date: Thu, 27 May 2010 13:43:06 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: Tentative agenda for Helsinki mini-summit
In-reply-to: <Pine.LNX.4.64.1005271158550.2293@axis700.grange>
To: 'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>
Cc: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	"'Zhong, Jeff'" <hzhong@quicinc.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	"'Zhang, Xiaolin'" <xiaolin.zhang@intel.com>,
	'Sergio Rodriguez' <saaguirre@ti.com>,
	'Vaibhav Hiremath' <hvaibhav@ti.com>,
	'Hans de Goede' <hdegoede@redhat.com>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Kamil Debski' <k.debski@samsung.com>,
	linux-fbdev@vger.kernel.org
Message-id: <005f01cafd91$c5f25a00$51d70e00$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <201005231236.49048.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1005231929091.3571@axis700.grange>
 <005201cafd82$557b24f0$00716ed0$%osciak@samsung.com>
 <Pine.LNX.4.64.1005271158550.2293@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>On Thu, 27 May 2010, Pawel Osciak wrote:
>
>> Hi,
>>
>> >Guennadi Liakhovetski wrote:
>> >
>> >No idea whether this is a worthy and suitable topic for this meeting, but:
>> >
>> >V4L(2) video output vs. framebuffer.
>> >
>> >How about a v4l2-output - fbdev translation layer? You write a v4l2-output
>> >driver and get a framebuffer device free of charge... TBH, I haven't given
>> >this too much of a thought, but so far I don't see anything that would
>> >make this impossible in principle. The video buffer management is quite
>> >different between the two systems, but maybe we can teach video-output
>> >drivers to work with just one buffer too? Anyway, feel free to tell me why
>> >this is an absolutely impossible / impractical idea;)
>>
>> We also use v4l2-outputs for our display interfaces and for that we have
>> v4l2-subdevices in a framebuffer driver. Although we have had no need for
>> such a translation layer per se up to now, the idea seems interesting.
>
>Interesting, but sorry, don't quite understand "we use v4l2-outputs" and
>"in a framebuffer driver" - so, is it a framebuffer (/dev/fbX) or a v4l2
>output device driver or both? Which driver is this? Is it already in the
>mainline?
>

It's the (mostly) standard s3c-fb driver with a v4l2-subdev video interface
added. A separate v4l2 output device driver uses that interface to communicate
with the framebuffer driver, as some setup is required on both parts.

Those operations cannot be performed from userspace as they have to be
synchronized in interrupts.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


