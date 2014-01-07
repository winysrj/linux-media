Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:53495 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaAGL6r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 06:58:47 -0500
Received: by mail-oa0-f52.google.com with SMTP id o6so40763oag.25
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 03:58:46 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 7 Jan 2014 11:58:46 +0000
Message-ID: <CAGj5WxCajB0ORTQ_rz9wv+ec9bXE1A9tM_MGP3qb0eyaxhC5ew@mail.gmail.com>
Subject: Upstreaming SAA716x driver to the media_tree
From: Luis Alves <ljalvs@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: andreas.regel@gmx.de, updatelee@gmail.com, abraham.manu@gmail.com,
	crazycat69@narod.ru, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm finishing a new frontend driver for one of my dvb cards, but the
pcie bridge uses the (cursed) saa716x.
As far as I know the progress to upstream Manu's driver to the
media_tree has stalled.

In CC I've placed some of the people that I found working on it
lately, supporting a few dvb cards.

It would be good if we could gather everything in one place and send a
few patchs to get this upstreamed for once...

Manu, do you see any inconvenience in sending your driver to the
linux_media tree?
I'm available to place some effort on this task.

Regards,
Luis Alves
