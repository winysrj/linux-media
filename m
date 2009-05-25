Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv6.handshake.de ([193.141.176.12]:36635 "EHLO
	srv6.handshake.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZEYR3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 13:29:20 -0400
Received: from smtpproxy (helo=localhost)
	by srv6.handshake.de with local-esmtp (Exim 4.63)
	(envelope-from <operator@handshake.de>)
	id 1M8dz9-0007cV-Tl
	for linux-media@vger.kernel.org; Mon, 25 May 2009 19:29:15 +0200
Message-ID: <4A1AD56B.3000604@handshake.de>
Date: Mon, 25 May 2009 19:29:15 +0200
From: Andreas Besse <operator@handshake.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Re : cannot rmmod stb0899
References: <4A180C71.1080109@handshake.de> <1243219679.13752.1@manu-laptop>
In-Reply-To: <1243219679.13752.1@manu-laptop>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu wrote:
> Easiest way to rmmod stb0899 is to go to your v4l-dvb devel directory
> and do;
> sudo make unload
> indeed stb0899 is needed by other drivers (like budget_ci and others).
> So this command will remove them all.
> Anyway you need to compile all drivers from the same tree else things
> will go wrong.

thank you for your answer. As you can see in the logs of my first
message I tried "make rmmod" in the v4l-dvb directory. This has the same
effect as "make unload". The script is not able to unload the drivers
(ERROR: Module .. is in use).

Any other ideas how to unload the drivers?

regards,
Andreas Besse
