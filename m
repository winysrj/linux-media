Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4C0C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 21:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD9132146E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 21:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbfCMVR3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 17:17:29 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:37893 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfCMVR3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 17:17:29 -0400
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MKszj-1hKLaP2FXZ-00LAnW; Wed, 13 Mar 2019 22:17:12 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Sean Young <sean@mess.org>,
        Colin Ian King <colin.king@canonical.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: dib0700: fix link error for dibx000_i2c_set_speed
Date:   Wed, 13 Mar 2019 22:16:53 +0100
Message-Id: <20190313211709.486583-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:RMZUATCnG99VGNTOjTvIXdQyLvNkz779PJ7UrqeFNzigEIq+XwK
 Qrc6xpWdDA7wT+UmwrzUKSZRnr2COE43+K9gx88kdhsyao2GaMmqT/2zdkJ2hdADapTs8EJ
 7fiIyKVesw08XrNlHPQK9VL/vSLQ8mFRb4+K+0RMvweguTrKO6gZhfWcoHBGucKi89fCQtm
 kJ7qj6msl9N/5LFnFHEJA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2JM+skA71oo=:jff/z63rLEksqJkilsE1E4
 G/WhGLSSjPQKPI7S6zH8ujmEB/FqRKFp4TGo3U0bNCzmlErRCvYvyzCYgvAjLgWZNPgIaSEoX
 8bhKHOXapS2bG8DufigK8+LTE6zahP7L6lwl+fBUoxeR1CluEGWIKdR2E0GcKQLFzv8/b2rO6
 JKhE6eVWGsGNaaoTt9osgDGEf1ZDQtr6YkCUkiEudoEyc2JwkX8N9j6Et/RiTyhzPrLpC6bye
 o0E6hmKgsF/16HOFDDb0mGpbgd7bKhOum2FMnZVF7ZVhB/eePtMLIdNe/hcJ8SsTwYYKqE5m6
 5tVExEz4UqUMEIAMm6TCPcOBDBOqttwlNFfgun55TkUBqW3t32IJrUE8UbqflyT9zFdFwL+vb
 Pg+5ahKGyVXlDIcwtNoAawhfU+ugrH4nVs6t8X+YEeqYD9rCqLX+uJr33M68BPJr7qyun0Mx1
 qJj+gJluKR3Keqo7u8ySxHvaAfhBc5ofopA7TniAPYPL3gBmZcmYD0HGCbJ8zRnM+30af6QMR
 FrhAy1YUmss/rXM07FNQL8KamnOR60QNuppXaTwS1GwXaehWImtSuveLwzIOtY31NU03tGFyB
 j70fPQ23Co4gGjLCnfuaVpz8FyWbU0d8ye8QdNxS+L2jqVz31i6jDFz8Xheiclf74yGReKpfN
 poTJGI8u+bwqw6qC8fB38q1DGeNqUvg+8fLC+fsbCr9Qtjg3AVUFW2PprSPmA8OFs4Uk8docP
 tjGgNXeDN4tkEYcP5jsPa6G8ihKaj75kDxZAKg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When CONFIG_DVB_DIB9000 is disabled, we can still compile code that
now fails to link against dibx000_i2c_set_speed:

drivers/media/usb/dvb-usb/dib0700_devices.o: In function `dib01x0_pmu_update.constprop.7':
dib0700_devices.c:(.text.unlikely+0x1c9c): undefined reference to `dibx000_i2c_set_speed'

The call sites are both through dib01x0_pmu_update(), which gets
passed an 'i2c' pointer from dib9000_get_i2c_master(), which has
returned NULL. Checking this pointer seems to be a good idea
anyway, and it avoids the link failure.

Fixes: b7f54910ce01 ("V4L/DVB (4647): Added module for DiB0700 based devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 9311f7d4bba5..4cbc64ea17d7 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -2445,6 +2445,8 @@ static int dib9090_tuner_attach(struct dvb_usb_adapter *adap)
 	if (dvb_attach(dib0090_fw_register, adap->fe_adap[0].fe, i2c, &dib9090_dib0090_config) == NULL)
 		return -ENODEV;
 	i2c = dib9000_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_1_2, 0);
+	if (!i2c)
+		return -ENODEV;
 	if (dib01x0_pmu_update(i2c, data_dib190, 10) != 0)
 		return -ENODEV;
 	dib0700_set_i2c_speed(adap->dev, 1500);
@@ -2524,6 +2526,8 @@ static int nim9090md_tuner_attach(struct dvb_usb_adapter *adap)
 	if (dvb_attach(dib0090_fw_register, adap->fe_adap[0].fe, i2c, &nim9090md_dib0090_config[0]) == NULL)
 		return -ENODEV;
 	i2c = dib9000_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_1_2, 0);
+	if (!i2c)
+		return -ENODEV;
 	if (dib01x0_pmu_update(i2c, data_dib190, 10) < 0)
 		return -ENODEV;
 
-- 
2.20.0

