Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58064 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaK0WMk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 17:12:40 -0500
Message-ID: <5477A1D5.70505@iki.fi>
Date: Fri, 28 Nov 2014 00:12:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] si2168: add support for firmware files in new format
References: <1417117343-1793-1-git-send-email-olli.salonen@iki.fi> <1417117343-1793-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1417117343-1793-2-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/27/2014 09:42 PM, Olli Salonen wrote:
> This patch adds support for new type of firmware versions of Si2168 chip.
>
> Old type: n x 8 bytes (all data, first byte seems to be 04 or 05)
> New type: n x 17 bytes (1 byte indicates len and max 16 bytes data)
>
> New version of TechnoTrend CT2-4400 drivers
> (http://www.tt-downloads.de/bda-treiber_4.3.0.0.zip) contains newer
> firmware for Si2168-B40 that is in the new format. It can be extracted
> with the following command:
>
> dd if=ttTVStick4400_64.sys ibs=1 skip=323872 count=6919 of=dvb-demod-si2168-b40-01.fw
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

Reviewed-by: Antti Palosaari <crope@iki.fi>

That change makes anyhow some headache on case driver is old and does 
not support that newer firmware format... On that case it fails and 
error is printed, though. But we can live with it as there is no 
regression - kernel update is still possible. Only kernel downgrade 
could cause problem if new format firmware is installed.

regards
Antti

-- 
http://palosaari.fi/
