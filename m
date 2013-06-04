Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47747 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3FDV4N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 17:56:13 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/7] rtl28xxu changes, mainly remote controller
Date: Wed,  5 Jun 2013 00:54:56 +0300
Message-Id: <1370382903-21332-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It contains mainly remote controller implementation for rtl2832u.
I will pull request it soon.
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/rtl28xxu

Antti Palosaari (5):
  rtl28xxu: reimplement rtl2832u remote controller
  rtl28xxu: remove redundant IS_ENABLED macro
  rtl28xxu: correct some device names
  rtl28xxu: map remote for TerraTec Cinergy T Stick Black
  rtl28xxu: use masked reg write where possible

Miroslav Šustek (1):
  rtl28xxu: Add USB ID for Leadtek WinFast DTV Dongle mini

Rodrigo Tartajo (1):
  rtl2832u: restore ir remote control support.

 drivers/media/usb/dvb-usb-v2/dvb_usb.h  |   2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 178 ++++++++++++++------------------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   6 ++
 3 files changed, 85 insertions(+), 101 deletions(-)

-- 
1.7.11.7

