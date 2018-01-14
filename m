Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:42901 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751118AbeANJ0j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 04:26:39 -0500
Subject: Re: [PATCH] media: uvcvideo: Fixed ktime_t to ns conversion
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@s-opensource.com, arnd@arndb.de
References: <1515925303-5160-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <4797925c-c48f-6113-77c9-d645556e3e3b@anw.at>
Date: Sun, 14 Jan 2018 10:26:27 +0000
MIME-Version: 1.0
In-Reply-To: <1515925303-5160-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I tested this patch (compile only) on Kernel 4.4.
For 3.13 there is something else not working, so I (or Hans) needs to have a
look on that.

BR,
   Jasmin
