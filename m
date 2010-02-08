Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:47252 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0BHHUF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 02:20:05 -0500
Received: by bwz23 with SMTP id 23so851682bwz.1
        for <linux-media@vger.kernel.org>; Sun, 07 Feb 2010 23:20:03 -0800 (PST)
Date: Mon, 8 Feb 2010 16:20:14 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [SAA7134, REQUEST] slow register writing
Message-ID: <20100208162014.1c12ec9a@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

I wrote SPI bitbang master over GPIO of saa7134. Speed of writing is much slow then in a Windows systems.
I make some tests:

Windows, SPI bitbang 97002 bytes x 2 time of writing is around 1.2 seconds
Linux, SPI bitbang with call saa7134_set_gpio time of writing is 18 seconds
Linux, SPI bitbang without call saa7134_set_gpio time of writing is 0.25seconds.

The overhead of SPI subsystem is 0.25 seconds. Writing speed to registers of the saa7134
tooooo slooooow.

What you think about it?

With my best regards, Dmitry.
