Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55144 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaI3PR3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 11:17:29 -0400
Received: by mail-wi0-f173.google.com with SMTP id bs8so4577187wib.6
        for <linux-media@vger.kernel.org>; Tue, 30 Sep 2014 08:17:27 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 0/3] libdvbv5: Remove broken descriptor parsers
Date: Tue, 30 Sep 2014 17:17:05 +0200
Message-Id: <1412090228-19996-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this patch series removes the service_list and service_location
descriptors. It breaks API compatibility by removing the public
header files but maintains ABI compatibility by providing stub
implementations.

Thanks,
Gregor

Gregor Jasny (3):
  libdvbv5: Add todo file
  libdvbv5: remove service_location descriptor
  libdvbv5: remove service_list descriptor

 TODO.libdvbv5                                    |   3 +
 doxygen_libdvbv5.cfg                             |   1 -
 lib/include/libdvbv5/desc_service_list.h         | 119 -----------------------
 lib/include/libdvbv5/desc_service_location.h     | 107 --------------------
 lib/libdvbv5/Makefile.am                         |   5 +-
 lib/libdvbv5/compat-soname.c                     |  44 +++++++++
 lib/libdvbv5/descriptors.c                       |   8 --
 lib/libdvbv5/descriptors/desc_service_list.c     |  56 -----------
 lib/libdvbv5/descriptors/desc_service_location.c |  80 ---------------
 9 files changed, 48 insertions(+), 375 deletions(-)
 create mode 100644 TODO.libdvbv5
 delete mode 100644 lib/include/libdvbv5/desc_service_list.h
 delete mode 100644 lib/include/libdvbv5/desc_service_location.h
 create mode 100644 lib/libdvbv5/compat-soname.c
 delete mode 100644 lib/libdvbv5/descriptors/desc_service_list.c
 delete mode 100644 lib/libdvbv5/descriptors/desc_service_location.c

-- 
2.1.0

