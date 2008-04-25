Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3PLoKV8012905
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 17:50:20 -0400
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3PLo5m9028433
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 17:50:05 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: mkrufky@linuxtv.org
In-Reply-To: <4811F391.1070207@linuxtv.org>
References: <4811F391.1070207@linuxtv.org>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 23:48:49 +0200
Message-Id: <1209160129.21096.11.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org, gert.vervoort@hccnet.nl,
	mchehab@infradead.org
Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
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

Hi,

Am Freitag, den 25.04.2008, 11:06 -0400 schrieb mkrufky@linuxtv.org:
> Mauro Carvalho Chehab wrote:
> > On Fri, 25 Apr 2008 10:40:14 -0400
> > "Michael Krufky" <mkrufky@linuxtv.org> wrote:
> >
> >   
> >> On Fri, Apr 25, 2008 at 9:56 AM, Mauro Carvalho Chehab
> >> <mchehab@infradead.org> wrote:
> >>     
> >>> On Thu, 24 Apr 2008 05:55:28 +0200
> >>>  hermann pitton <hermann-pitton@arcor.de> wrote:
> >>>
> >>>  > > > >>>> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the
> drivers
> >>>  > > > >>>> for   the Hauppauge WinTV appear to have suffered some
> regression
> >>>  > > > >>>> between the two kernel versions.
> >>>
> >>>
> >>>       
> >>>> do you see the auto detection issue?
> >>>>         
> >>>  >
> >>>  > Either tell it is just nothing, what I very seriously doubt, or
> please
> >>>  > comment.
> >>>  >
> >>>  > I don't like to end up on LKML again getting told that written rules
> >>>  > don't exist ;)
> >>>
> >>>  Sorry for now answer earlier. Too busy here, due to the merge window.
> >>>
> >>>  This seems to be an old bug. On several cases, tuner_type information
> came from
> >>>  some sort of autodetection schema, but the proper setup is not sent to
> tuner.
> >>>
> >>>  Please test the enclosed patch. It warrants that TUNER_SET_TYPE_ADDR is
> called
> >>>  at saa7134_board_init2() for all those boards:
> >>>
> >>>  SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331
> >>>  SAA7134_BOARD_ASUS_EUROPA2_HYBRID
> >>>  SAA7134_BOARD_ASUSTeK_P7131_DUAL
> >>>  SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA
> >>>  SAA7134_BOARD_AVERMEDIA_SUPER_007
> >>>  SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM
> >>>  SAA7134_BOARD_BMK_MPEX_NOTUNER
> >>>  SAA7134_BOARD_BMK_MPEX_TUNER
> >>>  SAA7134_BOARD_CINERGY_HT_PCI
> >>>  SAA7134_BOARD_CINERGY_HT_PCMCIA
> >>>  SAA7134_BOARD_CREATIX_CTX953
> >>>  SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
> >>>  SAA7134_BOARD_FLYDVB_TRIO
> >>>  SAA7134_BOARD_HAUPPAUGE_HVR1110
> >>>  SAA7134_BOARD_KWORLD_ATSC110
> >>>  SAA7134_BOARD_KWORLD_DVBT_210
> >>>  SAA7134_BOARD_MD7134
> >>>  SAA7134_BOARD_MEDION_MD8800_QUADRO
> >>>  SAA7134_BOARD_PHILIPS_EUROPA
> >>>  SAA7134_BOARD_PHILIPS_TIGER
> >>>  SAA7134_BOARD_PHILIPS_TIGER_S
> >>>  SAA7134_BOARD_PINNACLE_PCTV_310i
> >>>  SAA7134_BOARD_TEVION_DVBT_220RF
> >>>  SAA7134_BOARD_TWINHAN_DTV_DVB_3056
> >>>  SAA7134_BOARD_VIDEOMATE_DVBT_200
> >>>  SAA7134_BOARD_VIDEOMATE_DVBT_200A
> >>>  SAA7134_BOARD_VIDEOMATE_DVBT_300
> >>>
> >>>  It is important to test the above boards, to be sure that no regression
> is
> >>>  caused.
> >>>
> >>>  Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> >>>
> >>>  diff -r 60110897e86a linux/drivers/media/video/saa7134/saa7134-cards.c
> >>>  --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Fri Apr 25
> 08:04:54 2008 -0300
> >>>  +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Fri Apr 25
> 10:44:16 2008 -0300
> >>>       
> >> Mauro,
> >>
> >> I didn't review your patch yet, and it needs to be tested, however,
> >> the bug reported in this thread deals with the same regression that
> >> you are attempting to repair, but on the cx88 driver -- not the
> >> saa7134 driver.
> >>     
> >
> > Hmm... it seems that people merged two similar issues together, on
> different
> > drivers. At least, part of the reports at the thread were with saa7134
> driver.
> >
> > I'll investigate if this solution will also work for cx88.
> 
> Mauro,
> 
> "...people merged two similar issues together, on different drivers..."  
> It was you -- did you forget?
> 
> cx88: http://linuxtv.org/hg/v4l-dvb/rev/2eb392c86745
> 
> saa7134: http://linuxtv.org/hg/v4l-dvb/rev/e7668fc3666c
> 
> I'm surprised that you don't remember this -- you pushed this to Linus 
> late in the 2.6.25-rcX, after I had strongly advised against this -- I 
> warned you that this may create regressions, needed thorough testing, 
> and was too risky a change to push into the middle of 2.6.25-rc
> 
> I hate to say, "I told you so" .... but.............
> 
> ;-)
> 
> Lets get your fixes tested ASAP so we can fix 2.6.25-stable.
> 
> Regards,
> 
> Mike

I started already yesterday evening to test if the tuner eeprom
detection will come back for one of the md7134 cards on saa7134 by
reverting the above changeset.

To my surprise not. Only reloading the tuner stuff detects the right
tuner.

Since it became too late then, I have now repeated it on a 2.6.25 and
get the same. Can't say when it started, since no free slots for such
cards during the last months.

Will try with Mauro's saa7134-cards.c patch later.

Cheers,
Hermann

Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: setting pci latency timer to 64
saa7133[0]: found at 0000:01:07.0, rev: 208, irq: 19, latency: 64, mmio: 0xe8000000
saa7133[0]: subsystem: 1043:4857, board: Philips Tiger reference design [card=81,insmod option]
saa7133[0]: board init: gpio is 200000
saa7133[0]: i2c eeprom 00: 43 10 57 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 01 20 00 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 cb ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 00 ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner' 2-004b: chip found @ 0x96 (saa7133[0])
tda829x 2-004b: setting tuner address to 61
tda829x 2-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7133[1]: setting pci latency timer to 64
saa7133[1]: found at 0000:01:08.0, rev: 208, irq: 18, latency: 64, mmio: 0xe8001000
saa7133[1]: subsystem: 1043:4862, board: ASUSTeK P7131 Dual [card=78,autodetected]
saa7133[1]: board init: gpio is 0
input: saa7134 IR (ASUSTeK P7131 Dual) as /class/input/input11
tuner' 3-004b: chip found @ 0x96 (saa7133[1])
tda829x 3-004b: setting tuner address to 61
tda829x 3-004b: type set to tda8290+75a
saa7133[1]: i2c eeprom 00: 43 10 62 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[1]: i2c eeprom 10: 00 01 20 00 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d6 ff ff ff ff
saa7133[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 00 ff ff ff ff ff ff
saa7133[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: registered device video1 [v4l2]
saa7133[1]: registered device vbi1
saa7133[1]: registered device radio1
saa7133[2]: setting pci latency timer to 64
saa7133[2]: found at 0000:01:09.0, rev: 209, irq: 17, latency: 64, mmio: 0xe8002000
saa7133[2]: subsystem: 16be:0010, board: Medion/Creatix CTX953 Hybrid [card=134,autodetected]
saa7133[2]: board init: gpio is 0
tuner' 4-004b: chip found @ 0x96 (saa7133[2])
tda829x 4-004b: setting tuner address to 60
tda829x 4-004b: type set to tda8290+75a
saa7133[2]: i2c eeprom 00: be 16 10 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[2]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7133[2]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 2c 02 51 96 2b
saa7133[2]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7133[2]: i2c eeprom 40: ff 21 00 c0 96 10 03 22 15 00 fd 79 44 9f c2 8f
saa7133[2]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: registered device video2 [v4l2]
saa7133[2]: registered device vbi2
saa7134[3]: setting pci latency timer to 64
saa7134[3]: found at 0000:01:0a.0, rev: 1, irq: 16, latency: 64, mmio: 0xe8003000
saa7134[3]: subsystem: 16be:0003, board: Medion 7134 [card=12,autodetected]
saa7134[3]: board init: gpio is 0
tuner' 5-0043: chip found @ 0x86 (saa7134[3])
tda9887 5-0043: creating new instance
tda9887 5-0043: tda988[5/6/7] found
All bytes are equal. It is not a TEA5767
tuner' 5-0060: chip found @ 0xc0 (saa7134[3])
tuner-simple 5-0060: creating new instance
tuner-simple 5-0060: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7134[3]: i2c eeprom 00: be 16 03 00 08 20 1c 55 43 43 a9 1c 55 43 43 a9
saa7134[3]: i2c eeprom 10: ff ff ff ff 15 00 0e 01 0c c0 08 00 00 00 00 00
saa7134[3]: i2c eeprom 20: 00 00 00 e3 ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3] Tuner type is 38
saa7134[3]: registered device video3 [v4l2]
saa7134[3]: registered device vbi3
saa7134[3]: registered device radio2
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
DVB: registering new adapter (saa7133[1])
DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
DVB: registering new adapter (saa7133[2])
DVB: registering frontend 2 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 26 -- ok
saa7134[3]/dvb: frontend initialization failed
tda9887 5-0043: destroying instance
tuner-simple 5-0060: destroying instance
tuner' 2-004b: chip found @ 0x96 (saa7133[0])
tda829x 2-004b: setting tuner address to 61
tda829x 2-004b: type set to tda8290+75a
tuner' 3-004b: chip found @ 0x96 (saa7133[1])
tda829x 3-004b: setting tuner address to 61
tda829x 3-004b: type set to tda8290+75a
tuner' 4-004b: chip found @ 0x96 (saa7133[2])
tda829x 4-004b: setting tuner address to 60
tda829x 4-004b: type set to tda8290+75a
tuner' 5-0043: chip found @ 0x86 (saa7134[3])
tda9887 5-0043: creating new instance
tda9887 5-0043: tda988[5/6/7] found
All bytes are equal. It is not a TEA5767
tuner' 5-0060: chip found @ 0xc0 (saa7134[3])
tuner-simple 5-0060: creating new instance
tuner-simple 5-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
[root@pc10 v4l-dvb-init2-reverted]# hg diff
diff -r 5c9a4decb57b linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c  Fri Apr 25 11:02:29 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c  Fri Apr 25 23:17:54 2008 +0200
@@ -1089,13 +1089,12 @@ static int __devinit saa7134_initdev(str
        saa7134_i2c_register(dev);

        /* initialize hardware #2 */
-       if (TUNER_ABSENT != dev->tuner_type)
-               request_module("tuner");
        saa7134_board_init2(dev);
-
        saa7134_hwinit2(dev);

        /* load i2c helpers */
+       if (TUNER_ABSENT != dev->tuner_type)
+               request_module("tuner");
        if (card_is_empress(dev)) {
                request_module("saa6752hs");
        }




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
