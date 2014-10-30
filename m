Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:32837 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774AbaJ3NUn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 09:20:43 -0400
Received: by mail-qa0-f52.google.com with SMTP id u7so3594795qaz.25
        for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 06:20:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141027170749.12526c12.m.chehab@samsung.com>
References: <BLU437-SMTP74723F476D15D78EEEA959BA900@phx.gbl>
	<20141027094619.69851745.m.chehab@samsung.com>
	<CAOcJUbyK7Y5=fMfEGv5rhC3bPpeiiS3Mp1z+8cVfHoqy-opy5Q@mail.gmail.com>
	<20141027135727.297ba10a.m.chehab@samsung.com>
	<20141027162252.GA9984@linuxtv.org>
	<CAOcJUbxU=uQXCuxiAY95TmwB+pk0xmPYQFBzWvdSAsdjtHnXrA@mail.gmail.com>
	<20141027170749.12526c12.m.chehab@samsung.com>
Date: Thu, 30 Oct 2014 09:20:42 -0400
Message-ID: <CAGoCfiwZwFcHj0y_fMt1tADPaByggx0sy0fQbxM0r1Cy2bfBmw@mail.gmail.com>
Subject: Re: [PATCH 1/3] xc5000: tuner firmware update
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Michael Ira Krufky <mkrufky@linuxtv.org>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>,
	Richard Vollkommer <linux@hauppauge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Well, perhaps you could add a printk message warning the user that
> the driver is not using the latest firmware and performance/quality
> could be badly affected.

I wouldn't use the term "badly affected".  There are tens of thousands
of units out there for which users are quite happy with the current
firmware.  The firmware fixes an edge case that affected a very small
subset of users when receiving signals from a specific QAM modulator
product.  The vast majority of users would be perfectly fine using the
old firmware indefinitely.

That said, I certainly have no objection to a message stating that
there is newer firmware available than what they are currently
running.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
