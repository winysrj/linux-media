Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:46047 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751383AbeDRQML (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 12:12:11 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/5] media_build: Backport fixes and patches
Date: Wed, 18 Apr 2018 11:12:02 -0500
Message-Id: <1524067927-12113-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set provides lgdt3306a backports for
v3.4, v3.6, and v4.6. The v4l/versions.txt file
is also fixed up for a couple drivers with
included backports.


Brad Love (5):
  Enable two drivers with backports
  lgdt3306a v3.4 i2c mux backport
  lgdt3306a v3.6 i2c mux backport
  lgdt3306a v4.6 i2c mux backport
  Remove lgdt3306a v4.7 limitation

 backports/v3.4_i2c_add_mux_adapter.patch |  14 ++
 backports/v3.6_i2c_add_mux_adapter.patch |  12 ++
 backports/v4.6_i2c_mux.patch             | 213 +++++++++++++++++++++++++++++++
 v4l/versions.txt                         |   3 -
 4 files changed, 239 insertions(+), 3 deletions(-)

-- 
2.7.4
