Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44206 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408AbbGQPSq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 11:18:46 -0400
Message-ID: <1437146322.3254.12.camel@pengutronix.de>
Subject: Re: [PATCH v2] [media] tc358743: allow event subscription
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>, kernel@pengutronix.de,
	linux-media@vger.kernel.org
Date: Fri, 17 Jul 2015 17:18:42 +0200
In-Reply-To: <55A91B47.10308@xs4all.nl>
References: <1437145614-4313-1-git-send-email-p.zabel@pengutronix.de>
	 <55A91B47.10308@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 17.07.2015, 17:12 +0200 schrieb Hans Verkuil:
> On 07/17/2015 05:06 PM, Philipp Zabel wrote:
> > This is useful to subscribe to HDMI hotplug events via the
> > V4L2_CID_DV_RX_POWER_PRESENT control.
> 
> Very quick, but it doesn't apply. You need to combine the original
> "[PATCH 5/5] [media] tc358743: allow event subscription" together with
> this patch.

I clearly shouldn't be allowed to send patches today. I'll merge these
and then I'll take my hands off the keyboard.

regards
Philipp

