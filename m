Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3PF7dVA011582
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 11:07:39 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3PF7R6s030241
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 11:07:27 -0400
Message-ID: <4811F391.1070207@linuxtv.org>
From: mkrufky@linuxtv.org
To: mchehab@infradead.org
Date: Fri, 25 Apr 2008 11:06:57 -0400
MIME-Version: 1.0
in-reply-to: <20080425114526.434311ea@gaivota>
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org, gert.vervoort@hccnet.nl
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

Mauro Carvalho Chehab wrote:
> On Fri, 25 Apr 2008 10:40:14 -0400
> "Michael Krufky" <mkrufky@linuxtv.org> wrote:
>
>   
>> On Fri, Apr 25, 2008 at 9:56 AM, Mauro Carvalho Chehab
>> <mchehab@infradead.org> wrote:
>>     
>>> On Thu, 24 Apr 2008 05:55:28 +0200
>>>  hermann pitton <hermann-pitton@arcor.de> wrote:
>>>
>>>  > > > >>>> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the
drivers
>>>  > > > >>>> for   the Hauppauge WinTV appear to have suffered some
regression
>>>  > > > >>>> between the two kernel versions.
>>>
>>>
>>>       
>>>> do you see the auto detection issue?
>>>>         
>>>  >
>>>  > Either tell it is just nothing, what I very seriously doubt, or
please
>>>  > comment.
>>>  >
>>>  > I don't like to end up on LKML again getting told that written rules
>>>  > don't exist ;)
>>>
>>>  Sorry for now answer earlier. Too busy here, due to the merge window.
>>>
>>>  This seems to be an old bug. On several cases, tuner_type information
came from
>>>  some sort of autodetection schema, but the proper setup is not sent to
tuner.
>>>
>>>  Please test the enclosed patch. It warrants that TUNER_SET_TYPE_ADDR is
called
>>>  at saa7134_board_init2() for all those boards:
>>>
>>>  SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331
>>>  SAA7134_BOARD_ASUS_EUROPA2_HYBRID
>>>  SAA7134_BOARD_ASUSTeK_P7131_DUAL
>>>  SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA
>>>  SAA7134_BOARD_AVERMEDIA_SUPER_007
>>>  SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM
>>>  SAA7134_BOARD_BMK_MPEX_NOTUNER
>>>  SAA7134_BOARD_BMK_MPEX_TUNER
>>>  SAA7134_BOARD_CINERGY_HT_PCI
>>>  SAA7134_BOARD_CINERGY_HT_PCMCIA
>>>  SAA7134_BOARD_CREATIX_CTX953
>>>  SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
>>>  SAA7134_BOARD_FLYDVB_TRIO
>>>  SAA7134_BOARD_HAUPPAUGE_HVR1110
>>>  SAA7134_BOARD_KWORLD_ATSC110
>>>  SAA7134_BOARD_KWORLD_DVBT_210
>>>  SAA7134_BOARD_MD7134
>>>  SAA7134_BOARD_MEDION_MD8800_QUADRO
>>>  SAA7134_BOARD_PHILIPS_EUROPA
>>>  SAA7134_BOARD_PHILIPS_TIGER
>>>  SAA7134_BOARD_PHILIPS_TIGER_S
>>>  SAA7134_BOARD_PINNACLE_PCTV_310i
>>>  SAA7134_BOARD_TEVION_DVBT_220RF
>>>  SAA7134_BOARD_TWINHAN_DTV_DVB_3056
>>>  SAA7134_BOARD_VIDEOMATE_DVBT_200
>>>  SAA7134_BOARD_VIDEOMATE_DVBT_200A
>>>  SAA7134_BOARD_VIDEOMATE_DVBT_300
>>>
>>>  It is important to test the above boards, to be sure that no regression
is
>>>  caused.
>>>
>>>  Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
>>>
>>>  diff -r 60110897e86a linux/drivers/media/video/saa7134/saa7134-cards.c
>>>  --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Fri Apr 25
08:04:54 2008 -0300
>>>  +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Fri Apr 25
10:44:16 2008 -0300
>>>       
>> Mauro,
>>
>> I didn't review your patch yet, and it needs to be tested, however,
>> the bug reported in this thread deals with the same regression that
>> you are attempting to repair, but on the cx88 driver -- not the
>> saa7134 driver.
>>     
>
> Hmm... it seems that people merged two similar issues together, on
different
> drivers. At least, part of the reports at the thread were with saa7134
driver.
>
> I'll investigate if this solution will also work for cx88.

Mauro,

"...people merged two similar issues together, on different drivers..."  
It was you -- did you forget?

cx88: http://linuxtv.org/hg/v4l-dvb/rev/2eb392c86745

saa7134: http://linuxtv.org/hg/v4l-dvb/rev/e7668fc3666c

I'm surprised that you don't remember this -- you pushed this to Linus 
late in the 2.6.25-rcX, after I had strongly advised against this -- I 
warned you that this may create regressions, needed thorough testing, 
and was too risky a change to push into the middle of 2.6.25-rc

I hate to say, "I told you so" .... but.............

;-)

Lets get your fixes tested ASAP so we can fix 2.6.25-stable.

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
