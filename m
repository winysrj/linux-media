Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52745 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab0IHM70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 08:59:26 -0400
Received: by eyb6 with SMTP id 6so2950761eyb.19
        for <linux-media@vger.kernel.org>; Wed, 08 Sep 2010 05:59:25 -0700 (PDT)
Date: Wed, 8 Sep 2010 16:00:10 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: eduardo.valentin@nokia.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] V4L/DVB: radio-si4713: Add regulator framework
 support
Message-Id: <20100908160010.69548d7b.jhnikula@gmail.com>
In-Reply-To: <20100908121136.GI29776@besouro.research.nokia.com>
References: <1276452568-16366-1-git-send-email-jhnikula@gmail.com>
	<1276452568-16366-2-git-send-email-jhnikula@gmail.com>
	<20100907194949.GA15216@besouro.research.nokia.com>
	<20100908085938.2d2e5992.jhnikula@gmail.com>
	<20100908121136.GI29776@besouro.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, 8 Sep 2010 15:11:36 +0300
Eduardo Valentin <eduardo.valentin@nokia.com> wrote:

> The background here you are probably missing is that the split between
> i2c and platform drivers. That has been done because we were thinking also
> in the situation where the si4713 i2c driver could be used without the
> platform driver. I mean, the i2c code could be re-used for instance by
> other v4l2 driver, if that is driving a device which has also si4713.
> So, in this sense, the current platform is essentially a wrapper.
> And if you split the regulator usage in that way,
> we would probably be loosing that.
> 
This is good to know. In that sense it would be good to have some
common place for managing the VIO here.

> And apart from that, it is also bad from the regfw point of view as well.
> I believe the idea is that the driver itself must take care of all needed
> regulators. The way you have done, looks like the platform driver needs only
> VIO and the i2c needs only VDD. And to my understanding, the i2c needs both
> in order to work. So, my suggestion is to move everything to the i2c driver.
> 
Problem of course is that the chip cannot be probed if the VIO is
missing so it must be on before the chip is probed. Quite many i2c
drivers seems to rely that the VIO is on before probing. Therefore I
did here the VIO enable in platform driver as there were this instance
on top of i2c driver. I think perfect solution would require some sort
of support to i2c core.


-- 
Jarkko
