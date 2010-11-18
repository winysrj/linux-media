Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64975 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab0KRK4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 05:56:30 -0500
Received: by wyb28 with SMTP id 28so3081004wyb.19
        for <linux-media@vger.kernel.org>; Thu, 18 Nov 2010 02:56:29 -0800 (PST)
Message-ID: <4CE50654.6030001@gmail.com>
Date: Thu, 18 Nov 2010 11:56:20 +0100
From: =?ISO-8859-1?Q?Ludovic_BOU=C9?= <ludovic.boue@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: saa7146_i2c_writeout issue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I'm using a DVB-S card Technotrend TT budget S-1500 in my production environment (Debian, 2.6.26-2-686, MuMuDVB). I get the last v4l-dvb from http://linuxtv.org/hg/v4l-dvb/.

Basically cards works OK, but I have repeatable error from the Kernel in Syslog:

Nov 18 11:40:11 hannibal kernel: [1202064.284030] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer

How can I fix this ? Is this working http://www.mail-archive.com/linux-dvb@linuxtv.org/msg24759.html ?

Regards,

Ludovic


