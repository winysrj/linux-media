Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:33760 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbZDQXf6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 19:35:58 -0400
Date: Fri, 17 Apr 2009 18:35:55 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/6] ir-kbd-i2c: Switch to the new-style device binding
 model
In-Reply-To: <20090417223105.28b8957e@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904171831300.19718@cnc.isely.net>
References: <20090417222927.7a966350@hyperion.delvare>
 <20090417223105.28b8957e@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I thought we were going to leave the pvrusb2 driver out of this since 
I've already got a change ready that also includes additional logic to 
take into account the properties of the hardware device (i.e. only 
activate ir-kbd-i2c when we know it has a chance of working).

  -Mike


On Fri, 17 Apr 2009, Jean Delvare wrote:

> Let card drivers probe for IR receiver devices and instantiate them if
> found. Ultimately it would be better if we could stop probing
> completely, but I suspect this won't be possible for all card types.
> 
> There's certainly room for cleanups. For example, some drivers are
> sharing I2C adapter IDs, so they also had to share the list of I2C
> addresses being probed for an IR receiver. Now that each driver
> explicitly says which addresses should be probed, maybe some addresses
> can be dropped from some drivers.
> 
> Also, the special cases in saa7134-i2c should probably be handled on a
> per-board basis. This would be more efficient and less risky than always
> probing extra addresses on all boards. I'll give it a try later.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Andy Walls <awalls@radix.net>
> Cc: Mike Isely <isely@pobox.com>
> ---
>  linux/drivers/media/video/bt8xx/bttv-i2c.c           |   21 +
>  linux/drivers/media/video/cx231xx/cx231xx-cards.c    |   11 
>  linux/drivers/media/video/cx231xx/cx231xx-i2c.c      |    3 
>  linux/drivers/media/video/cx231xx/cx231xx.h          |    1 
>  linux/drivers/media/video/cx23885/cx23885-i2c.c      |   12 +
>  linux/drivers/media/video/cx88/cx88-i2c.c            |   13 +
>  linux/drivers/media/video/em28xx/em28xx-cards.c      |   20 +
>  linux/drivers/media/video/em28xx/em28xx-i2c.c        |    3 
>  linux/drivers/media/video/em28xx/em28xx-input.c      |    6 
>  linux/drivers/media/video/em28xx/em28xx.h            |    1 
>  linux/drivers/media/video/ir-kbd-i2c.c               |  200 +++---------------
>  linux/drivers/media/video/ivtv/ivtv-i2c.c            |   31 ++
>  linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |   24 ++
>  linux/drivers/media/video/saa7134/saa7134-i2c.c      |    3 
>  linux/drivers/media/video/saa7134/saa7134-input.c    |   86 ++++++-
>  linux/drivers/media/video/saa7134/saa7134.h          |    1 
>  linux/include/media/ir-kbd-i2c.h                     |    2 
>  17 files changed, 244 insertions(+), 194 deletions(-)

   [...]

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
