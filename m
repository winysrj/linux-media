Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:43930 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbcGGP37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 11:29:59 -0400
Subject: Re: [PATCH 05/11] media: adv7180: init chip with AD recommended
 register settings
To: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-6-git-send-email-steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <577E7575.6030501@metafoo.de>
Date: Thu, 7 Jul 2016 17:29:57 +0200
MIME-Version: 1.0
In-Reply-To: <1467846004-12731-6-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2016 12:59 AM, Steve Longerbeam wrote:
> Define and load register tables that conform to Analog Device's
> recommended register settings. It loads the default single-ended
> CVBS on Ain1 configuration for both ADV7180 and ADV7182 chips.

The driver should already setup the recommended configuration based on the
current mode. This patch seems to add a set of register writes that only
apply for a specific mode.

[...]
> Note this patch also enables NEWAVMODE, which is also recommended by
> Analog Devices. This will likely break any current backends using this
> subdev that are expecting different or manually configured AV codes.
> 
> Note also that bt.656-4 support has been removed in this patch, but it
> will be brought back in a subsequent patch.


I'm not sure if we can or should break backwards compatibility in this way.

