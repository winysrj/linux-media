Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53030 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382Ab2EGSqJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 14:46:09 -0400
Message-ID: <4FA8186D.4000007@iki.fi>
Date: Mon, 07 May 2012 21:46:05 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	Gianluca Gennari <gennarone@gmail.com>
Subject: Re: [PATCH v2] af9035: add remote control support
References: <201204220023.16452.hfvogt@gmx.net>
In-Reply-To: <201204220023.16452.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.04.2012 01:23, Hans-Frieder Vogt wrote:
> af9035: support remote controls, version 2 of patch (Currently, no key maps are loaded).
>
> This version of the patch addresses comments from Antti and Mauro. Thank very much for your comments!
> Compared to the first version of the patch, the remote control is only activated after the EEPROM has been read
> and confirmed that the remote is not working in the HID mode.
> In addition, config variables are no longer needed and unnecessary checks have been removed.
>
> Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>

I applied that and already PULL requested via my tree. Thanks!


regards
Antti

-- 
http://palosaari.fi/
