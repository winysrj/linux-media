Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:40263 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbcGTIxg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 04:53:36 -0400
Subject: Re: [PATCH v2 05/10] media: adv7180: add power pin control
To: Steve Longerbeam <slongerbeam@gmail.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
 <1468973017-17647-6-git-send-email-steve_longerbeam@mentor.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <c7322f4e-c3d8-fc4b-dac3-6cb4a9790bbe@metafoo.de>
Date: Wed, 20 Jul 2016 10:53:31 +0200
MIME-Version: 1.0
In-Reply-To: <1468973017-17647-6-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2016 02:03 AM, Steve Longerbeam wrote:
> Some targets control the ADV7180 power pin via a gpio, so add
> optional support for "powerdown" pin control.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Tested-by: Tim Harvey <tharvey@gateworks.com>
> Acked-by: Tim Harvey <tharvey@gateworks.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>

Looks good, thanks.

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

