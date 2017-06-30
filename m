Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751742AbdF3H1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 03:27:32 -0400
Date: Fri, 30 Jun 2017 09:27:29 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 0/7] Introduce MEDIA_VERSION to end KENREL_VERSION
 abuse in media
Message-ID: <20170630072729.GC5236@linux-x5ow.site>
References: <20170621080812.6817-1-jthumshirn@suse.de>
 <20170624171507.38353b10@vento.lan>
 <20170629094259.GG3808@linux-x5ow.site>
 <20170629100105.6af3b77a@xeon-e3>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170629100105.6af3b77a@xeon-e3>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 29, 2017 at 10:01:05AM -0700, Stephen Hemminger wrote:
> If you read Linus's comments on version.
> Driver version is meaningless and there is a desire to rip it out of all
> drivers. The reason is that drivers must always behave the same, i.e you
> can't use version to change API/ABI behavior. 

Indeed this causes more harm than good. We had support calls regarding the
mlx4 driver because of not incremented MODLE_VERSION()s. If we follow your
and Linus' path we shouldn't just get rid of the KERNEL_VERSION() usage
in media and replace it with a new version, but kill all the versioning
stuff out of media (and others) except for maybe the HW version.

> Any upstream driver should never use KERNEL_VERSION().

Exactly my reasoning.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
