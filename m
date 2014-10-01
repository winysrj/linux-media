Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:48972 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaJANeH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Oct 2014 09:34:07 -0400
Message-ID: <542C02C5.8090806@collabora.com>
Date: Wed, 01 Oct 2014 09:33:57 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Philipp Zabel' <p.zabel@pengutronix.de>
CC: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 00/10] CODA7 JPEG support
References: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de> <542AB39B.9010006@xs4all.nl> <1412086849.3692.3.camel@pengutronix.de> <542ABD1F.9000701@xs4all.nl> <0d2c01cfdcbb$98df2670$ca9d7350$%debski@samsung.com>
In-Reply-To: <0d2c01cfdcbb$98df2670$ca9d7350$%debski@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-09-30 10:34, Kamil Debski a écrit :
> I agree with you Hans. MFC has a single encoder node that supports multiple
> codecs and I think this design works well.
>
> JPEG should be separated into separate device.
Having combined encoders and combines decoders works well from 
application / gstreamer point of view too. It's only combine encoder and 
decoder that causes issues with our ability to probe what the HW is 
capable (without a need to know about the platform). Exynos has split 
JPEG decoder because it's not the same HW backing it.

cheers,
Nicolas
