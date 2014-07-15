Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45506 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850AbaGOT0g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 15:26:36 -0400
Message-ID: <53C58067.8000601@gentoo.org>
Date: Tue, 15 Jul 2014 21:26:31 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] si2157: Add support for spectrum inversion
References: <1405411120-9569-1-git-send-email-zzam@gentoo.org> <1405411120-9569-2-git-send-email-zzam@gentoo.org> <53C50BA0.2000800@iki.fi>
In-Reply-To: <53C50BA0.2000800@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15.07.2014 13:08, Antti Palosaari wrote:
> Moikka Matthias!
> Idea of patch is correct, but I think implementation not. You set FE to
> si2157_config on variable define, but on that point FE is NULL. FE
> pointer is populated by demodulator driver, si2168. Right?

Right, I looked into si2168_probe, it sets this pointer.

> 
> And you could split that to 3 patches too, one for prepare em28xx, one
> for cxusb and last is patch itself.

Yes, I split it accordingly.
Here is the new series based on the silabs branch.

Btw. When will these patches be merged to the master branch?

Regards
Matthias

