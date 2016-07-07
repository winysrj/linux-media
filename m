Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:44902 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbcGGPhz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 11:37:55 -0400
Subject: Re: [PATCH 01/11] media: adv7180: Fix broken interrupt register
 access
To: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-2-git-send-email-steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <577E7750.8080103@metafoo.de>
Date: Thu, 7 Jul 2016 17:37:52 +0200
MIME-Version: 1.0
In-Reply-To: <1467846004-12731-2-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2016 12:59 AM, Steve Longerbeam wrote:
> Access to the interrupt page registers has been broken since
> at least 3999e5d01da74f1a22afbb0b61b3992fea301478. That commit
> forgot to add the inerrupt page number to the register defines.

typo: interrupt

> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Looks good, thanks.

Acked-by: Lars-Peter Clausen <lars@metafoo.de>
