Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9GMrw5n022893
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 18:53:58 -0400
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9GMrEDt006388
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 18:53:15 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
In-Reply-To: <200810161510.48208.vanessaezekowitz@gmail.com>
References: <48CD6F11.8020900@xnet.com>
	<1224140231.3577.5.camel@pc10.localdom.local>
	<48F753FC.4030901@xnet.com>
	<200810161510.48208.vanessaezekowitz@gmail.com>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 00:45:42 +0200
Message-Id: <1224197142.4124.73.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: KWorld 120 IR control?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Am Donnerstag, den 16.10.2008, 15:10 -0500 schrieb Vanessa Ezekowitz:
> On Thursday 16 October 2008 9:47:24 am stuart wrote:
> > 
> > [off list - as this doesn't add much additional info]
> > 
> > >> I looked and found an 8 and 16 pin SMD IC on my kworld 120.  The 16 pin 
> > >> device turned out to be a multi-bit A/D converter, not an I2C 
> > >> controller.  After reading the above again I believe I understand what 
> > >> 20 pin device you are talking about.  Just right of the composite video 
> > >> input past the Xtl in this photo:
> > >> http://c1.neweggimages.com/NeweggImage/productimage/15-260-007-15.jpg
> > >> ...I'll have to take another look.
> > 
> > Interesting, I can not read any writing on that chip.  All I see is a 
> > green dot probably identifying pin 1.  If this is a common i2c 
> > controller - why bother? Or are the KS003 and KS007 custom chips?
> > 
> > > Does any unknown device show up with cx88xx i2c_scan=1?
> 
> If by this you mean to add an appropriate line to /etc/modprobe.d/options...  Here's what I got in dmesg when I did this (after a clean reboot with no cx88-related modules loaded):
> 
> cx88[0]: i2c scan: found device @ 0x32  [???]
> cx88[0]: i2c scan: found device @ 0x34  [???]
> cx88[0]: i2c scan: found device @ 0x66  [???]
> cx88[0]: i2c scan: found device @ 0xa0  [eeprom]
> cx88[0]: i2c scan: found device @ 0xc2  [tuner (analog/dvb)]
> 
> If you need more from the dmesg output, let me know.

Yes, that is what should be examined.

Can't say anything offhand, since I don't have the card and there are
also lots of devices using the same subset of i2c addresses.

These are addresses in read mode. In write mode they change binary >> 1
and in hex /2. Means 0x34 becomes 0x1a.

I don't believe it is related, but in ir-kbd-i2c there is an old
Hauppauge bttv device at 0x1a, but might be the demod or whatever here.

Cheers,
Hermann

BTW, there is an i2c_debug option I guess




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
