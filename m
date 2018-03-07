Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:34401 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933487AbeCGRLa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 12:11:30 -0500
Received: by mail-qt0-f180.google.com with SMTP id l25so3514984qtj.1
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 09:11:30 -0800 (PST)
Message-ID: <1520442688.19980.1.camel@gmail.com>
Subject: v4l-utils fails to build against musl libc (with patch)
From: bjornpagen@gmail.com
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Bjorn Pagen <bjornpagen@gmail.com>
Date: Wed, 07 Mar 2018 12:11:28 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey all,

v4l-utils currently fails to build against musl libc, since musl, and
POSIX, both do not define TEMP_FAILURE_RETRY() or strndupa(). 

This can be fixed with a small patch from https://git.alpinelinux.org/c
git/aports/tree/community/v4l-utils/0001-ir-ctl-fixes-for-musl-compile.
patch.

Please email me back with any questions or concerns about the patch or
musl.

Thanks,
Bjorn Pagen
