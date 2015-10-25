Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw1.han.skanova.net ([81.236.60.204]:57518 "EHLO
	v-smtpgw1.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbJYKls (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Oct 2015 06:41:48 -0400
Received: from [192.168.0.3] (tobbe.lan [192.168.0.3])
	by gammdatan.lan (8.15.2/8.14.7) with ESMTP id t9PAZiwj016848
	for <linux-media@vger.kernel.org>; Sun, 25 Oct 2015 11:35:44 +0100
To: linux-media@vger.kernel.org
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Subject: media_build broken by missing vb2.h
Message-ID: <562CB086.4030702@mbox200.swipnet.se>
Date: Sun, 25 Oct 2015 11:35:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

i just tried to compile media_build as of today but it doesn't work very 
well.

after a while it errors with:
media_build/v4l/vb2-trace.c:4:30: fatal error: trace/events/vb2.h: No 
such file or directory

i assume something is broken in the git repo and i just have to wait? or 
did i do something wrong?

/T
