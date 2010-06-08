Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64087 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab0FHEpX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jun 2010 00:45:23 -0400
Received: by vws17 with SMTP id 17so966961vws.19
        for <linux-media@vger.kernel.org>; Mon, 07 Jun 2010 21:45:22 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 Jun 2010 23:45:22 -0500
Message-ID: <AANLkTikJzaAnTNGNFZY4B7aYctuq-aejsRiDmkBWMSzZ@mail.gmail.com>
Subject: VBI support for em2870 (Kworld UB435-Q)
From: Vasilis Liaskovitis <vliaskov@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI,

I can successfully use my Kworld UB435-Q for OTA capture thanks to the
development work in this thread:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg10472.html

however I 'd like to get closed captioning support if possible. I
don't get a /dev/vbi device with the current em28xx driver.

Does the em2870 chip support VBI in the first place?

If yes, is there vbi-ntsc support for it in a development branch somewhere?

thanks for your help,

- Vasilis
