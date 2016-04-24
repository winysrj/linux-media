Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:37539 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbcDXPNo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 11:13:44 -0400
Subject: Re: [PATCH 1/6] adv7180: fix broken standards handling
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
 <1461330222-34096-2-git-send-email-hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Federico Vaga <federico.vaga@gmail.com>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <571CDEED.9010700@metafoo.de>
Date: Sun, 24 Apr 2016 16:57:49 +0200
MIME-Version: 1.0
In-Reply-To: <1461330222-34096-2-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/22/2016 03:03 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The adv7180 attempts to autodetect the standard. Unfortunately this
> is seriously broken.
> 
> This patch removes the autodetect completely. Only the querystd op
> will detect the standard. Since the design of the adv7180 requires
> that you switch to a special autodetect mode you cannot call querystd
> when you are streaming.
> 
> So the s_stream op has been added so we know whether we are streaming
> or not, and if we are, then querystd returns EBUSY.
> 
> After testing this with a signal generator is became obvious that
> a sleep is needed between changing the standard to autodetect and
> reading the status. So the autodetect can never have worked well.
> 
> The s_std call now just sets the new standard without any querying.
> 
> If the driver supports the interrupt, then when it detects a standard
> change it will signal that by sending the V4L2_EVENT_SOURCE_CHANGE
> event.
> 
> With these changes this driver now behaves like all other video
> receivers.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Federico Vaga <federico.vaga@gmail.com>

Thanks for cleaning this up.

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

