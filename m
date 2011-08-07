Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33797 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1HGKPG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Aug 2011 06:15:06 -0400
Received: by qyk38 with SMTP id 38so1104694qyk.19
        for <linux-media@vger.kernel.org>; Sun, 07 Aug 2011 03:15:06 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 7 Aug 2011 12:15:04 +0200
Message-ID: <CAOHPzxw5Hxwz=xLv+DF-+azF5WryhLFF=hU+xv6CAYtRKOEAdg@mail.gmail.com>
Subject: PAL support for Hauppauge 2200 (saa7164)
From: Patrick Ruckstuhl <patrick@ch.tario.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

in my country, PAL is the tv standard so after searching on the internet I
found this patch to make the driver work with PAL

http://www.spinics.net/lists/linux-media/msg27603.html

the patch work's perfectly for me and the card is really working great.

But to get it working, I have to manually patch my kernel and recompile this
stuff, so I'm wondering if there's any chance/way to get this merged into
the main branch so that other people could profit from this as well.

Thanks,
Patrick
