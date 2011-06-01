Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:48723 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161825Ab1FAIix (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 04:38:53 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QRgx1-00031r-De
	for linux-media@vger.kernel.org; Wed, 01 Jun 2011 10:38:51 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 01 Jun 2011 10:38:51 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 01 Jun 2011 10:38:51 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Writing descriptive commit messages (was Re: PCTV nanoStick T2 290e support - Thank you!)
Date: Wed, 01 Jun 2011 10:38:38 +0200
Message-ID: <8762oqndyp.fsf_-_@nemi.mork.no>
References: <1306445141.14462.0.camel@porites> <4DDEDB0E.30108@iki.fi>
	<8739k0tlx6.fsf@nemi.mork.no>
	<ac07f3b673133d44f388843769c5f233@chewa.net>
	<87y61ss6bt.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Bjørn Mork <bjorn@mork.no> writes:
> Rémi Denis-Courmont <remi@remlab.net> writes:
>> On Fri, 27 May 2011 13:36:37 +0200, Bjørn Mork <bjorn@mork.no> wrote:
>>
>>> I'm a bit curious about this device.  It seems to only be marketed as a
>>> DVB-T2 device in areas where that spec is used.  But looking at your
>>> driver, it seems that the device also supports DVB-C.  Is that correct?
>> 
>> At least, DVB-C worked for me.
>
> Thanks.  Then I've ordered one of these :-)

Received and tested.

Being quite conservative wrt kernel updates, I did a quick-n-dirty
backport of the PCTV nanoStick T2 290e support to 2.6.32. I chose to
keep it as simple as possible, by ignoring as much as possible of the
unrelated changes to the em28xx driver since 2.6.32.  This was quite
educational.  

One surprising issue that others might want to be aware of, was that

commit ca3dfd6a6f8364c1d51e548adb4564702f1141e9
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Fri Sep 10 17:29:14 2010 -0300

    [media] em28xx: Add support for Leadership ISDB-T
    
    This device uses an em2874B + Sharp 921 One Seg frontend.
    
    Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


actually has important side effects making it a *requirement* for 290e
support (and possibly other cards added after that commit).  The commit
message is completely misleading.  These changes to
drivers/media/video/em28xx/em28xx-cards.c are in no way described by it,
and do affect much more than the "Leadership ISDB-T" card:


@@ -2430,8 +2460,36 @@ void em28xx_card_setup(struct em28xx *dev)
                        dev->board.is_webcam = 0;
                else
                        dev->progressive = 1;
-       } else
-               em28xx_set_model(dev);
+       }
+
+       if (!dev->board.is_webcam) {
+               switch (dev->model) {
+               case EM2820_BOARD_UNKNOWN:
+               case EM2800_BOARD_UNKNOWN:
+               /*
+                * The K-WORLD DVB-T 310U is detected as an MSI Digivox AD.
+                *
+                * This occurs because they share identical USB vendor and
+                * product IDs.
+                *
+                * What we do here is look up the EEPROM hash of the K-WORLD
+                * and if it is found then we decide that we do not have
+                * a DIGIVOX and reset the device to the K-WORLD instead.
+                *
+                * This solution is only valid if they do not share eeprom
+                * hash identities which has not been determined as yet.
+                */
+               if (em28xx_hint_board(dev) < 0)
+                       em28xx_errdev("Board not discovered\n");
+               else {
+                       em28xx_set_model(dev);
+                       em28xx_pre_card_setup(dev);
+               }
+               break;
+               default:
+                       em28xx_set_model(dev);
+               }
+       }
 
        em28xx_info("Identified as %s (card=%d)\n",
                    dev->board.name, dev->model);
@@ -2749,8 +2807,8 @@ static int em28xx_init_dev(struct em28xx **devhandle, struct usb_device *udev,
        em28xx_pre_card_setup(dev);
 
        if (!dev->board.is_em2800) {
-               /* Sets I2C speed to 100 KHz */
-               retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
+               /* Resets I2C speed */
+               em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
                if (retval < 0) {
                        em28xx_errdev("%s: em28xx_write_regs_req failed!"
                                      " retval [%d]\n",




Could we please not do things like that?  That part should have been a
separate commit with a descriptive commit message.

Thanks.  




Bjørn

