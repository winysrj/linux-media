Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:57044 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab0CJJAX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Mar 2010 04:00:23 -0500
Date: Wed, 10 Mar 2010 10:00:19 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dmitri Belimov <dimon@openhardware.ru>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	"Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: [IR RC, REGRESSION] Didn't work IR RC
Message-ID: <20100310100019.731c7b19@hyperion.delvare>
In-Reply-To: <20100310130225.75d2bca4@glory.loctelecom.ru>
References: <20100301153645.5d529766@glory.loctelecom.ru>
	<1267442919.3110.20.camel@palomino.walls.org>
	<4B8BC332.6060303@infradead.org>
	<1267503595.3269.21.camel@pc07.localdom.local>
	<20100302134320.748ac292@glory.loctelecom.ru>
	<20100302163634.31c934e4@glory.loctelecom.ru>
	<4B8CD10D.2010009@infradead.org>
	<20100309115748.5ec7fd7a@hyperion.delvare>
	<20100310130225.75d2bca4@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Mar 2010 13:02:25 +0900, Dmitri Belimov wrote:
> > Sorry for the late reply. Is the problem solved by now, or is my help
> > still needed?
> 
> Yes. I found what happens and solve this regression. Patch already comitted.
> 
> diff -r 37ff78330942 linux/drivers/media/video/saa7134/saa7134-input.c
> --- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Feb 28 16:59:57 2010 -0300
> +++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Thu Mar 04 08:35:15 2010 +0900
> @@ -947,6 +947,7 @@
>  		dev->init_data.name = "BeholdTV";
>  		dev->init_data.get_key = get_key_beholdm6xx;
>  		dev->init_data.ir_codes = &ir_codes_behold_table;
> +		dev->init_data.type = IR_TYPE_NEC;
>  		info.addr = 0x2d;
>  #endif
>  		break;
> 

None of my patches removed this statement, and IR_TYPE_NEC itself seems
to be new in kernel 2.6.33, so I admit I don't quite understand how I
my i2c changes could be responsible for the regression.

Anyway, glad that you managed to fix it.

-- 
Jean Delvare
