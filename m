Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout06.plus.net ([212.159.14.18]:47104 "EHLO
	avasout06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574AbbEaWax (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 18:30:53 -0400
Message-ID: <556B8B98.5050602@baker-net.org.uk>
Date: Sun, 31 May 2015 23:30:48 +0100
From: Adam Baker <linux@baker-net.org.uk>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] si2157: implement signal strength stats
References: <1432933510-19028-1-git-send-email-crope@iki.fi> <1432933510-19028-2-git-send-email-crope@iki.fi>
In-Reply-To: <1432933510-19028-2-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/05/15 22:05, Antti Palosaari wrote:
> Implement DVBv5 signal strength stats. Returns dBm.
>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---

Tested-by: Adam Baker <linux@baker-net.org.uk>

I don't have the test gear to verify the absolute levels but the signal 
level readings were close to those obtained feeding the same signal into 
a Hauppauge Nova TD and varied as additional cables and splitters were 
added in a consistent fashion. I didn't see much variation in C/N but I 
wouldn't expect to in a setup with a masthead amp.

Turning the LNA on and off in a PCTV 292e showed that the LNA gives 
approx 20dB gain.

Test environment was this patch, the si2168: Implement own I2C adapter 
locking patch and Olli Salonen's si2168: add I2C error handling patch as 
that is needed to make Antti's patch apply cleanly.

Adam
