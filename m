Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60697 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab2DBQ4w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 12:56:52 -0400
Message-ID: <4F79DA52.2050907@iki.fi>
Date: Mon, 02 Apr 2012 19:56:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add fc0011 tuner driver
References: <20120402181432.74e8bd50@milhouse>
In-Reply-To: <20120402181432.74e8bd50@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02.04.2012 19:14, Michael Büsch wrote:
> This adds support for the Fitipower fc0011 DVB-t tuner.
>
> Signed-off-by: Michael Buesch<m@bues.ch>

Applied, thanks!
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental

I looked it through quickly, no big issues. Anyhow, when I ran 
checkpatch.pl and it complains rather much. All Kernel developers must 
use checkpatch.pl before sent patches and fix findings if possible, 
errors must be fixed and warnings too if there is no good reason to 
leave as it is.

Send new patch that fixes those issues or sent same patches again but fixed.

And one note about tuner driver, my AF9035 + FC0011 device founds only 1 
mux of 4. Looks like some performance issues still to resolve.

regards
Antti
-- 
http://palosaari.fi/
