Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9GKB4Ms012404
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 16:11:04 -0400
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9GKAp3p027060
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 16:10:52 -0400
Received: by wa-out-1112.google.com with SMTP id j4so136456wah.19
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 13:10:51 -0700 (PDT)
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: stuart <stuart@xnet.com>, video4linux-list@redhat.com
Date: Thu, 16 Oct 2008 15:10:48 -0500
References: <48CD6F11.8020900@xnet.com>
	<1224140231.3577.5.camel@pc10.localdom.local>
	<48F753FC.4030901@xnet.com>
In-Reply-To: <48F753FC.4030901@xnet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810161510.48208.vanessaezekowitz@gmail.com>
Cc: 
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

On Thursday 16 October 2008 9:47:24 am stuart wrote:
> 
> [off list - as this doesn't add much additional info]
> 
> >> I looked and found an 8 and 16 pin SMD IC on my kworld 120.  The 16 pin 
> >> device turned out to be a multi-bit A/D converter, not an I2C 
> >> controller.  After reading the above again I believe I understand what 
> >> 20 pin device you are talking about.  Just right of the composite video 
> >> input past the Xtl in this photo:
> >> http://c1.neweggimages.com/NeweggImage/productimage/15-260-007-15.jpg
> >> ...I'll have to take another look.
> 
> Interesting, I can not read any writing on that chip.  All I see is a 
> green dot probably identifying pin 1.  If this is a common i2c 
> controller - why bother? Or are the KS003 and KS007 custom chips?
> 
> > Does any unknown device show up with cx88xx i2c_scan=1?

If by this you mean to add an appropriate line to /etc/modprobe.d/options...  Here's what I got in dmesg when I did this (after a clean reboot with no cx88-related modules loaded):

cx88[0]: i2c scan: found device @ 0x32  [???]
cx88[0]: i2c scan: found device @ 0x34  [???]
cx88[0]: i2c scan: found device @ 0x66  [???]
cx88[0]: i2c scan: found device @ 0xa0  [eeprom]
cx88[0]: i2c scan: found device @ 0xc2  [tuner (analog/dvb)]

If you need more from the dmesg output, let me know.

-- 
"Life is full of positive and negative events.  Spend
your time considering the former, not the latter."
Vanessa Ezekowitz <vanessaezekowitz@gmail.com>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
