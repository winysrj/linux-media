Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:59956 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752104AbdJKWqO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 18:46:14 -0400
Subject: Re: [PATCH] build: Update
 backports/v2.6.37_dont_use_alloc_ordered_workqueue.patch
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net
References: <1507761756-23020-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <f8469966-4fe3-b00c-f3f3-6f534561251e@anw.at>
Date: Thu, 12 Oct 2017 00:46:09 +0200
MIME-Version: 1.0
In-Reply-To: <1507761756-23020-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Even with this patch Kernel 2.6.x can't be compiled due to "linux/bsearch.h"
missing. But this patch is the first step in the right direction.

BR,
   Jasmin
