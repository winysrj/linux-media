Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43568 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbdHBQqE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 12:46:04 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi
Subject: [PATCH 0/2] Fix use-after-free errors when unregistering the i2c_client for the dvb demod
Date: Wed,  2 Aug 2017 18:45:58 +0200
Message-Id: <20170802164600.19553-1-zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

There seem to be a general error in a lot of dvb bride drivers about the order of i2c_unregister_device
and the calls to dvb_unregister_frontend and dvb_frontend_detach.

As soon as the i2c_client for a demod driver is unregistered the memory for the frontend is kfreed.
But the calls to dvb_unregister_frontend and dvb_frontend_detach access it later.

I fixed the error in cx23885 and cx231xx driver as I have access to the hardware.

Further drivers that might show the same bug (but I cannot test):
* em28xx
* ddbride
* saa7164

Regards
Matthias
