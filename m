Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:55071 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750808AbdGLXXc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 19:23:32 -0400
Subject: Re: [PATCH V2 4/9] [media] dvb-core/dvb_ca_en50221.c: Fixed block
 comments
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net
References: <1499900458-2339-1-git-send-email-jasmin@anw.at>
 <1499900458-2339-5-git-send-email-jasmin@anw.at>
 <c8c9b074-32fe-96b8-6635-842898dfc956@iki.fi>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <080f360c-a6cb-0f5c-b2ca-f380a78a2cf9@anw.at>
Date: Thu, 13 Jul 2017 01:23:23 +0200
MIME-Version: 1.0
In-Reply-To: <c8c9b074-32fe-96b8-6635-842898dfc956@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti!

> Quickly looking this patch serie I noticed few other coding style mistakes.
> You should read kernel coding style documentation first, and then make
> changes according to doc.
In fact I used checkpatch.pl to find the issues and fixed them. All the patches
are 100% checkpatch.pl tested and did not have one single error or warning.

So please can you point me to those issues you mean.

BR,
   Jasmin
