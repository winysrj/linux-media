Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46483 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751102AbdHXBGT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 21:06:19 -0400
Subject: Re: [PATCH] build: gpio_ir_tx needs 4.10 at least
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net
References: <1503536501-20252-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <d2750600-48a7-09cb-adb8-33d086e92e91@anw.at>
Date: Thu, 24 Aug 2017 03:06:14 +0200
MIME-Version: 1.0
In-Reply-To: <1503536501-20252-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

With that patch (and the two before), the RC subsystem can be compiled again
with older Kernels (I tested it with 3.13).

BR,
   Jasmin
