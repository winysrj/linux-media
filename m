Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:57318 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2JSD54 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Oct 2012 23:57:56 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so30995iag.19
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2012 20:57:55 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 20:57:54 -0700
Message-ID: <CAA7C2qizZz0bPjQnvuCfwjs0-Micqq4aoJKBLzwqZiMnAR10Dg@mail.gmail.com>
Subject: media_build v4l/Makefile is broken
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi. It seems v4l/Makefile from media_build does:

==========
ifeq ($(wildcard ../linux/include/linux/videodev2.h),)

# No kernel source! User needs to download one
def:
        @echo 'No kernel files. You need to run "make download untar"
or "make dir DIR=<your_git_source_dir>" first!'
        exit 1
endif
==========

However, videodev2.h is located in: ../linux/include/uapi/linux/videodev2.h

Maybe find would be a better choice for that check?
