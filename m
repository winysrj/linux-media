Return-path: <linux-media-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:11563 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbZE0Lqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 07:46:54 -0400
Received: by wa-out-1112.google.com with SMTP id j5so967746wah.21
        for <linux-media@vger.kernel.org>; Wed, 27 May 2009 04:46:55 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 May 2009 19:46:55 +0800
Message-ID: <15ed362e0905270446n11a464bagbe2e013b42f9bd50@mail.gmail.com>
Subject: i2c-compat.h and old kernel support
From: David Wong <davidtlwong@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I found that i2c-compat.h is not referred by any linux/media code and
it seems code for Linux 2.4/2.5 support.
What is the minimum supporting kernel of the current development tree?
It looks like i2c-compat.h could be dropped.

David
