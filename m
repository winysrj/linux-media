Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:58184 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbcGMQMf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 12:12:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Baron <jbaron@akamai.com>,
	kernel-build-reports@lists.linaro.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 4/4] dynamic_debug: add jump label support
Date: Wed, 13 Jul 2016 18:03:24 +0200
Message-ID: <4481273.afaatbzpKs@wuerfel>
In-Reply-To: <5786613E.6010509@akamai.com>
References: <cover.1463778029.git.jbaron@akamai.com> <10022037.rzjeY1zYxh@wuerfel> <5786613E.6010509@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, July 13, 2016 11:41:50 AM CEST Jason Baron wrote:
> 
> Hi Arnd,
> 
> Ok, this is back in linux-next now (with hopefully a fix for arm). I
> was never able to quite reproduce the arm failure you saw. So if
> you get the chance to test this it would be great.
> 

I've had a day's worth of randconfig tests without running into the problem
so far.

However, I did get one new compiler warning that I have just bisected
down to 21413cd0e4ed ("dynamic_debug: add jump label support"):

/git/arm-soc/drivers/media/dvb-frontends/cxd2841er.c: In function 'cxd2841er_tune_tc':
/git/arm-soc/drivers/media/dvb-frontends/cxd2841er.c:3253:40: error: 'carrier_offset' may be used uninitialized in this function [-Werror=maybe-uninitialized]
    if (ret)
                                        ^
     return ret;
     ~~~~~~~~~                           
/git/arm-soc/drivers/media/dvb-frontends/cxd2841er.c:3209:11: note: 'carrier_offset' was declared here
  int ret, carrier_offset;
           ^~~~~~~~~~~~~~


It's clearly a false positive warning, the code is correct, but if this is
the only one that the dynamic_debug jump labels introduce, we may as well
just work around it in the driver.

I think this is caused by the "unlikely" annotation in dynamic_dev_dbg(),
which confuses the compiler trying to figure out whether the variable
is initialized or not.

	Arnd
