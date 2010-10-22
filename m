Return-path: <mchehab@pedra>
Received: from gateway03.websitewelcome.com ([67.18.34.23]:46669 "HELO
	gateway03.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754837Ab0JVHfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 03:35:41 -0400
Received: from [74.125.83.46] (port=48153 helo=mail-gw0-f46.google.com)
	by gator1121.hostgator.com with esmtpsa (TLSv1:RC4-MD5:128)
	(Exim 4.69)
	(envelope-from <demiurg@femtolinux.com>)
	id 1P9C3g-0003V2-EY
	for linux-media@vger.kernel.org; Fri, 22 Oct 2010 02:29:00 -0500
Received: by gwj21 with SMTP id 21so813832gwj.19
        for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 00:29:00 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 22 Oct 2010 09:29:00 +0200
Message-ID: <AANLkTimVc830OkXo44bnqFpWGw_EnUWBPGYd8KjxDTdu@mail.gmail.com>
Subject: Wintv-HVR-1120 incorrectly detected
From: Sasha Sirotkin <demiurg@femtolinux.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There are many reports about Wintv-HVR-1120 card not working
correctly. There are many errors related to dvb-fe-tda10048-1.0.fw
firmware.

Some people noticed that in the earlier versions this same card was
detected differently and the driver was loading a different firmware -
dvb-fe-tda10046.fw.

Is there anybody willing to take a look at this issue ? I can help
with debugging.
