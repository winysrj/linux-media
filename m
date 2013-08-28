Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47278 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3H1JAq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 05:00:46 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MS8007C2H0JWE80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Aug 2013 10:00:44 +0100 (BST)
Message-id: <521DBC3A.7090604@samsung.com>
Date: Wed, 28 Aug 2013 11:00:42 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	=?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
References: <520E76E7.30201@googlemail.com> <6237856.Ni2ROBVUfl@avalon>
 <20130827110858.01d88513@samsung.com> <5182139.9PqyLJNP0L@avalon>
 <20130827130041.15db82d5@samsung.com>
In-reply-to: <20130827130041.15db82d5@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/27/2013 06:00 PM, Mauro Carvalho Chehab wrote:
>>> > > The thing is that you're wanting to use the clock register as a way to
>>> > > detect that the device got initialized.
>> > 
>> > I'm not sure to follow you there, I don't think that's how I want to use the 
>> > clock. Could you please elaborate ?
>
> As Sylwester pointed, the lack of clock register makes ov2640 to defer
> probing, as it assumes that the sensor is not ready.

Hmm, actually there are two drivers here - the sensor driver defers its
probing() when a clock provided by the bridge driver is missing. Thus
let's not misunderstand it that missing clock is used as an indication
of the sensor not being ready. It merely means that the clock provider
(which in this case is the bridge driver) has not initialized yet.
It's pretty standard situation, the sensor doesn't know who provides
the clock but it knows it needs the clock and when that's missing it
defers its probe().

--
Regards,
Sylwester
