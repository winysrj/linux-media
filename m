Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32861 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937005AbdCJNHj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 08:07:39 -0500
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH 0/2] staging: media: Remove parentheses from return arguments
Date: Fri, 10 Mar 2017 18:37:22 +0530
Message-Id: <1489151244-20714-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch-series removes unnecessary parantheses from return arguments.

simran singhal (2):
  staging: css2400/sh_css: Remove parentheses from return arguments
  staging: sh_css_firmware: Remove parentheses from return arguments

 .../media/atomisp/pci/atomisp2/css2400/sh_css.c      | 20 ++++++++++----------
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c   |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

-- 
2.7.4
