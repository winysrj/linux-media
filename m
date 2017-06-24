Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:47974 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754804AbdFXTgi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 15:36:38 -0400
Subject: Re: [PATCH 3/7] [media] dvb-core/dvb_ca_en50221.c: Add block
 read/write functions
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
 <1494190313-18557-4-git-send-email-jasmin@anw.at>
 <20170624161613.4a08314c@vento.lan>
Cc: linux-media@vger.kernel.org, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <b7c58a73-00da-332e-4c6d-3659c5825f3e@anw.at>
Date: Sat, 24 Jun 2017 21:36:30 +0200
MIME-Version: 1.0
In-Reply-To: <20170624161613.4a08314c@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro!

> Please check the patch with checkpatch.pl:
I am nearly finished with a V2 series of this set, where I partly changed
some of this issues.
We decided to split the monster thread function into a sub function to make it
more readable and also to overcome the 80 line length limit which gets even
worse because of the additional indention due to this patch.
See: https://www.spinics.net/lists/linux-media/msg116599.html
There you wrote:
  The idea behind patch 04/11 makes sense to me. I'll review it carefully
  after having everything applied.

  Please re-send the first series, making sure that the authorship is
  preserved.

I am nearly finished with the first series and THEN I plan to do parts of the
second series again including the splitting of the thread function.

BR,
   Jasmin
