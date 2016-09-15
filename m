Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39648 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933195AbcIOL32 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:29:28 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id DE4CE600A0
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:29:24 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] smiapp: Runtime PM support
Date: Thu, 15 Sep 2016 14:29:16 +0300
Message-Id: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This set adds runtime PM support for the smiapp driver. The old s_power()
callback is made redundant and removed as a result.

These patches go on top of my other patches in the "[PATCH v2 00/17] More
smiapp cleanups, fixes" which I just sent to linux-media.

The patches can also be found here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=smiapp-runtime-pm>

-- 
Kind regards,
Sakari

