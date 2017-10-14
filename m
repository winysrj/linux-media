Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:37620 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdJNABB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 20:01:01 -0400
Subject: Re: [PATCH] build: Fixed patches partly for Kernel 2.6.32
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net
References: <1507938731-23816-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <fd99fe5a-81a8-8c6b-20c7-7c4b277432fa@anw.at>
Date: Sat, 14 Oct 2017 02:00:56 +0200
MIME-Version: 1.0
In-Reply-To: <1507938731-23816-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I have fixed the patches for 2.6.32 partly.
File rc-ir-raw.c is still missing, but I can't fix that.
Moreover, when compiling for 2.6.32, I get errors from compat.h:
   implicit declaration of function 'ktime_to_ms'
So it seems this needs a fix in compat.h also.

I am sending this patch anyway, so that someone may continue.
On the other hand the daily build is done back to Kernel 2.6.36, so it
seems media_build is tested only down to this Kernel Version.

BR,
   Jasmin
