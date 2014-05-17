Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59738 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030196AbaEQRVL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 May 2014 13:21:11 -0400
Message-ID: <53779A7F.8020007@iki.fi>
Date: Sat, 17 May 2014 20:21:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Martin Kepplinger <martink@posteo.de>, gregkh@linuxfoundation.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] staging: media: as102: replace custom dprintk() with
 dev_dbg()
References: <53776B57.5050504@iki.fi> <1400342738-32652-1-git-send-email-martink@posteo.de>
In-Reply-To: <1400342738-32652-1-git-send-email-martink@posteo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/17/2014 07:05 PM, Martin Kepplinger wrote:
> don't reinvent dev_dbg(). remove dprintk() in as102_drv.c.
> use the common kernel coding style.
>
> Signed-off-by: Martin Kepplinger <martink@posteo.de>

Reviewed-by: Antti Palosaari <crope@iki.fi>

> ---
> this applies to next-20140516. any more suggestions?
> more cleanup can be done when dprintk() is completely gone.

Do you have the device? I am a bit reluctant patching that driver 
without any testing as it has happened too many times something has gone 
totally broken.

IIRC Devin said it is in staging because of style issues and nothing 
more. Is that correct?

regards
Antti

-- 
http://palosaari.fi/
