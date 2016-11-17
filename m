Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52530
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751091AbcKQWHH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 17:07:07 -0500
Date: Thu, 17 Nov 2016 20:07:00 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <uwe@kleine-koenig.org>
Cc: Derek <user.vdr@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb: gp8psk: specify license using MODULE_LICENSE
Message-ID: <20161117200700.3e3f5cb2@vento.lan>
In-Reply-To: <20161117195736.11990-1-uwe@kleine-koenig.org>
References: <20161117195736.11990-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Nov 2016 20:57:36 +0100
Uwe Kleine-König <uwe@kleine-koenig.org> escreveu:

> This fixes
> 	WARNING: modpost: missing MODULE_LICENSE() in drivers/media/dvb-frontends/gp8psk-fe.o
> 	see include/linux/module.h for more information
> 
> Fixes: 7a0786c19d65 ("gp8psk: Fix DVB frontend attach")
> Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>

Thanks, but a similar patch were already added upstream for -rc6. I'll
pull it back to the media tree probably next week (after the release
of 4.9-rc6).

Thanks,
Mauro
