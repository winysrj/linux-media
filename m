Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42338 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757964AbbGQPhX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 11:37:23 -0400
Message-ID: <55A920F5.2030407@xs4all.nl>
Date: Fri, 17 Jul 2015 17:36:21 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>, kernel@pengutronix.de,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] tc358743: allow event subscription
References: <1437145614-4313-1-git-send-email-p.zabel@pengutronix.de>	 <55A91B47.10308@xs4all.nl> <1437146322.3254.12.camel@pengutronix.de>
In-Reply-To: <1437146322.3254.12.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2015 05:18 PM, Philipp Zabel wrote:
> Am Freitag, den 17.07.2015, 17:12 +0200 schrieb Hans Verkuil:
>> On 07/17/2015 05:06 PM, Philipp Zabel wrote:
>>> This is useful to subscribe to HDMI hotplug events via the
>>> V4L2_CID_DV_RX_POWER_PRESENT control.
>>
>> Very quick, but it doesn't apply. You need to combine the original
>> "[PATCH 5/5] [media] tc358743: allow event subscription" together with
>> this patch.
> 
> I clearly shouldn't be allowed to send patches today. I'll merge these
> and then I'll take my hands off the keyboard.

Thanks for the v3, I've reposted my pull request to include this patch as
well.

The weekend starts, so this is a pretty good time to take your hands off the
keyboard. In fact, I think I'll join you :-)

Regards,

	Hans
