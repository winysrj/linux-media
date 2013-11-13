Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:52907 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab3KMX0X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Nov 2013 18:26:23 -0500
Received: by mail-yh0-f45.google.com with SMTP id i7so637529yha.32
        for <linux-media@vger.kernel.org>; Wed, 13 Nov 2013 15:26:22 -0800 (PST)
Date: Wed, 13 Nov 2013 18:01:24 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, ljalvs@gmail.com
Subject: [GIT PULL] git://linuxtv.org/mkrufky/dvb cx24117
Message-ID: <20131113180124.16699fa7@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

  [media] media: st-rc: Add ST remote control driver (2013-10-31
  08:20:08 -0200)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb cx24117

for you to fetch changes up to 1c468cec3701eb6e26c4911f8a9e8e35cbdebc01:

  cx24117: Fix LNB set_voltage function (2013-11-13 13:06:44 -0500)

----------------------------------------------------------------
Luis Alves (2):
      cx24117: Add complete demod command list
      cx24117: Fix LNB set_voltage function

 drivers/media/dvb-frontends/cx24117.c | 121
 ++++++++++++++++++++-------------- 1 file changed, 71 insertions(+),
 50 deletions(-)
