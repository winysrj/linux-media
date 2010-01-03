Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o03Fc7si018940
	for <video4linux-list@redhat.com>; Sun, 3 Jan 2010 10:38:07 -0500
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.7])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o03Fbp7B018141
	for <video4linux-list@redhat.com>; Sun, 3 Jan 2010 10:37:51 -0500
Message-ID: <4B40B9CC.1040108@wp.pl>
Date: Sun, 03 Jan 2010 16:37:48 +0100
From: dz-tor <dz-tor@wp.pl>
MIME-Version: 1.0
To: hermann-pitton@arcor.de, terrywu2009@gmail.com, pavle.predic@yahoo.co.uk
Subject: Re: Re: Leadtek Winfast TV2100
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I want to ask whether you are working on this 'issue'. I'm interested in 
the subject, as I'm owner of this card and cannot get this stuff to work 
- I've picture, no sound. Earlier you have written, that you can provide 
patches for testing. If offer is still actual, I can test them. 
Currently I'm using kernel 2.6.31, but if it's a problem I can switch to 
2.6.32.

As I wrote earlier I have the same card - Winfast TV2100 with FM, tv 
norm used in my country is PAL (I'm from Poland).

Regards,
Darek

>
>> Hey guys,
>>
>> Let me start by thanking you both for all your help. Unfortunately, 
>> there isn't much I can do with the data you provided - it's way too 
>> technical for me. I'd be happy to do any tests and apply any patches, 
>> but I would need some instructions - but only if you have time; I 
>> really don't want to burden you with this.
>>
>> Thanks again,
>>
>> Pavle.
>>
>>
>>
>> ________________________________
>> From: hermann pitton<hermann-pitton@arcor.de>
>> To: Terry Wu<terrywu2009@gmail.com>
>> Cc: pavle.predic@yahoo.co.uk; video4linux-list@redhat.com
>> Sent: Sat, 28 November, 2009 4:09:28
>> Subject: Re: Re: Leadtek Winfast TV2100
>>
>> Hi Terry Wu,
>>
>> Am Donnerstag, den 26.11.2009, 10:33 +0800 schrieb Terry Wu:
>> >  Hi,
>> >
>> >  Here are the subsystem IDs for different TV2100 models:
>> >      Subsystem ID:0x6f30107d, TVF8533-BDF (PAL BG/DK)
>> >      Subsystem ID:0x6f32107d, TVF5533-MF (NTSC)
>> >      Subsystem ID:0x6f3a107d, TVF88T5-B/DFF (PAL BG/DK, FM)
>> >
>> >  Terry
>>
>> better is to become active on it.
>>
>> we can most likely help about how to match such tuners fine,
>> if any doubts left, but the best is to send just patches with having
>> such hardware to test on.
>>
>> Compared to the early tda9887 stuff on LeadTek devices, LeadTek was
>> pioneering and we have that in mind, it should be fairly easy for those.
>>
>> Let's know the other way round too, where you have still concerns doing
>> so.
>>
>> Cheers,
>> Hermann
>>
>> >  2009/11/23 hermann pitton<hermann-pitton@arcor.de>:
>> > >  Hi, thanks again!
>> > >
>> > >  Am Montag, den 23.11.2009, 09:42 +0800 schrieb Terry Wu:
>> > >>  Hi,
>> > >>
>> > >>      Please refer to the attached JPEG file for the GPIO 
>> settings of
>> > >>  TV2100 with FM (PCB:B).
>> > >>
>> > >>      Let me know if you need the information of TV2100 without FM
>> > >>  (PCB:A, TVF8533-BDF).
>> > >>
>> > >>  Terry Wu
>> > >
>> > >  On a first look, if we start to count gpios from zero, we tell 
>> the same.
>> > >
>> > >  The TVF8533_BDF I would have to look up. It is four to five 
>> years back.
>> > >
>> > >  If it uses that minor number TI chip without radio support, we 
>> treat it
>> > >  as tuner=69 too currently.
>> > >
>> > >  For all such older can tuners, widely different about the globe, 
>> counts,
>> > >  that we don't have any way to detect them. So first working, 
>> either NTSC
>> > >  or PAL, sits in the pool position and others have to think twice.
>> > >
>> > >  OEMs do code tuners into eeprom content, some do not at all, 
>> such doing
>> > >  it are in competition and don't follow the rules of the main chip
>> > >  manufacturer, Philips/NXP in that case, and go their own ways.
>> > >
>> > >  So tuner tables are unstable across manufacturers.
>> > >
>> > >  We often can't help that much in such cases, but implementing 
>> their own
>> > >  tuner eeprom detection into the linux drivers is of course still
>> > >  welcome. Hauppauge does it very successfully since years.
>> > >
>> > >  We can't do much about it, if OEMs don't follow Philips or whom 
>> ever on
>> > >  such.
>> > >
>> > >  Thanks,
>> > >  Hermann
>> > >
>> > >
>> > >>
>> > >>  2009/11/23 Terry Wu<terrywu2009@gmail.com>:
>> > >> >  Hi,
>> > >> >
>> > >> >     The TVF88T5-BDFF data sheet is attached.
>> > >> >
>> > >> >  Terry Wu
>> > >> >
>> > >> >  11/17/2003  06:39 PM            72,010 TVF5531-MF.pdf
>> > >> >  03/12/2008  11:37 AM           555,285 TVF5533-MF-.pdf
>> > >> >  02/24/2004  02:19 PM           120,727 TVF5533-MF.pdf
>> > >> >  12/30/2003  06:59 PM            91,577 TVF5831-MFF.pdf
>> > >> >  09/26/2005  10:20 AM           156,853 TVF78P3-MFF.pdf
>> > >> >  11/17/2003  06:39 PM            67,947 TVF8531-BDF.pdf
>> > >> >  11/17/2003  06:39 PM            67,715 TVF8531-DIF.pdf
>> > >> >  03/12/2008  11:37 AM           509,340 TVF8533-BDF.pdf
>> > >> >  03/12/2008  11:37 AM           507,295 TVF8533-DIF.pdf
>> > >> >  12/30/2003  06:59 PM            87,921 TVF8831-BDFF.pdf
>> > >> >  12/30/2003  06:59 PM            87,624 TVF8831-DIFF.pdf
>> > >> >  09/26/2005  10:20 AM           176,525 TVF88P3-CFF.pdf
>> > >> >  03/24/2006  10:48 AM           460,941 TVF88T5-BDFF.pdf
>> > >> >  02/24/2004  02:19 PM           132,304 TVF9533-BDF.pdf
>> > >> >  02/24/2004  02:19 PM           120,940 TVF9533-DIF.pdf
>> > >> >  03/12/2008  11:37 AM           458,967 TVF99T5-BDFF.pdf
>> > >> >
>> > >
>> > >
>> > >
>>
>>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
