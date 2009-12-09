Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:51053 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbZLIORS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 09:17:18 -0500
Received: by fxm5 with SMTP id 5so7547259fxm.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 06:17:24 -0800 (PST)
MIME-Version: 1.0
From: Valerio Bontempi <valerio.bontempi@gmail.com>
Date: Wed, 9 Dec 2009 15:17:04 +0100
Message-ID: <ad6681df0912090617k768b7f22p9abfb462ff32026f@mail.gmail.com>
Subject: v4l-dvb from source on 2.6.31.5 opensuse kernel - not working
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I am trying to install v4l-dvb drivers from source because my device
(Terratec Cinergy T XS, usb device DVB only) isn't supported by
official v4l-dvb released in last kernel version yet: it is simply
detected with the wrong firmware, but modifing the source code of the
driver is works fine, tested successfully on ubuntu 9.10 (I have
already submitted the patch to v4l team).

I compiled v4l-dvb drivers and installed them through make install,
but then v4l-dvb driver is not working anymore: the video device is
not created, and I don't find any information about my device in dmesg
(neither the message about the wrong firmware). So I am supposing that
v4l-dvb is not working at all.

Does someone know how I can understand where is the problem?

Best regards

Valerio
