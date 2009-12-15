Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49668 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbZLOT7K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 14:59:10 -0500
Date: Tue, 15 Dec 2009 20:58:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Jon Smirl <jonsmirl@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
Message-ID: <20091215195859.GI24406@elf.ucw.cz>
References: <1260070593.3236.6.camel@pc07.localdom.local>
 <20091206065512.GA14651@core.coreip.homeip.net>
 <4B1B99A5.2080903@redhat.com>
 <m3638k6lju.fsf@intrepid.localdomain>
 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
 <m3skbn6dv1.fsf@intrepid.localdomain>
 <20091207184153.GD998@core.coreip.homeip.net>
 <4B24DABA.9040007@redhat.com>
 <20091215115011.GB1385@ucw.cz>
 <4B279017.3080303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B279017.3080303@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> 	(11) if none is against renaming IR as RC, I'll do it on a next patch;

Call it irc -- infrared remote control. Bluetooth remote controls will
have very different characteristics.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
