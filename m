Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50616 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab2JEWoT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 18:44:19 -0400
Message-ID: <506F62AB.1040108@iki.fi>
Date: Sat, 06 Oct 2012 01:43:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Gianluca Gennari <gennarone@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: em28xx #0: submit of audio urb failed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That one is the other bug what I see when I plug em28xx device with 
analog support. After that error is seen it is not possible to unload 
modules until device is removed physically. I am quite sure that error 
hasn't been there very long.

Before that error happens there is other bug - it mutes whole computer 
volume for a while. I asked that earlier too on IRC and it was said that 
it is likely ALSA bug. So it could not be fixed. But how about adding 
some option for dropping whole ALSA module as it is not even needed in 
many cases?

The continuous crashes, when plug / unplug, I reported earlier are now 
gone. Those disappeared when DRX-K asynchronous firmware loading was 
removed. I suspect it was a DRX-K bug.

regards
Antti

-- 
http://palosaari.fi/
