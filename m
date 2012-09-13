Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:52342 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab2IMLci (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 07:32:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Improving ov7670 sensor driver.
Date: Thu, 13 Sep 2012 13:32:32 +0200
Cc: linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	brijohn@gmail.com
References: <CACKLOr22AvmWhXmj2SrMGO4y39ESHfyh_HPnLr6nmQGkUv2+zg@mail.gmail.com> <201209131300.12630.hverkuil@xs4all.nl> <CACKLOr1xpTv7775Uj6xmfbecDaQBaWMqB7htNjOLfwubQD8AbQ@mail.gmail.com>
In-Reply-To: <CACKLOr1xpTv7775Uj6xmfbecDaQBaWMqB7htNjOLfwubQD8AbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209131332.32924.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 13 September 2012 13:19:14 javier Martin wrote:
> On 13 September 2012 13:00, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Thu 13 September 2012 12:47:53 javier Martin wrote:
> >> >> 3.- Adjust vstart/vstop in order to remove an horizontal green line.
> >> >>
> >> >> Why? Currently, in the driver, for VGA, vstart =  10 and vstop = 490.
> >> >> From our tests we found out that vstart = 14, vstop = 494 in order to
> >> >> remove a disgusting horizontal green line in ov7675.
> >> >> How? It seems these sensor aren't provided with a version register or
> >> >> anything similar so I can't think of a clean solution for this yet.
> >> >> Suggestions will be much appreciated.
> >> >
> >> > Using platform_data for this is what springs to mind.
> >>
> >> I had thought about it too but, there
> >
> > Unfinished sentence?
> >
> 
> Yes. Sorry :)
> 
> I meant that I had thought about it too but there are one pair of
> vstart,vstop values for each supported resolution: VGA, QVGA, CIF,
> QCIF.
> I could add 'vstart_vga', 'vstop_vga' as platform_data but in the
> future someone could want to add the same values for the other ones
> and I don't know if that would be acceptable.
> 
> Another solution I just came up with would be adding a flag 'version'
> where we could indicate if we are dealing with an ov7670 or an ov7675
> and change those 'vstart', 'vstop' values internally based on this.
> This could be useful for some other issues in the future.

You can actually add support for a ov7675 to the ov7670 driver itself
by adding a ov7675 entry to the ov7670_id table. See for example the
i2c/saa7127.c driver on how to do that.

Regards,

	Hans
