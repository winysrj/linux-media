Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57649 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752779AbcLEXGT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 18:06:19 -0500
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
From: Antti Palosaari <crope@iki.fi>
Subject: em28xx broken 4.9.0-rc6+
Message-ID: <790c8863-757c-cd2e-3878-2900df93a694@iki.fi>
Date: Tue, 6 Dec 2016 01:06:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro
I just noticed current em28xx driver seem to be broken. When I plug 
device first time it loads correctly, but when I re-plug it, it does not 
work anymore but yells a lot of noise to message log. Tested with PCTV 
290e and 292e both same. Other USB DVB devices are working so it is very 
likely em28xx driver bug.

Easy to reproduce:
plug device
unplug device
plug device

regards
Antti

-- 
http://palosaari.fi/
