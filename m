Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42525 "EHLO
        einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752854AbcJSW4W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 18:56:22 -0400
Date: Thu, 20 Oct 2016 00:55:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux1394-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 53/58] firewire: don't break long lines
Message-ID: <20161020005535.069638cb@kant>
In-Reply-To: <20161019081920.15b97eb7@vento.lan>
References: <cover.1476822924.git.mchehab@s-opensource.com>
        <bce754e03eef20b560c05a33d7cf68f6030e68e7.1476822925.git.mchehab@s-opensource.com>
        <84c06fb2-d147-689d-8d42-ce6b1f400a1f@sakamocchi.jp>
        <20161019081920.15b97eb7@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 19 Mauro Carvalho Chehab wrote:
> Em Wed, 19 Oct 2016 08:03:01 +0900
> Takashi Sakamoto <o-takashi@sakamocchi.jp> escreveu:
> > A structure for firedtv (struct firedtv) has a member for a pointer to
> > struct device. In this case, we can use dev_dbg() for debug printing.
[...]
> Stefan,
> 
> Would the above be OK for you?

ACK.
-- 
Stefan Richter
-======----- =-=- =-=--
http://arcgraph.de/sr/
