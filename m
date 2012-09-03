Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.fr.smartjog.net ([95.81.144.3]:44109 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab2ICONt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 10:13:49 -0400
Message-ID: <5044BB16.3000900@smartjog.com>
Date: Mon, 03 Sep 2012 16:13:42 +0200
From: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] ds3000: Remove useless 'locking'
References: <1346319391-19015-1-git-send-email-remi.cardona@smartjog.com> <1346319391-19015-2-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1346319391-19015-2-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2012 11:36 AM, Rémi Cardona wrote:
> Since b9bf2eafaad9c1ef02fb3db38c74568be601a43a, the function
> ds3000_firmware_ondemand() is called only once during init. This
> locking scheme may have been useful when the firmware was loaded at
> each tune.
> 
> Furthermore, it looks like this 'lock' was put in to prevent concurrent
> access (and not recursion as the comments suggest). However, this open-
> coded mechanism is anything but race-free and should have used a proper
> mutex.
> 
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>
> ---
>  drivers/media/dvb/frontends/ds3000.c |    9 ---------
>  1 file changed, 9 deletions(-)

Ping on that patch. Could anyone take a look at it?

Many thanks,

Rémi
