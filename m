Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:44803 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3H1J17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 05:27:59 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MS800J3KIAL2720@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Aug 2013 05:27:57 -0400 (EDT)
Date: Wed, 28 Aug 2013 06:27:52 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
Message-id: <20130828062752.18604873@samsung.com>
In-reply-to: <521DBC3A.7090604@samsung.com>
References: <520E76E7.30201@googlemail.com> <6237856.Ni2ROBVUfl@avalon>
 <20130827110858.01d88513@samsung.com> <5182139.9PqyLJNP0L@avalon>
 <20130827130041.15db82d5@samsung.com> <521DBC3A.7090604@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 28 Aug 2013 11:00:42 +0200
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> On 08/27/2013 06:00 PM, Mauro Carvalho Chehab wrote:
> >>> > > The thing is that you're wanting to use the clock register as a way to
> >>> > > detect that the device got initialized.
> >> > 
> >> > I'm not sure to follow you there, I don't think that's how I want to use the 
> >> > clock. Could you please elaborate ?
> >
> > As Sylwester pointed, the lack of clock register makes ov2640 to defer
> > probing, as it assumes that the sensor is not ready.
> 
> Hmm, actually there are two drivers here - the sensor driver defers its
> probing() when a clock provided by the bridge driver is missing. Thus
> let's not misunderstand it that missing clock is used as an indication
> of the sensor not being ready. It merely means that the clock provider
> (which in this case is the bridge driver) has not initialized yet.
> It's pretty standard situation, the sensor doesn't know who provides
> the clock but it knows it needs the clock and when that's missing it
> defers its probe().

On an always on clock, there's no sense on defer probe.
> 
> --
> Regards,
> Sylwester


-- 

Cheers,
Mauro
