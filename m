Return-path: <linux-media-owner@vger.kernel.org>
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:49287 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbZDNDf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 23:35:57 -0400
Message-ID: <49E404AC.4090303@andrew.cmu.edu>
Date: Mon, 13 Apr 2009 23:36:12 -0400
From: Josh Watzman <jwatzman@andrew.cmu.edu>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: BUG when unplugging EyeTV
References: <49E3E534.1030402@andrew.cmu.edu> <412bdbff0904131935m4e152db0n18c0cea53ed42b39@mail.gmail.com>
In-Reply-To: <412bdbff0904131935m4e152db0n18c0cea53ed42b39@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hello Josh,
> 
> Thanks for the bug report.  Robert Krakora reported the same stack
> trace to me off-list over the weekend.  I've been tied up with some
> family business, but I intend to dig into it deeper this weekend.

No problem, take your time. I was quite pleased when the DVB worked on
the stock kernel and even more pleased when the analog worked with the
current hg tree. Thank you all for your work on these drivers.

> I didn't know that Elgato had a 950q clone (I did work on the original
> Elgato EyeTV device for Linux).  Could you please send me the output
> of "lsusb -v" so I can confirm precisely which device it is a clone
> of?

I'm not 100% sure it's a clone of that card, but everything seems to
match. The instructions for the 950q firmware on the wiki are what
originally allowed me to get it working.

The lsusb is quite long -- you can get it at
http://www.contrib.andrew.cmu.edu/~jwatzman/eyetv/lsusb and I've also
uploaded a screenshot of what the OS X software says the device is at
http://www.contrib.andrew.cmu.edu/~jwatzman/eyetv/eyetv.png if that
helps too.

Josh Watzman
