Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34878 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756715AbeDZR1g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 13:27:36 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/7] media_build: various kernel version fixes
Date: Thu, 26 Apr 2018 12:19:15 -0500
Message-Id: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This first four patches in this set disables drivers which cannot
be compiled before a specific kernel revision.

To fix of_find_i2c_device_by_node|of_find_i2c_adapter_by_node in
kernels 3.5 to 3.11.x the correct header is included.

The frame_vector.c wildcard check also appears to be broken for me.
The check is changed from using relative patch to absolute path,
and verifying frame_vector.c is in the build dir (v4l/) instead
of in the linux/ directory.

Lastly, I have one new addition to contemplate. I maintain driver
packages for a lot of different kernel revisions on a lot of different
architectures and some times make_config_compat.pl incorrectly
enables backport options which cause build failure. Instead of
making the config check more complicated I propose creation and
inclusion of an empty config-mycompat.h, after config-compat.h is included
in compat.h, which would allow for overriding any options necessary
due to symbols/macros/etc already existing in the target kernel.
config-mycompat.h would be touched before make_config_compat.h is
called and deleted during distclean, allowing a builder to copy any
overrides into the header before starting the compilation process.
This would allow usage of the media_build system without having to
supply out of tree patches to correct the 'bad' options. If I
somehow missed this functionality a pointer to it would be lovely.


Brad Love (7):
  Disable VIDEO_ADV748X for kernels older than 4.8
  Disable additional drivers requiring gpio/consumer.h
  Disable DVBC8SECTPFE for kernels older than 3.5
  Disable SOC_CAMERA for kernels older than 3.5
  Header location fix for 3.5.0 to 3.11.x
  Fix frame vector wildcard file check
  Add config-compat.h override config-mycompat.h

 v4l/Makefile     |  5 +++--
 v4l/compat.h     | 14 ++++++++++++++
 v4l/versions.txt | 18 ++++++++++++++++--
 3 files changed, 33 insertions(+), 4 deletions(-)

-- 
2.7.4
