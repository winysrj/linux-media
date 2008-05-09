Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m49BXbsv006013
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 07:33:37 -0400
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m49BXO7p017747
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 07:33:24 -0400
Message-ID: <48243681.30500@users.sourceforge.net>
Date: Fri, 09 May 2008 13:33:21 +0200
From: Andre Auzi <aauzi@users.sourceforge.net>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <482370FD.7000001@users.sourceforge.net>	
	<1210292031.4565.26.camel@palomino.walls.org>
	<1210294711.2541.6.camel@pc10.localdom.local>
In-Reply-To: <1210294711.2541.6.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: cx88 driver: Help needed to add radio support on Leadtek	WINFAST
 DTV 2000 H (version J)
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

hermann pitton a écrit :
> Am Donnerstag, den 08.05.2008, 20:13 -0400 schrieb Andy Walls:
>> On Thu, 2008-05-08 at 23:30 +0200, Andre Auzi wrote:
>>> Hello list,
>>>
>>> I've started the task to add support of the board mentionned above.
>>>
>>> So far I've got analog TV, Composite and Svideo inputs working OK with 
>>> IR as well.
>>>
>>> Unfortunately, my area does not have DVB-T yet, but from the scans I've 
>>> made, I'm confident DVB support is on good tracks.
>>>
>>> Nevertheless, I cannot achieve to have the radio input working.
>>>
>>> The gpio values were captured with regspy on a working windows installation.
>> With the ivtv driver, I helped debug the LG TAPE-H series tuner on the
>> PVR-150MCE not demodulating FM radio.  (Hans actually got the fix put
>> in.)  The problem turned out to be the incorrect "bandswitch byte" being
>> set in tuner-simple.c.  AFAICT, the gpio values for the CX23416 aren't
>> used to set the FM radio on the PVR-150MCE.
>>
>> There is a "bandswitch byte" in the synthesizer/1st mixer chip (probably
>> a tua603x chip) in the tuner that controls some gpio pins.  These gpio
>> pins setup the tuner's preselector by switching in the proper bandpass
>> filter for the Low VHF, FM, High-VHF, or UHF bands
>>
>> For the FM1216ME_MK3 tuner (not the FMD1216ME_MK3) this bandswitch byte
>> needs to be set to 0x98 for FM stereo or 0x9a for FM mono.
>>
>> I notice in tuner-simple.c:simple_radio_bandswitch(), that for both the
>> FM1216ME_MK3 and the FMD1216ME_MK3, the bandswitch byte for FM is coded
>> as 0x19.  This is a bit-reversal of 0x98.  This seems wrong according to
>> the FM1216ME_MK3 tuner datasheet here:
>>
>> http://dl.ivtvdriver.org/datasheets/tuners/FM1216ME_MK3.pdf
>>
>> I can't find the FMD1216ME_MK3 datasheet with some quick google
>> searches.  I cannot conclusively say the coded bandswitch byte of 0x19
>> is wrong for the FMD1261ME_MK3, but I think it's worth some
>> investigation/experimentation.
> 
> Hi,
> 
> it is, we were only hackers!
> 
> And there is no substitution for it.
> 
> The radio stereo hack was specific for the FM1216ME/I H-3 (MK3) and the
> FMD1216ME/I H-3 (MK-3) never could utilize that bit reading out the
> stereo status for FM ...
> 
> Cheers,
> Hermann
>  

Thanks Andy, thanks Hermann,

this gives me another start point.

It's all new stuff for me and it may take some time to digest the 
information but I'll do my best.

With the hardware in hands it would be a shame if I don't come up with 
something.

Cheers,
Andre

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
