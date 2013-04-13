Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40025 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab3DMQdI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 12:33:08 -0400
Message-ID: <5169889C.2000800@iki.fi>
Date: Sat, 13 Apr 2013 19:32:28 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jakob Haufe <sur5r@sur5r.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for Delock 61959 and its remote control
References: <1365865417-22853-1-git-send-email-sur5r@sur5r.net>
In-Reply-To: <1365865417-22853-1-git-send-email-sur5r@sur5r.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/13/2013 06:03 PM, Jakob Haufe wrote:
> This time for real with all bells and whistles:
>
> Delock 61959 is a relabeled MexMedia UB-425TC with a different USB ID and a
> different remote.
>
> Patch 1 adds the keytable for the remote control and patch 2 adds support for
> the device itself. I'm reusing maxmedia_ub425_tc as I didn't want to duplicate
> it without need.
>
> DVB-T is not working (yet) because of the DRX-K firmware issue.

Patches seems to be correct. Thank you!

regards
Antti

-- 
http://palosaari.fi/
