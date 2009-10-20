Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:57890 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbZJTXHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 19:07:19 -0400
Subject: Re: cx18 i2c changes for 2.6.31.x?
From: Andy Walls <awalls@radix.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <9627EF6A-9468-4868-9806-895BBDE736DB@wilsonet.com>
References: <9627EF6A-9468-4868-9806-895BBDE736DB@wilsonet.com>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 19:10:25 -0400
Message-Id: <1256080225.3144.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-10-20 at 10:58 -0400, Jarod Wilson wrote:
> Hey all,
> 
> Over on the lirc list, we've seen multiple reports now of lirc_i2c  
> failing to work with the HVR-1300 and 1600.
> 
> http://www.nabble.com/lirc-i2c-does-no-longer-work-with-Hauppauge-HVR-1300--to25740534.html
> 
> At least for the 1600, it seems that at least these changesets might  
> be candidates for adding to the 2.6.31.x stable queue:
> 
> http://linuxtv.org/hg/v4l-dvb/rev/21b349750a7a
> http://linuxtv.org/hg/v4l-dvb/rev/471784201e1b
> http://linuxtv.org/hg/v4l-dvb/rev/a9dd959a71a5
> 
> Without them, I'm pretty sure ir-kbd-i2c and definitely sure lirc_i2c  
> can't bind.

Yup.

Actually, the last change is a bit of a cop out.  ir-kbd-i2c wants
non-const data, but I didn't want to manage a dynamically allocated
object when const data would do, so I did a cast to make the warning
disappear.  That's not really the right thing to do, but it is OK for
now as ir-kbd-i2c doesn't modify the passed in data.

-Andy

> Haven't looked into driver-specifics on the 1300 yet.


