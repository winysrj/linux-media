Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58953 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2CFNsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 08:48:03 -0500
Received: by eekc41 with SMTP id c41so1888705eek.19
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2012 05:48:01 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: dheitmueller@kernellabs.com, snjw23@gmail.com,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 0/2] as102: fix regression in kernel 3.3
Date: Tue,  6 Mar 2012 14:47:44 +0100
Message-Id: <1331041666-22361-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When I first tried the as102 driver in the 3.3 kernel, I was pleased to notice
that finally my stick was able to tune VHF channels. It never worked in VHF
even with the original Kernellabs driver.

But a few days ago a linux user from Melbourne, Ryley, contacted me to let me
know he had a completely different experience: his Elgato stick was able to
tune VHF channels with the 3.2 driver, but not with the 3.3 one.

Ryley tracked down the issue to this patch:
http://patchwork.linuxtv.org/patch/8332/
In that patch, "#pragma pack(1)" is replaced with "__packed" attributes, but
it is not complete.

Patch 1 fixes the regression.

It also fixes the issue reported by Ryley, and his Elgato sticks works again
with VHF channels. But this patch also breaks again VHF tuning with my
reference design stick.

So I investigated the real effect of the regression: it turned out that the only
struct really affected was "as10x_fw_context".

The as10x_fw_context command is only used in two functions:
as10x_cmd_set_context() and as10x_cmd_get_context().

as10x_cmd_get_context() is not used anywhere in the driver.

as10x_cmd_set_context() is only used in one place in the driver:
in function as102_fe_ts_bus_ctrl (file as102_fe.c, line 252):

if (acquire) {
	if (elna_enable)
		as10x_cmd_set_context(&dev->bus_adap, 1010, 0xC0);
.....

So the command is only used to enable the eLNA (Low Noise Amplifier).
In kernel 3.3, the command failed silently due to bad formatting, so the eLNA
amplifier was never enabled.

But disabling the eLNA amplifier is not optimal even for my stick, so I played
with the eLNA configuration value (hardcoded to 0xC0 in the original code).
I found that for my stick the optimal value is 0xA0. 

Patch 2 introduces device specific eLNA configuration values. With this patch,
all as102 sticks should work out-of-the-box with both UHF and VHF channels.

Gianluca Gennari (2):
  as102: add __packed attribute to structs defined inside packed structs
  as102: set optimal eLNA config values for each device

 drivers/staging/media/as102/as102_drv.h     |    2 +-
 drivers/staging/media/as102/as102_fe.c      |    2 +-
 drivers/staging/media/as102/as102_fw.h      |    2 +-
 drivers/staging/media/as102/as102_usb_drv.c |   15 +++++-
 drivers/staging/media/as102/as10x_cmd.h     |   80 +++++++++++++-------------
 drivers/staging/media/as102/as10x_types.h   |    2 +-
 6 files changed, 58 insertions(+), 45 deletions(-)

