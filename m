Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45535 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab2DCPYW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 11:24:22 -0400
Message-ID: <4F7B1624.8020401@iki.fi>
Date: Tue, 03 Apr 2012 18:24:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] fc0011: Reduce number of retries
References: <20120403110503.392c8432@milhouse>
In-Reply-To: <20120403110503.392c8432@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.04.2012 12:05, Michael Büsch wrote:
> Now that i2c transfers are fixed, 3 retries are enough.
>
> Signed-off-by: Michael Buesch<m@bues.ch>

Applied, thanks!
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental

I think I will update original af9035 PULL request soon for the same 
level as af9035_experimental is currently.

regards
Antti
-- 
http://palosaari.fi/
