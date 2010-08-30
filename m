Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48151 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab0H3LGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 07:06:09 -0400
Received: by qyk9 with SMTP id 9so2760507qyk.19
        for <linux-media@vger.kernel.org>; Mon, 30 Aug 2010 04:06:08 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 30 Aug 2010 15:06:08 +0400
Message-ID: <AANLkTinNos_vPgk1JvmHsUC+muqr26Y3gg2aDQq0ZWke@mail.gmail.com>
Subject: Current status of cx23885-alsa
From: 4ernov <4ernov@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,
I'm working at adding support of GotView PCIe tuner to cx23885 driver,
I'm quite successful in it for now but I found that audio part of this
driver (cx23885-alsa) is currently not in the main kernel tree and is
maintained in a separate tree. Does anybody now, what its actual
status is and why it is still not in the main tree? Maybe it has some
serious problems? Perhaps I could help its development somehow.

Thanks in advance,
Alexey Chernov
