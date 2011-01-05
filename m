Return-path: <mchehab@gaivota>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38594 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1AEMxT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 07:53:19 -0500
Received: by iwn9 with SMTP id 9so15197724iwn.19
        for <linux-media@vger.kernel.org>; Wed, 05 Jan 2011 04:53:19 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 5 Jan 2011 13:53:17 +0100
Message-ID: <AANLkTi=yt36LX2V7W2s=fK6KQt-0BXwznW72VA1O=ZVD@mail.gmail.com>
Subject: KWorld Dual DVB-T (399U)
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello list, I am getting some problems with my twin DVB-T device:

[ 1343.118485] af9015: command failed:2
[ 1343.118496] af9013: I2C read failed reg:d2e6
[ 1457.208508] af9015: command failed:2
[ 1457.208519] af9013: I2C read failed reg:d2e6
[ 1707.999326] af9015: command failed:2
[ 1707.999338] af9013: I2C read failed reg:d330
[ 2300.180919] af9015: command failed:2
[ 2300.180930] af9013: I2C read failed reg:d2e6
[ 6099.824505] af9015: command failed:2
[ 6099.824519] af9013: I2C read failed reg:d330
[ 6697.288537] af9015: command failed:2
[ 6697.288548] af9013: I2C read failed reg:d2e6
[ 6840.668785] af9015: command failed:2
[ 6840.668796] af9013: I2C read failed reg:d330
[ 7687.376269] af9015: command failed:2
[ 7687.376281] af9013: I2C read failed reg:d2e5
[ 9317.488541] af9015: command failed:2
[ 9317.488553] af9013: I2C read failed reg:d330
[10001.390487] af9015: command failed:2
[10001.390498] af9013: I2C read failed reg:d330
[10178.032510] af9015: command failed:2
[10178.032521] af9013: I2C read failed reg:d2e6
[11395.172504] af9015: command failed:2
[11395.172516] af9013: I2C read failed reg:d330
[12004.728546] af9015: command failed:2
[12004.728558] af9013: I2C read failed reg:d2e6
[12493.461116] af9015: command failed:2
[12493.461127] af9013: I2C read failed reg:d2e6
[14606.278574] af9015: command failed:2
[14606.278586] af9013: I2C read failed reg:d330
[15455.204499] af9015: command failed:2
[15455.204511] af9013: I2C read failed reg:d2e1
[15986.988414] af9015: command failed:2
[15986.988425] af9013: I2C read failed reg:d330
[17096.200505] af9015: command failed:2
[17096.200517] af9013: I2C read failed reg:d330

I am using this firmware:
http://palosaari.fi/linux/v4l-dvb/firmware/af9015/5.1.0.0/dvb-usb-af9015.fw

Is there any way to get it working?

When I am watching a channel, I get lots of bad pixels and is very
difficult to see the TV.

Thanks for all and best regards.

-- 
Josu Lazkano
