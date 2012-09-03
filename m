Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.fr.smartjog.net ([95.81.144.3]:43897 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab2ICOLi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 10:11:38 -0400
Message-ID: <5044BA93.8080807@smartjog.com>
Date: Mon, 03 Sep 2012 16:11:31 +0200
From: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] [media] ds3000: properly report firmware loadingissues
References: <1346319391-19015-1-git-send-email-remi.cardona@smartjog.com>, <1346319391-19015-3-git-send-email-remi.cardona@smartjog.com>, <503F6D18.2060804@iki.fi>, <503F84F5.9010304@smartjog.com> <201208311629500154084@gmail.com>
In-Reply-To: <201208311629500154084@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Max,

On 08/31/2012 10:29 AM, nibble.max wrote:
> As remember that there is a fault in the tuner register read function in ds3000.c file.
> It will cause the read back value wrong.

Well, using 0x12 works out for most of the cards we have in the wild.
Not knowing what 0x11 / 0x12 means, I'd be wary of suggesting such a
change myself. Once I isolate the faulty cards, I'll try using 0x11 on
them to see if it changes anything.

Thanks for the pointer,

Rémi
