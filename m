Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49140 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab0HQSLZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Aug 2010 14:11:25 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: [2.6.35] usb 2.0 em28xx  kernel panic general protection fault: 0000 [#1] SMP          RIP: 0010:[<ffffffffa004fbc5>]  [<ffffffffa004fbc5>] em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
Date: Tue, 17 Aug 2010 20:11:19 +0200
Cc: mchehab@infradead.org, mrechberger@gmail.com, gregkh@suse.de,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <61936849.20100811001257@eikelenboom.it>
In-Reply-To: <61936849.20100811001257@eikelenboom.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008172011.20095.maciej.rutecki@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

https://bugzilla.kernel.org/show_bug.cgi?id=16614On środa, 11 sierpnia 2010 o 
00:12:57 Sander Eikelenboom wrote:
> Hi,
> 
> While trying to test try and report about some other bugs,  i ran into this
> kernel panic when trying to grab video from my usb 2.0 em28xx videgrabber
> connected to a usb 2.0 port. Complete serial log attachted.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16614
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
