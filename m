Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36303 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2IPB2o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 21:28:44 -0400
Message-ID: <50552B39.3050302@iki.fi>
Date: Sun, 16 Sep 2012 04:28:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 2/6] [media] ds3000: remove useless 'locking'
References: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com> <1347614846-19046-3-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1347614846-19046-3-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2012 12:27 PM, Rémi Cardona wrote:
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

Reviewed-by: Antti Palosaari <crope@iki.fi>

-- 
http://palosaari.fi/
