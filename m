Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:41733 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754350AbcCULot (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 07:44:49 -0400
Subject: Re: [PATCH v3] media: Support Intersil/Techwell TW686x-based video
 capture cards
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	linux-media@vger.kernel.org
References: <1453699436-4309-1-git-send-email-ezequiel@vanguardiasur.com.ar>
 <1456929016-4160-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Cc: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56EFDEAC.2040904@xs4all.nl>
Date: Mon, 21 Mar 2016 12:44:44 +0100
MIME-Version: 1.0
In-Reply-To: <1456929016-4160-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On 03/02/2016 03:30 PM, Ezequiel Garcia wrote:
> This commit introduces the support for the Techwell TW686x video
> capture IC. This hardware supports a few DMA modes, including
> scatter-gather and frame (contiguous).
> 
> This commit makes little use of the DMA engine and instead has
> a memcpy based implementation. DMA frame and scatter-gather modes
> support may be added in the future.
> 
> Currently supported chips:
> - TW6864 (4 video channels),
> - TW6865 (4 video channels, not tested, second generation chip),
> - TW6868 (8 video channels but only 4 first channels using
>            built-in video decoder are supported, not tested),
> - TW6869 (8 video channels, second generation chip).
> 
> Cc: Krzysztof Hałasa <khalasa@piap.pl>
> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

I've tested this with my PCIe tw6869 card (arrived this week).

Video is fine, but only the first audio input is available. I suspect you
have only one audio input?

Regarding the memcpy: if you have a patch for me that reverts back to a non-memcpy
situation, then I can do duration tests for you.

Unless you've ordered one of these PCIe cards yourself?

Regards,

	Hans
