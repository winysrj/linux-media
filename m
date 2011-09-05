Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3.bt.bullet.mail.ird.yahoo.com ([212.82.108.234]:22305 "HELO
	nm3.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753570Ab1IEAe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Sep 2011 20:34:59 -0400
Message-ID: <4E64192E.7060505@yahoo.com>
Date: Mon, 05 Sep 2011 01:34:54 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: ERROR: "em28xx_add_into_devlist" [drivers/media/video/em28xx/em28xx.ko]
 undefined!
References: <4E640DBB.8010504@iki.fi> <4E64148A.3010704@yahoo.com> <4E6416D6.2060706@iki.fi>
In-Reply-To: <4E6416D6.2060706@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/09/11 01:24, Antti Palosaari wrote:
> If you select em28xx-cards.c blob link you give you can see it is there still
> for some reason.

It's a merge issue. This lingering reference must have been added after I posted 
my original patch. Fortunately, it's easily fixed: the

     list_add_tail(&dev->devlist, &em28xx_devlist);

operation is now done by ex28xx_init_extension() instead, meaning we only take 
the devlist mutex once. So that last em28xx_add_into_devlist() reference is 
obsolete.

Cheers,
Chris

