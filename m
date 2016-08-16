Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:59311 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbcHPPN7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 11:13:59 -0400
Subject: Re: Submit media entity without media device
References: <0b6c1a36-8770-b9f0-4d31-6b2aa31bed5c@synopsys.com>
To: <linux-media@vger.kernel.org>
CC: <hverkuil@xs4all.nl>, <mchehab@s-opensource.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <3968b7c6-ee8b-b290-22e4-edb46ae1b6cc@synopsys.com>
Date: Tue, 16 Aug 2016 16:13:46 +0100
MIME-Version: 1.0
In-Reply-To: <0b6c1a36-8770-b9f0-4d31-6b2aa31bed5c@synopsys.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just adding some people to the CC list.


On 28-06-2016 13:00, Ramiro Oliveira wrote:
> Hi all,
>
> We at Synopsys have a media device driver and in that media device we have a
> media entity for our CSI-2 Host.
>
> At the moment we aren't ready to submit the entire media device, so I was
> wondering if it was possible to submit a media entity driver separately, without
> the rest of the architecture, and if so where should we place it.
>
> Best Regards,
>
> Ramiro Oliveira
>
>

