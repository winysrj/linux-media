Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46939 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0EDMUj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 08:20:39 -0400
Received: by fxm10 with SMTP id 10so3139099fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 05:20:37 -0700 (PDT)
Date: Tue, 4 May 2010 14:20:30 +0200
From: Dan Carpenter <error27@gmail.com>
To: jarod@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [-next] [bug report] media/IR/imon: array overflow
Message-ID: <20100504122030.GX29093@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a Smatch thing.  I'm not sure what's intended.

drivers/media/IR/imon.c +1211 imon_panel_key_lookup(10) error: buffer overflow 'imon_panel_key_table' 21 <= 21
  1207          for (i = 0; i < ARRAY_SIZE(imon_panel_key_table); i++)
  1208                  if (imon_panel_key_table[i].hw_code == (code | 0xffee))
  1209                          break;

After the for loop i can be 0 to 21.

  1210
  1211          keycode = imon_panel_key_table[i % IMON_KEY_RELEASE_OFFSET].keycode;

IMON_KEY_RELEASE_OFFSET is 1000 so it doesn't affect anything.

regards,
dan carpenter
