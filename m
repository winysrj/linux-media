Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:52190 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbaIZEeW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 00:34:22 -0400
Message-ID: <5424ECC9.4070409@gentoo.org>
Date: Fri, 26 Sep 2014 06:34:17 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH 04/12] cx231xx: give each master i2c bus a seperate name
References: <1411621684-8295-1-git-send-email-zzam@gentoo.org> <1411621684-8295-4-git-send-email-zzam@gentoo.org> <54242F0F.9020702@iki.fi>
In-Reply-To: <54242F0F.9020702@iki.fi>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25.09.2014 17:04, Antti Palosaari wrote:
> So this patch adds bus number to adapter name as postfix?
> 
> "cx231xx" => "cx231xx-1"
> 
Yes, it is attached, and the result looks like
* cx231xx #0-0
* cx231xx #0-1
* cx231xx #0-2

> I have no clear opinion for that. I think name should be given when
> adapter is crated, not afterwards.
> 
It is written to the i2c_adapter before calling i2c_add_adapter. Is this
good enough?

Regards
Matthias

