Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54579 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab2DAVlD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 17:41:03 -0400
Message-ID: <4F78CB6D.1060907@iki.fi>
Date: Mon, 02 Apr 2012 00:41:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] af9035: Add USB read checksumming
References: <20120401223348.5f163b5d@milhouse>
In-Reply-To: <20120401223348.5f163b5d@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.04.2012 23:33, Michael Büsch wrote:
> This adds USB message read checksumming to protect against
> device and bus errors.
> It also adds a read length check to avoid returning garbage from
> the buffer, if the device truncated the message.
>
> Signed-off-by: Michael Buesch<m@bues.ch>

Applied thanks!

http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental

Personally didn't see that very important but I will not see any reason 
not to implement it still :)

regards
Antti
-- 
http://palosaari.fi/
