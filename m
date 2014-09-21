Return-path: <linux-media-owner@vger.kernel.org>
Received: from kripserver.net ([91.143.80.239]:56351 "EHLO mail.kripserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaIUUyW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 16:54:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.kripserver.net (Postfix) with ESMTP id CD2DB3AE096
	for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 20:45:38 +0000 (UTC)
Received: from mail.kripserver.net ([91.143.80.239])
	by localhost (mail.kripserver.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 0YCu_bjnFPJf for <linux-media@vger.kernel.org>;
	Sun, 21 Sep 2014 20:45:37 +0000 (UTC)
Received: from [192.168.189.220] (unknown [185.5.28.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kripserver.net (Postfix) with ESMTPSA id 6132D3AE094
	for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 20:45:37 +0000 (UTC)
Message-ID: <541F38F0.2010904@kripserver.net>
Date: Sun, 21 Sep 2014 22:45:36 +0200
From: Jannis <jannis-lists@kripserver.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Running Technisat DVB-S2 on ARM-NAS
References: <541EE016.9030504@gmx.net> <541EE2EB.4000802@iki.fi> <541EEA74.2000909@gmx.net> <541EEEAB.10106@iki.fi> <541F0AC7.4010004@gmx.net>
In-Reply-To: <541F0AC7.4010004@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 21.09.2014 um 19:28 schrieb JPT:
> Tommorrow I'll swap the sat cable just to make sure this isn't the cause.

Hi Jan,

Are we talking about this device:
http://www.linuxtv.org/wiki/index.php/Technisat_SkyStar_USB_HD
(You never mentioned the actual model AFAIK)?

If so, it has two LEDs. A red one for "power" and a green one for
"tuned"/"locked". So if the green one lights up, the sat cable should be
okay.

I remember having tested my one with the RaspberryPi and it worked. So
it is not a general problem of the DVB-S2 device and ARM but rather the
specific board you are working with.
Just found the link where I reported success:
https://github.com/raspberrypi/linux/issues/82#issuecomment-27253775

Best regards,
	Jannis

