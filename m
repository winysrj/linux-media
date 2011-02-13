Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61526 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1BMPn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 10:43:57 -0500
Received: by bwz15 with SMTP id 15so4731548bwz.19
        for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 07:43:55 -0800 (PST)
Date: Sun, 13 Feb 2011 16:43:35 +0100
From: Richard <rz@linux-m68k.org>
To: jamenson@bol.com.br
Cc: linux-media@vger.kernel.org
Subject: Re: Siano SMS1140 DVB Receiver on Debian 5.0 (Lenny)
Message-ID: <20110213154335.GA5301@rz>
References: <4d554a2295c4b_de09815034196@a2-winter4.tmail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d554a2295c4b_de09815034196@a2-winter4.tmail>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Feb 11, 2011 at 12:39:30PM -0200, jamenson@bol.com.br wrote:


> As you can see, driver is not registering the devices. So I did registration:

just curious, how did you do that?

> 
> I'm using kernel 2.6.37 (downloaded from kernel.org) with Debian GNU/Linux 5.0 (Lenny).

try different kernel versions, also sms and other modules support debug options - those
are what I came across:

#options smsdvb debug=3
#options smsusb debug=3
#options dvb_frontend debug=1
#options dvb_frontend dvbdev_debug=1
#options smsmdtv debug=3
#options dvb_core debug=1
#options dvb_core dvbdev_debug=1

Richard

---
Name and OpenPGP keys available from pgp key servers

