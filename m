Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51360 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2EYMfe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 08:35:34 -0400
Received: by vbbff1 with SMTP id ff1so604067vbb.19
        for <linux-media@vger.kernel.org>; Fri, 25 May 2012 05:35:33 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 25 May 2012 08:35:33 -0400
Message-ID: <CAOcJUbwYbphYgBNaiMKNk7MvG0BFtepR3AXBmojxU51Ta4rZzQ@mail.gmail.com>
Subject: [PULL] smsusb: add autodetection support for USB ID 2040:f5a0
 (2012-05-25 08:32:17 -0400)
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit abed623ca59a7d1abed6c4e7459be03e25a90a1e:

  [media] radio-sf16fmi: add support for SF16-FMD (2012-05-20 16:10:05 -0300)

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/hauppauge windham-ids

for you to fetch changes up to cfd9b78596cbe0c96b1ff3b83e1e25f128fe3003:

  smsusb: add autodetection support for USB ID 2040:f5a0 (2012-05-25
08:32:17 -0400)

----------------------------------------------------------------
Michael Krufky (1):
      smsusb: add autodetection support for USB ID 2040:f5a0

 drivers/media/dvb/siano/smsusb.c |    2 ++
 1 file changed, 2 insertions(+)
