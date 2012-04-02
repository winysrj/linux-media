Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46991 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab2DBRDK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 13:03:10 -0400
Message-ID: <4F79DBCC.6070803@iki.fi>
Date: Mon, 02 Apr 2012 20:03:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] af9035: Add fc0011 tuner support
References: <20120402181836.0018c6ad@milhouse>
In-Reply-To: <20120402181836.0018c6ad@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02.04.2012 19:18, Michael Büsch wrote:
> This adds Fitipower fc0011 tuner support to the af9035 driver.
>
> Signed-off-by: Michael Buesch<m@bues.ch>

Applied, thanks!
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental

And same checkpatch.pl issue here.
You can ran checkpatch like that:
git diff | ./scripts/checkpatch.pl -
git diff --cached | ./scripts/checkpatch.pl -
./scripts/checkpatch.pl --file drivers/media/dvb/dvb-usb/af9035.c

For that driver it complains you are using wrong sleep (msleep(10)). 
Correct sleep for that case is something like usleep_range(10000, 
100000); which means as sleep at least 10ms but it does not matter if 
you sleep even 100ms. The wider range the better chance for Kernel to 
optimize power saving. There was usleep_range() already used inside that 
module.

regards
Antti
-- 
http://palosaari.fi/
