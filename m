Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42207 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2IPBad (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 21:30:33 -0400
Message-ID: <50552BA5.1000000@iki.fi>
Date: Sun, 16 Sep 2012 04:30:13 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 3/6] [media] ds3000: properly report register read errors
References: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com> <1347614846-19046-4-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1347614846-19046-4-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2012 12:27 PM, Rémi Cardona wrote:
> This brings both ds3000_readreg() and ds3000_tuner_readreg() in line
> with ds3000_writereg() and ds3000_tuner_writereg() respectively.
>
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>


Not related, but just guess, register 03 value 12 opens demod I2C gate.

regards
Antti

-- 
http://palosaari.fi/
