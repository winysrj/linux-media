Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62966 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab0BBWvp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 17:51:45 -0500
Received: by bwz19 with SMTP id 19so573971bwz.28
        for <linux-media@vger.kernel.org>; Tue, 02 Feb 2010 14:51:43 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 2 Feb 2010 17:51:42 -0500
Message-ID: <829197381002021451g5aaa8013kd5ae2124534ba5ba@mail.gmail.com>
Subject: Any saa711x users out there?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I am doing some quality improvements for a couple of the
em28xx/saa7113 designs, and I found a pretty serious problem which
appears to have been there for some time.

In fact, the regression was introduced when the saa7115 support was
added in 2005 (hg revision 2750).  This change resulted in the
anti-alias filtering being disabled by default for the saa7113 (the
saa7115_init_misc block clears bit 7 of register 0x02).  Without this
change, vertical lines appear in the chroma on a fixed interval.

The big issue is that the driver is shared with other saa7113
products, as well as products that have the saa7111, saa7114, and
saa7115.  So I have to figure out whether to just force on the AA
filter for the saa7113, or whether it should be enabled for the
others, or whether I can even turn it on for saa7113 in general or
need to hack something in there to only do it for the two or three
products I am testing with.

So here's where I could use some help:  If you have a product that
uses one of the above chips, please speak up.  I will be setting up a
test tree where people can try out the change and see if it makes
their situation better, worse, or no change.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
