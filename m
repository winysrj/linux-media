Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:51175 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752179AbdEHR24 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 13:28:56 -0400
Subject: Re: [PATCH 01/11] [media] dvb-core/dvb_ca_en50221.c: Rename
 STATUSREG_??
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
 <1494192214-20082-2-git-send-email-jasmin@anw.at>
 <20170508065545.52b26fc9@vento.lan>
Cc: linux-media@vger.kernel.org, max.kellermann@gmail.com
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <3d4c4a10-0c65-9eee-b4e2-b19f1eddb31a@anw.at>
Date: Mon, 8 May 2017 19:28:48 +0200
MIME-Version: 1.0
In-Reply-To: <20170508065545.52b26fc9@vento.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro!

 >> Rename STATUSREG_?? -> STATREG_?? to reduce the line length.
 > That sounds a bad idea. We use "stat" on the DVB subsystem as an
 > alias for statistics.
At the beginning of the style fixes, I thought it is a good idea to reduce
as much as possible to get more characters, but at the end this patch
doesn't save so much, so we can omit it.

What is then the right procedure now?
When I omit it in the first place, I can redo the whole work again and
this were a lot of hours. Would it be acceptable to make a patch no. 12 at
the end of the sequence, which renames it back?

BR,
    Jasmin
