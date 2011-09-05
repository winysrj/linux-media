Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab1IEN6I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Sep 2011 09:58:08 -0400
Message-ID: <4E64D566.4070105@redhat.com>
Date: Mon, 05 Sep 2011 10:57:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: ERROR: "em28xx_add_into_devlist" [drivers/media/video/em28xx/em28xx.ko]
 undefined!
References: <4E640DBB.8010504@iki.fi> <4E64148A.3010704@yahoo.com> <4E6416D6.2060706@iki.fi> <4E64192E.7060505@yahoo.com>
In-Reply-To: <4E64192E.7060505@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-09-2011 21:34, Chris Rankin escreveu:
> On 05/09/11 01:24, Antti Palosaari wrote:
>> If you select em28xx-cards.c blob link you give you can see it is there still
>> for some reason.
> 
> It's a merge issue. This lingering reference must have been added after I posted my original patch. Fortunately, it's easily fixed: the
> 
> list_add_tail(&dev->devlist, &em28xx_devlist);
> 
> operation is now done by ex28xx_init_extension() instead, meaning we only take the devlist mutex once. So that last em28xx_add_into_devlist() reference is obsolete.

Could you please provide me a patch for it? I'll merge with your original one
when submitting it upstream.

> 
> Cheers,
> Chris
> 

