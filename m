Return-path: <linux-media-owner@vger.kernel.org>
Received: from woodlands.midnighthax.com ([93.89.81.115]:45156 "EHLO
	woodlands.the.cage" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031037Ab2CPIAv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 04:00:51 -0400
Received: from ws.the.cage ([10.0.0.100])
	by woodlands.the.cage with esmtp (Exim 4.72)
	(envelope-from <kae@midnighthax.com>)
	id 1S8S5g-0000qE-KH
	for linux-media@vger.kernel.org; Fri, 16 Mar 2012 08:00:48 +0000
Date: Fri, 16 Mar 2012 08:00:48 +0000
From: Keith Edmunds <kae@midnighthax.com>
To: linux-media@vger.kernel.org
Subject: Re: cxd2820r: i2c wr failed (PCTV Nanostick 290e)
Message-ID: <20120316080048.0655c185@ws.the.cage>
In-Reply-To: <CAGa-wNOb8m9D0nZccqe+nKjEjWx5p7SaXHPJHHrb8z7Ts8YuUA@mail.gmail.com>
References: <CAGa-wNOb8m9D0nZccqe+nKjEjWx5p7SaXHPJHHrb8z7Ts8YuUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the suggestions; I'll investigate further.

One other oddity I noticed: the last time the i2c errors were logged,
rather than immediately rebooting I unplugged the 290e. There is a blue
LED on the 290e, which of course went out when it was unplugged. However,
it didn't come back on when I plugged it back in. I had to reboot to get
it to show again.

Both of my other tuners are USB tuners, so I don't think this is a USB
problem (I have no problems with them). However, I'll try the USB MD5 test
and report back.

Thanks,
Keith
-- 
"You can have everything in life you want if you help enough other people
get what they want" - Zig Ziglar. 

Who did you help today?
