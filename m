Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab0BCA31 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 19:29:27 -0500
Message-ID: <4B68C35F.1080902@redhat.com>
Date: Tue, 02 Feb 2010 22:29:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Any saa711x users out there?
References: <829197381002021451g5aaa8013kd5ae2124534ba5ba@mail.gmail.com>
In-Reply-To: <829197381002021451g5aaa8013kd5ae2124534ba5ba@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> Hello all,
> 
> I am doing some quality improvements for a couple of the
> em28xx/saa7113 designs, and I found a pretty serious problem which
> appears to have been there for some time.
> 
> In fact, the regression was introduced when the saa7115 support was
> added in 2005 (hg revision 2750).  This change resulted in the
> anti-alias filtering being disabled by default for the saa7113 (the
> saa7115_init_misc block clears bit 7 of register 0x02).  Without this
> change, vertical lines appear in the chroma on a fixed interval.
> 
> The big issue is that the driver is shared with other saa7113
> products, as well as products that have the saa7111, saa7114, and
> saa7115.  So I have to figure out whether to just force on the AA
> filter for the saa7113, or whether it should be enabled for the
> others, or whether I can even turn it on for saa7113 in general or
> need to hack something in there to only do it for the two or three
> products I am testing with.
> 
> So here's where I could use some help:  If you have a product that
> uses one of the above chips, please speak up.  I will be setting up a
> test tree where people can try out the change and see if it makes
> their situation better, worse, or no change.

The better is to allow enabling/disabling the anti-alias via ctrl.
Whatever default is chosen, the driver may adjust the control default
at the board initialization, or even blocking the control when the
other mode of operation is broken.

I have here a few devices with saa7113 and saa7114. I think I have
also one device with saa7111, but I need to check. If I'm right, it will
take some time for me to prepare the saa7111 environment. The saa7113/7114
devices are easier to setup, as they are usb.

-- 

Cheers,
Mauro
