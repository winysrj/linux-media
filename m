Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46979 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaKXNjN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 08:39:13 -0500
Message-ID: <547334F8.8050403@iki.fi>
Date: Mon, 24 Nov 2014 15:39:04 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org,
	crazyCat <crazycat69@narod.ru>
Subject: Re: [PATCH 4/4] si2157: Add support for Si2148-A20
References: <1416812256-27894-1-git-send-email-olli.salonen@iki.fi> <1416812256-27894-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1416812256-27894-4-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
I decided apply old crazyCat version, even I originally asked that 
firmware change! If I ever will ran problem with Si2148 / Si2158 
firmware difference, I know who to blame ;p

That patch could be dropped.
PULL request already sent.

regards
Antti

On 11/24/2014 08:57 AM, Olli Salonen wrote:
> The Silicon Labs Si2148 tuner works as the Si2158, but does not contain analog tuner. A firmware is required for the tuner. Currently the Si2158-A20 firmware will work for Si2148-A20 as well, but as there are no guarantees that that will be the case in future, a unique file name is used for the firmware.
>
> The datasheet is available on manufacturer's website:
> http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2148-short.pdf
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

-- 
http://palosaari.fi/
