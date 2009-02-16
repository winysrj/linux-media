Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:41637 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbZBPCHk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 21:07:40 -0500
Received: by rv-out-0506.google.com with SMTP id g37so1357324rvb.1
        for <linux-media@vger.kernel.org>; Sun, 15 Feb 2009 18:07:40 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 16 Feb 2009 11:07:39 +0900
Message-ID: <5e9665e10902151807m69ef02a1gf261b0af83fde9bd@mail.gmail.com>
Subject: Some issues while using v4l2 int device
From: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
To: "Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: =?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari.

Since I was working on my target board with OMAP3 camera interface, It
seems to take a little much time for boot up.

I found that it was about v4l2 int device register routine. (while
probing camera interface)

It turns on int devices and checks their version information through
I2C command.

It usually seems to be proper, but in some cases it should be an
overhead in booting time.

Let me give an example.

Lately I was working on CE131 ISP from NEC.

The ARM processor inside of this ISP needs booting time itself at
least 600ms (depending on firmware version I guess..not fancy at all
:( )

So if we check firmware version or something while v4l2 int device
registering, it should take "at least" 600ms to attach this device as
an int device.

I'm trying to figure out what else could alter version checking for
int device detection, but unfortunately nothing pops up yet :(

Of course I can make it not to check version information for CE131 and
just return true while v4l2 int device registering, but doesn't seem
to be a neat way.

How about taking the similar way with i2c_board_info ?

Please let me know your opinion.

Cheers,

Nate

-- 
========================================================
DongSoo(Nathaniel), Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
