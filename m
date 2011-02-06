Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33684 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab1BFIAM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Feb 2011 03:00:12 -0500
Received: by vxb37 with SMTP id 37so1197170vxb.19
        for <linux-media@vger.kernel.org>; Sun, 06 Feb 2011 00:00:12 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 6 Feb 2011 09:00:12 +0100
Message-ID: <AANLkTim9JUfcEQRBLZiCmQ3G9BYm3xnXUP21hoh4Ehsj@mail.gmail.com>
Subject: STB0899 - lost TS packets when routed via CAM
From: =?UTF-8?Q?Petr_Hroudn=C3=BD?= <petr.hroudny@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

with STB0899-based  TT-Budget S2-3200 I'm occasionaly experiencing
lost TS packets when the stream is routed via CAM. The transponder
bandwidth is quite high, with SR27500, FEC 3/4 and 8PSK it yields
almost 60 Mbit/s. The CAM is a CI+ type, thus capable of running its
TS interface upto 96 Mbit/s, but the question is, whether STB0899 is
suitably tuned for 60 Mbit/s bandwitdh in the default driver.

In the past there were some changes to STB0899_TSOUT register which
aimed at improving performance with CAMs - the current value in the
driver is 0x4d. Has someone an idea what's the exact meaning of this
register and what should be tried to increase bandwidth via CAM?

Thanks in advance for your help,
Petr
