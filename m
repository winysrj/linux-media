Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:55789 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751554AbdLJOb6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Dec 2017 09:31:58 -0500
Subject: Re: [PATCH] build: Revert 41e33085284dd2bc6b6180d8381ff8a509b9d8ba
 for < 3.19
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net
References: <1512916080-5938-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <2459b0d7-bb8d-a580-6869-20313f910713@anw.at>
Date: Sun, 10 Dec 2017 15:31:53 +0100
MIME-Version: 1.0
In-Reply-To: <1512916080-5938-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

With this patch it compiles back to kernel 2.6.36.
I tested it with 3.13, 3.4 and 2.6.36.
Don't forget to merge also my "READ_ONCE" patch.

BR,
   Jasmin
