Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:53150 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab3CEPnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 10:43:11 -0500
Received: by mail-qa0-f41.google.com with SMTP id bs12so1970315qab.14
        for <linux-media@vger.kernel.org>; Tue, 05 Mar 2013 07:43:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362480928-20382-1-git-send-email-mchehab@redhat.com>
References: <1362480928-20382-1-git-send-email-mchehab@redhat.com>
Date: Tue, 5 Mar 2013 10:43:10 -0500
Message-ID: <CAGoCfiwB9BT2mDQqu2cwsRM-0eraqyxdY0V3fnH+S2RSNiGSdQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] em28xx: add support for two buses on em2874 and upper
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/3/5 Mauro Carvalho Chehab <mchehab@redhat.com>:
> The em2874 chips and upper have 2 buses. On all known devices, bus 0 is
> currently used only by eeprom, and bus 1 for the rest. Add support to
> register both buses.

Did you add a mutex to ensure that both buses cannot be used at the
same time?  Because using the bus requires you to toggle a register
(thus you cannot be using both busses at the same time), you cannot
rely on the existing i2c adapter lock anymore.

You don't want a situation where something is actively talking on bus
0, and then something else tries to talk on bus 1, flips the register
bit and then the thread talking on bus 0 starts failing.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
