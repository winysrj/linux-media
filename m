Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:48352 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754739AbdFXUD5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 16:03:57 -0400
Subject: Re: [PATCH 3/7] [media] dvb-core/dvb_ca_en50221.c: Add block
 read/write functions
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
 <1494190313-18557-4-git-send-email-jasmin@anw.at>
 <20170624161613.4a08314c@vento.lan>
 <b7c58a73-00da-332e-4c6d-3659c5825f3e@anw.at>
Cc: linux-media@vger.kernel.org, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <938a2d2c-2caf-7a0e-2d01-c9e8be2e1362@anw.at>
Date: Sat, 24 Jun 2017 22:03:49 +0200
MIME-Version: 1.0
In-Reply-To: <b7c58a73-00da-332e-4c6d-3659c5825f3e@anw.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro!

> We decided to split the monster thread function into a sub function to make
> it more readable and also to overcome the 80 line length limit ...
Sorry I mixed the patches. I will cleanup this patch to make checkpatch silent.

BR,
   Jasmin
