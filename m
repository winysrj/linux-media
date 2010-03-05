Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:38308 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab0CEQch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Mar 2010 11:32:37 -0500
Received: by pzk32 with SMTP id 32so1458346pzk.4
        for <linux-media@vger.kernel.org>; Fri, 05 Mar 2010 08:32:36 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 5 Mar 2010 17:32:36 +0100
Message-ID: <815e21b51003050832j728a915byf7909badc85ddd16@mail.gmail.com>
Subject: DVB-S2 Multistream (?)
From: Matteo <marchimatteo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have problems with some frequencies which I suppose are broadcasted
in DVB-S2 Multistream,  I think it's the same topic already discussed
a long time ago here:
http://www.mail-archive.com/linux-dvb@linuxtv.org/msg26874.html

Frequencies that use this feature on Hotbird (13°E) should be:

11334 MHz, pol H, SR 27500
11373 MHz, pol H, SR 27500
11432 MHz, pol V, SR 27500

I can lock the frequencies, but the signal is really unstable, video
full of errors, and everytime I do a scan I get the channel list from
only one TS (apparently chosen randomly). Exact same problems on
Windows.

I use a TechnoTrend S2-1600, and I was wondering if there is any plan
to eventually support this feature (if it's not an hardware
limitation).


Thanks
Matteo
