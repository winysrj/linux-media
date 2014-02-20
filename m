Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27257 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaBTSfJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 13:35:09 -0500
Message-id: <53064AD6.40701@samsung.com>
Date: Thu, 20 Feb 2014 19:35:02 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH] V4L: s5k6a3: Add DT binding documentation
References: <1387747620-24676-1-git-send-email-s.nawrocki@samsung.com>
 <53037F8F.3050302@samsung.com>
 <20140219174726.GE25079@e106331-lin.cambridge.arm.com>
In-reply-to: <20140219174726.GE25079@e106331-lin.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/02/14 18:47, Mark Rutland wrote:
> On Tue, Feb 18, 2014 at 03:43:11PM +0000, Sylwester Nawrocki wrote:
>> > On 22/12/13 22:27, Sylwester Nawrocki wrote:
>>> > > This patch adds DT binding documentation for the Samsung S5K6A3(YX)
>>> > > raw image sensor.
>>> > > 
>>> > > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> > > ---
>>> > > This patch adds missing documentation [1] for the "samsung,s5k6a3"
>>> > > compatible. Rob, can you please merge it through your tree if it 
>>> > > looks OK ?
>> > 
>> > Anyone cares to Ack this patch so it can be merged through the media
>> > tree ?
>
> It looks fine to me:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks for the review. I'm going to post a short series including this
patch, I would appreciate your (or other DT binding maintainer) review
of the DT binding part, so this stuff can finally be pushed upstream.

Cheers,
Sylwester
