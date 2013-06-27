Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43617 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3F0VLm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 17:11:42 -0400
Received: by mail-ea0-f172.google.com with SMTP id q10so657772eaj.17
        for <linux-media@vger.kernel.org>; Thu, 27 Jun 2013 14:11:41 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 0/2] v4l-utils: Fix crashes found by Mayhem
Date: Thu, 27 Jun 2013 23:11:29 +0200
Message-Id: <1372367491-13187-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Mayhem Team ran their code checker over the Debian archive and
also found two crashes in v4l-utils.

See http://lists.debian.org/debian-devel/2013/06/msg00720.html

Gregor Jasny (2):
  libv4lconvert: Prevent integer overflow by checking width and height
  keytable: Always check if strtok return value is null

 lib/libv4lconvert/ov511-decomp.c |  7 ++++++-
 lib/libv4lconvert/ov518-decomp.c |  7 ++++++-
 utils/keytable/keytable.c        | 19 ++++++++++++++++---
 3 files changed, 28 insertions(+), 5 deletions(-)

-- 
1.8.3.1

