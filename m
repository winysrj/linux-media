Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3PEehgZ022026
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 10:40:43 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3PEeY8k008578
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 10:40:34 -0400
Received: by yw-out-2324.google.com with SMTP id 2so463234ywt.81
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 07:40:14 -0700 (PDT)
Message-ID: <37219a840804250740k6b1bb64er633cff7a4e377798@mail.gmail.com>
Date: Fri, 25 Apr 2008 10:40:14 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20080425105618.08c5c471@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <480A5CC3.6030408@pickworth.me.uk> <480B26FC.50204@hccnet.nl>
	<480B3673.3040707@pickworth.me.uk>
	<1208696771.3349.49.camel@pc10.localdom.local>
	<480B6CD8.7040702@hccnet.nl>
	<1208726202.5682.44.camel@pc10.localdom.local>
	<1209009328.3402.9.camel@pc10.localdom.local>
	<20080425105618.08c5c471@gaivota>
Cc: video4linux-list@redhat.com, DVB ML <linux-dvb@linuxtv.org>,
	Gert Vervoort <gert.vervoort@hccnet.nl>
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

On Fri, Apr 25, 2008 at 9:56 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Thu, 24 Apr 2008 05:55:28 +0200
>  hermann pitton <hermann-pitton@arcor.de> wrote:
>
>  > > > >>>> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the drivers
>  > > > >>>> for   the Hauppauge WinTV appear to have suffered some regression
>  > > > >>>> between the two kernel versions.
>
>
> > do you see the auto detection issue?
>  >
>  > Either tell it is just nothing, what I very seriously doubt, or please
>  > comment.
>  >
>  > I don't like to end up on LKML again getting told that written rules
>  > don't exist ;)
>
>  Sorry for now answer earlier. Too busy here, due to the merge window.
>
>  This seems to be an old bug. On several cases, tuner_type information came from
>  some sort of autodetection schema, but the proper setup is not sent to tuner.
>
>  Please test the enclosed patch. It warrants that TUNER_SET_TYPE_ADDR is called
>  at saa7134_board_init2() for all those boards:
>
>  SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331
>  SAA7134_BOARD_ASUS_EUROPA2_HYBRID
>  SAA7134_BOARD_ASUSTeK_P7131_DUAL
>  SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA
>  SAA7134_BOARD_AVERMEDIA_SUPER_007
>  SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM
>  SAA7134_BOARD_BMK_MPEX_NOTUNER
>  SAA7134_BOARD_BMK_MPEX_TUNER
>  SAA7134_BOARD_CINERGY_HT_PCI
>  SAA7134_BOARD_CINERGY_HT_PCMCIA
>  SAA7134_BOARD_CREATIX_CTX953
>  SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
>  SAA7134_BOARD_FLYDVB_TRIO
>  SAA7134_BOARD_HAUPPAUGE_HVR1110
>  SAA7134_BOARD_KWORLD_ATSC110
>  SAA7134_BOARD_KWORLD_DVBT_210
>  SAA7134_BOARD_MD7134
>  SAA7134_BOARD_MEDION_MD8800_QUADRO
>  SAA7134_BOARD_PHILIPS_EUROPA
>  SAA7134_BOARD_PHILIPS_TIGER
>  SAA7134_BOARD_PHILIPS_TIGER_S
>  SAA7134_BOARD_PINNACLE_PCTV_310i
>  SAA7134_BOARD_TEVION_DVBT_220RF
>  SAA7134_BOARD_TWINHAN_DTV_DVB_3056
>  SAA7134_BOARD_VIDEOMATE_DVBT_200
>  SAA7134_BOARD_VIDEOMATE_DVBT_200A
>  SAA7134_BOARD_VIDEOMATE_DVBT_300
>
>  It is important to test the above boards, to be sure that no regression is
>  caused.
>
>  Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
>
>  diff -r 60110897e86a linux/drivers/media/video/saa7134/saa7134-cards.c
>  --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Fri Apr 25 08:04:54 2008 -0300
>  +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Fri Apr 25 10:44:16 2008 -0300

Mauro,

I didn't review your patch yet, and it needs to be tested, however,
the bug reported in this thread deals with the same regression that
you are attempting to repair, but on the cx88 driver -- not the
saa7134 driver.

Both drivers need to be tested to make sure that this regression has been fixed.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
