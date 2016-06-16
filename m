Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:59560 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbcFPLdh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 07:33:37 -0400
Subject: Re: [PATCH 34/38] media: imx: Add support for ADV7180 Video Decoder
To: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1465944574-15745-35-git-send-email-steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <57628E8F.2090205@metafoo.de>
Date: Thu, 16 Jun 2016 13:33:35 +0200
MIME-Version: 1.0
In-Reply-To: <1465944574-15745-35-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2016 12:49 AM, Steve Longerbeam wrote:
> This driver is based on adv7180.c from Freescale imx_3.10.17_1.0.0_beta
> branch, modified heavily for code cleanup and converted from int-device
> to subdev.

We already have a driver for the adv7180 upstream, also using the subdev
API. Is there anything that can be done with this new driver that can't be
done with the other one. And if it is are there any blockers that would
prevent us from adding the missing features to the upstream adv7180?

I know that the driver in the Freescale tree used to have bits that made it
specially tailored to the iMX6. But these bits seem to be mostly gone in
this version of the driver.

I'm slightly concerned about the conflicting nature of these drivers. Both
attach to the same device ID/DT compatible string and register slightly
different userspace ABIs. I'd like to avoid ending up in a situation where
we have dependencies on both ABIs and can no longer converge.

- Lars

