Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37644 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751852AbdI2KkI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 06:40:08 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1002])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id B2060600DF
        for <linux-media@vger.kernel.org>; Fri, 29 Sep 2017 13:40:06 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] smiapp: Don't rely on s_power()
Date: Fri, 29 Sep 2017 13:40:04 +0300
Message-Id: <20170929104006.29892-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

These two patches make the smiapp driver independent of the s_power() core
sub-device callback, and instead use runtime PM to control the device's
power state.

This should be the model for future sensor drivers: the s_power() callback
is really something we want to get rid of.

A cleaner implementation would naturally be nicer. The underlying problem
is that the set_ctrl() callback is called through the control handler so
there's no way to figure out in the set_ctrl() callback itself where the
call came from: via the device's power_on() callback or from the user
calling VIDIOC_S_CTRL.

Another option would be to postpone writing control values until
s_stream() callback but that introduces an additional delay for streaming
which is always better to avoid.

Sakari Ailus (2):
  smiapp: Use __v4l2_ctrl_handler_setup()
  smiapp: Rely on runtime PM

 drivers/media/i2c/smiapp/smiapp-core.c | 97 +++++++++++++---------------------
 drivers/media/i2c/smiapp/smiapp-regs.c |  3 ++
 drivers/media/i2c/smiapp/smiapp.h      |  1 +
 3 files changed, 40 insertions(+), 61 deletions(-)

-- 
2.11.0
