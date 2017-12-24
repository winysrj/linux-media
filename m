Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:42317 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbdLXKsp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Dec 2017 05:48:45 -0500
Subject: Re: [PATCH] build: Added missing get_user_pages_longterm
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net
References: <1514115783-12306-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <b5b2c7c4-5e52-d8b4-37de-f509afe748da@anw.at>
Date: Sun, 24 Dec 2017 11:48:35 +0000
MIME-Version: 1.0
In-Reply-To: <1514115783-12306-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I tested this with Kernel 4.4 and Kernel 3.13. It should fix the build for
newer Kernels also (requires my other build patch "Disabled
MEDIA_TUNER_TDA18250 for Kernels older than 4.3" (newer version) to be
applied).

Merry Christmas,
   Jasmin
