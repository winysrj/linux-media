Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:44392 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbeANKKo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 05:10:44 -0500
Subject: Re: [PATCH] build: Disabled VIDEO_IPU3_CIO2 for Kernels older than
 3.18.17
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net
References: <1515927819-27521-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <7a490bd9-3744-d2cd-b44d-4f44902a8e8f@anw.at>
Date: Sun, 14 Jan 2018 11:10:36 +0000
MIME-Version: 1.0
In-Reply-To: <1515927819-27521-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

With that it compiles again for Kernel 3.13.

Please note, that
  https://patchwork.linuxtv.org/patch/46464/
needs to be applied to compile for Kernels older 4.10.

BR,
   Jasmin
