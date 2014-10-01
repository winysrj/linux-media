Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41563 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaJAPkZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Oct 2014 11:40:25 -0400
Message-ID: <1412178011.3077.10.camel@pengutronix.de>
Subject: Re: [PATCH 00/10] CODA7 JPEG support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Kamil Debski <k.debski@samsung.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Wed, 01 Oct 2014 17:40:11 +0200
In-Reply-To: <542C02C5.8090806@collabora.com>
References: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
	 <542AB39B.9010006@xs4all.nl> <1412086849.3692.3.camel@pengutronix.de>
	 <542ABD1F.9000701@xs4all.nl>
	 <0d2c01cfdcbb$98df2670$ca9d7350$%debski@samsung.com>
	 <542C02C5.8090806@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 01.10.2014, 09:33 -0400 schrieb Nicolas Dufresne:
> Le 2014-09-30 10:34, Kamil Debski a écrit :
> > I agree with you Hans. MFC has a single encoder node that supports multiple
> > codecs and I think this design works well.
> >
> > JPEG should be separated into separate device.
> Having combined encoders and combines decoders works well from 
> application / gstreamer point of view too. It's only combine encoder and 
> decoder that causes issues with our ability to probe what the HW is 
> capable (without a need to know about the platform). Exynos has split 
> JPEG decoder because it's not the same HW backing it.

Alright, I'll merge the H.264 and MPEG4 encoder devices again and resend
the series tomorrow.

thanks
Philipp

