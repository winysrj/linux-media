Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nACKa4rB002330
	for <video4linux-list@redhat.com>; Thu, 12 Nov 2009 15:36:04 -0500
Received: from mail14.bluewin.ch (mail14.bluewin.ch [195.186.19.62])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nACKa3Ms017157
	for <video4linux-list@redhat.com>; Thu, 12 Nov 2009 15:36:04 -0500
Message-ID: <4AFC71A6.1020509@gmx.net>
Date: Thu, 12 Nov 2009 21:35:50 +0100
From: Roland Egli <roland.egli@gmx.net>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <4AF87D5D.5090205@gmx.net> <20091110145049.GA3282@bluebox.local>
	<1257901606.3246.30.camel@pc07.localdom.local>
In-Reply-To: <1257901606.3246.30.camel@pc07.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Terratec Cinergy 600 TV MK3: Problem with Radio/RDS
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

hermann pitton wrote:
> Hi,
>
> Am Dienstag, den 10.11.2009, 15:50 +0100 schrieb Hans J. Koch:
>   
>> On Mon, Nov 09, 2009 at 09:36:45PM +0100, Roland Egli wrote:
>>     
>>> Hi all
>>>
>>> I have the TV card "Terratec Cinergy 600 TV MK3" with SAA7134HL. The  
>>> tuner is a Philips FM1216ME/H-3 and there is an additional RDS decoder  
>>> SAA6588T.
>>>
>>> For loading the module I use
>>> $ modprobe saa7134 card=48 tuner=38
>>>
>>> TV works fine, but I have a problem with the radio. The sound is very  
>>> noisy, not stereo and there is as well no RDS reception (saa6588 module  
>>> is loaded as well).
>>>       
>> For RDS reception, you need a strong signal since the RDS carrier's
>> level is well below the audio carrier level. Your only chance is to
>> improve reception. What kind of antenna are you using? Are you sure it's
>> connected to the _radio_ antenna jack and not the TV?
>>
>> Thanks,
>> Hans
>>
>>     
>
> Hans, for what I know it makes no difference on that tuner, if radio
> comes in from the TV antenna connector or from the radio connector.
>
> At least we don't have some dedicated separating RF input switch for
> that.
>
> For example, the other way round, if you have a cable TV provider also
> providing radio, and radio freqs are not filtered from the TV input
> connected, radio will just work fine from the TV antenna connector and
> likely are all stereo. I can't tell anything for RDS.
>
> If you now also connect that cheap rabbit ears antenna mostly coming
> with such cards, this might lead to overlapping frequencies noticed as
> too much noise on radio. Maybe we still miss something, but it is not in
> the tuner specs.
>
> Me and one single other guy reported loud thrilling noise for radio if
> tuned into off on later driver revisions. I'm still not sure, if it is
> only caused by machine specific interferences, a network cable had some
> impact on it, but I saw/heard it later also on FMD hybrid devices on a
> different machine.
>
> To connect the rabbit ears to the radio antenna connector will turn that
> annoying noise into normal static. On that FMD hybrid you usually will
> have the better radio reception from a roof mounted antenna for DVB-T
> and there is also no active RF input switching like we only saw it later
> on silicon hybrid devices.
>
> For radio stereo it needs still some v4l2 app and kradio and mplayer
> with v4l2 radio support are still the best candidates, but I'm not on
> latest on radio apps around currently.
>
> Reception improvement is of course still the best key for all.
>
> Thanks,
> Hermann
>
>
>   
Thanks for the answers and your further quesions, which I can answer here:
- I receive Radio and TV via cable, so the signal strength is ok (for 
stereo and rds)
- There are no frequency-filters so the tuner gets the whole bandwith
- In Windows with the original Terratec-SW everything (incl. RDS) works 
fine.

So I assume, there must be a problem in the driver in the area of radio.

Thanks for further help in advance.
Roland


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
