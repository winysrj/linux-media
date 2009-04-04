Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:55731 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZDDP6d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 11:58:33 -0400
Date: Sat, 4 Apr 2009 10:58:30 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>, Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/6] ir-kbd-i2c conversion to the new i2c binding model
In-Reply-To: <20090404142427.6e81f316@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904041055440.32720@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Jean:

I understand what you're trying to do but how is LIRC expected to still 
work if all drivers now force the user over to ir-kbd?

  -Mike


On Sat, 4 Apr 2009, Jean Delvare wrote:

> Hi all,
> 
> Here finally comes my conversion of ir-kbd-i2c to the new i2c binding
> model. I've split it into 6 pieces for easier review. Firstly there are
> 2 preliminary patches:
> 
> media-video-01-cx18-fix-i2c-error-handling.patch
> media-video-02-ir-kbd-i2c-dont-abuse-client-name.patch
> 
> Then 2 patches doing the actual conversion:
> 
> media-video-03-ir-kbd-i2c-convert-to-new-style.patch
> media-video-04-configure-ir-receiver.patch
> 
> And lastly 2 patches cleaning up saa7134-input thanks to the new
> possibilities offered by the conversion:
> 
> media-video-05-saa7134-input-cleanup-msi-ir.patch
> media-video-06-saa7134-input-cleanup-avermedia-cardbus.patch
> 
> This patch set is against the v4l-dvb repository, but I didn't pay
> attention to the compatibility issues. I simply build-tested it on
> 2.6.27 and 2.6.29.
> 
> This patch set touches many different drivers and I can't test any of
> them. My only TV card with an IR receiver doesn't make use of
> ir-kbd-i2c. So I would warmly welcome testers. The more testing my
> changes can get, the better.
> 
> And of course I welcome reviews and comments as well. I had to touch
> many drivers I don't know anything about so it is possible that I
> missed something.
> 
> I'll post all 6 patches as replies to this post. They can also be
> temporarily downloaded from:
>   http://jdelvare.pck.nerim.net/linux/ir-kbd-i2c/
> Additionally I've put a combined patch there, to make testing easier:
>   http://jdelvare.pck.nerim.net/linux/ir-kbd-i2c/ir-kbd-i2c-conversion-ALL-IN-ONE.patch
> But for review the individual patches are much better.
> 
> Thanks,
> 

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
