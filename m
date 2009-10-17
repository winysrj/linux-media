Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37451 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752005AbZJQUYn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Oct 2009 16:24:43 -0400
Date: Sat, 17 Oct 2009 22:24:37 +0200
From: Mario Bachmann <grafgrimm77@gmx.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-media@vger.kernel.org
Subject: Re: 2.6.32 regression: can't tune DVB with firedtv
Message-ID: <20091017222437.0cbbe897@x2.grafnetz>
In-Reply-To: <4ADA149E.1070704@s5r6.in-berlin.de>
References: <4ADA149E.1070704@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sat, 17 Oct 2009 21:01:50 +0200
schrieb Stefan Richter <stefanr@s5r6.in-berlin.de>:

> Hi list,
> 
> I just switched from kernel 2.6.31 to 2.6.32-rc5.  Using kaffeine, I
> can't tune FireDTV-C and FireDTV-T boxes via the firedtv driver
> anymore. Electronic program guide data is still displayed though.
> 
> Under 2.6.31, I used firedtv at the same patchlevel as present in
> 2.6.32-rc5, hence I guess that it is a DVB core problem rather than a
> driver problem.
> 
> Any suggestions where to look for the cause?
> 
> (I am not subscribed to the list.)

Hi there, 

perhaps it is related:
with kernel 2.6.30.8 my "TwinhanDTV USB-Ter USB1.1 / Magic Box I"
worked. 

Now with kernel 2.6.32-rc3 (and 2.6.31.1) the modules seems to be
loaded fine, but tzap/kaffeine/mplayer can not tune to a channel. 

i think the cause must be here:
/usr/src/linux-2.6.32-rc3/drivers/media/dvb/dvb-usb/dibusb-common.c
line 136 to line 146

i changed this hole section to the version of 2.6.30.8 and it works
again.

Mario
