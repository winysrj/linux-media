Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36662 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527Ab0E0JxU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 05:53:20 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=utf-8
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L32005EDOSU9970@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 May 2010 10:53:18 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L3200JD0OSTM4@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 May 2010 10:53:18 +0100 (BST)
Date: Thu, 27 May 2010 11:52:35 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: Tentative agenda for Helsinki mini-summit
In-reply-to: <Pine.LNX.4.64.1005231929091.3571@axis700.grange>
To: 'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	"'Zhong, Jeff'" <hzhong@quicinc.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	"'Zhang, Xiaolin'" <xiaolin.zhang@intel.com>,
	'Sergio Rodriguez' <saaguirre@ti.com>,
	'Vaibhav Hiremath' <hvaibhav@ti.com>,
	'Hans de Goede' <hdegoede@redhat.com>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Kamil Debski' <k.debski@samsung.com>
Message-id: <005201cafd82$557b24f0$00716ed0$%osciak@samsung.com>
Content-language: pl
References: <201005231236.49048.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1005231929091.3571@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>Guennadi Liakhovetski wrote:
>
>No idea whether this is a worthy and suitable topic for this meeting, but:
>
>V4L(2) video output vs. framebuffer.
>
>How about a v4l2-output - fbdev translation layer? You write a v4l2-output
>driver and get a framebuffer device free of charge... TBH, I haven't given
>this too much of a thought, but so far I don't see anything that would
>make this impossible in principle. The video buffer management is quite
>different between the two systems, but maybe we can teach video-output
>drivers to work with just one buffer too? Anyway, feel free to tell me why
>this is an absolutely impossible / impractical idea;)

We also use v4l2-outputs for our display interfaces and for that we have
v4l2-subdevices in a framebuffer driver. Although we have had no need for
such a translation layer per se up to now, the idea seems interesting.

I would definitely be interested in a general discussion about framebuffer
driver - v4l2 output device interoperability though and can share our
experience in this field.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


