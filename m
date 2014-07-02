Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:50235 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaGBF1i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Jul 2014 01:27:38 -0400
Message-ID: <53B39846.5010305@gentoo.org>
Date: Wed, 02 Jul 2014 07:27:34 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, crope@iki.fi
Subject: Re: [PATCH 0/4] wintv 930c-hd: Add basic support
References: <1404244518-8636-1-git-send-email-zzam@gentoo.org>
In-Reply-To: <1404244518-8636-1-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.07.2014 21:55, Matthias Schwarzott wrote:
> This patch series is the third version of my si2165 driver.
> It supports only DVB-T and was tested on 8MHz channels in germany.
> 
> Maybe the si2165 driver also works on other si2165/si2163/si2161 based cards.
> 
I forgot to mention, that support for HVR-5500 is also added.

The card entry is shared with HVR-4400.
It would be interesting to hear what happens when testing this on a
HVR-4400 card, because as far as I know there is an si2161 chip (that
has only DVB-T instead of DVB-T and DVB-C support).
Most likely only some numbers are to be adjusted and it could work also.

The driver should also work for the PCTV QuatroStick 521e - only the usb
ids are not yet added.

Regards
Matthias

