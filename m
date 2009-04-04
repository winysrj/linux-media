Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:42810 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZDDQFJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 12:05:09 -0400
Date: Sat, 4 Apr 2009 11:05:05 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Andy Walls <awalls@radix.net>
cc: Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
In-Reply-To: <1238852529.2845.34.camel@morgan.walls.org>
Message-ID: <Pine.LNX.4.64.0904041059080.32720@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
 <20090404142837.3e12824c@hyperion.delvare> <1238852529.2845.34.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 4 Apr 2009, Andy Walls wrote:

   [...]

> 
> I have an I2C related question.  If the cx18 or ivtv driver autoloads
> "ir-kbd-i2c" and registers an I2C client on the bus, does that preclude
> lirc_i2c, lirc_pvr150 or lirc_zilog from using the device?  LIRC users
> may notice, if it does.
> 
> If that is the case, then we probably shouldn't autoload the ir-kbd
> module after the CX23418 i2c adapters are initialized.  
> 
> I'm not sure what's the best solution:
> 
> 1. A module option to the cx18 driver to tell it to call
> init_cx18_i2c_ir() from cx18_probe() or not? (Easiest solution)
> 
> 2. Some involved programmatic way for IR device modules to query bridge
> drivers about what IR devices they may have, and on which I2C bus, and
> at what addresses to probe, and whether a driver/module has already
> claimed that device? (Gold plated solution)
> 
> Regards,
> Andy

Ah, glad to see I'm not the only one concerned about this.

I suppose I could instead add a module option to the pvrusb2 driver to 
control autoloading of ir-kbd (option 1).  It also should probably be a 
per-device attribute, since AFAIK, ir-kbd only even works when using 
older Hauppauge IR receivers (i.e. lirc_i2c - cases that would otherwise 
use lirc_pvr150 or lirc_zilog I believe do not work with ir-kbd).  Some 
devices handled by the pvrusb2 driver are not from Hauppauge.  Too bad 
if this is the case, it was easier to let the user decide just by 
choosing which actual module to load.

  -Mike

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
