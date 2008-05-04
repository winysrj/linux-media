Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m44KpGos030249
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 16:51:16 -0400
Received: from mailout07.t-online.de (mailout07.t-online.de [194.25.134.83])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m44Kp5Yr002355
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 16:51:05 -0400
Message-ID: <481E219C.50008@t-online.de>
Date: Sun, 04 May 2008 22:50:36 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20080428182959.GA21773@orange.fr>	<alpine.DEB.1.00.0804282103010.22981@sandbox.cz>	<20080429192149.GB10635@orange.fr>	<1209507302.3456.83.camel@pc10.localdom.local>	<20080430155851.GA5818@orange.fr>	<1209592608.31036.36.camel@pc10.localdom.local>
	<20080430202547.1765d34c@gaivota>
In-Reply-To: <20080430202547.1765d34c@gaivota>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Card Asus P7131 hybrid > no signal
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

Hi, Mauro

Mauro Carvalho Chehab schrieb:
>> We have definitely issues on analog, but I can't test SECAM_L.
>>
>> After ioctl2 conversion, the apps don't let the user select specific
>> subnorms like PAL_I, PAL_BG, PAL_DK and SECAM_L, SECAM_DK, SECAM_Lc
>> anymore.
> 
> Seems to be an issue at the userspace app. SAA7134_NORMS define a mask of supported
> norms. STD_PAL covers all the above PAL_foo. Also, SECAM covers all the above
> SECAM_foo.
> 
> If the userspace app sets V4L2_STD_PAL, the driver should run on autodetection
> mode. If, otherwise, the app sets V4L2_STD_PAL_I, the driver will accept and
> select PAL_I only.
> 
>> Internally the driver knows about all norms, but we have a clear
>> breakage of application backward compatibility and might see various
>> side effects. Especially, but not only for SECAM, it was important that
>> the users can select the exact norm themselves because of audio carrier
>> detection issues.
> 
It is not only Audio carrier selection:
SECAM-L is the only standard with positive modulation of the vision carrier.
The tuner needs to know this. So in the case of SECAM-L, we need the *exact*
standard.
The insmod option secam=l transfers the exact standard to the tuner.

By the way: I just noticed this: If saa713x does not identify the color system
(improperly forced), tvtime will say "no signal"

>> It is firstly on 2.6.25.
>>
>> If you are affected, apps like xawtv or mplayer will only report these
>> TV standards.
> 
> It shouldn't be hard to make enum_std to send all possible supported formats.
> Maybe this could be good for the apps you've mentioned.
> 
> In this case, a patch to videodev.c should replace the code after case
> VIDIOC_ENUMSTD to another one that would report the individual standards, plus
> the grouped ones.
> 
> Cheers,
> Mauro
> 
Best regards
   Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
