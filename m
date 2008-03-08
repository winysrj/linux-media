Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m285VWLf001490
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 00:31:32 -0500
Received: from www.seiner.com (flatoutfitness.com [66.178.130.209])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m285UweA020444
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 00:30:58 -0500
Received: from www.seiner.com ([192.168.128.6] ident=yan)
	by www.seiner.com with esmtps (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.68) (envelope-from <yan@seiner.com>) id 1JXre0-0003Gx-6c
	for video4linux-list@redhat.com; Fri, 07 Mar 2008 21:30:52 -0800
Message-ID: <47D2248B.8080804@seiner.com>
Date: Fri, 07 Mar 2008 21:30:51 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <865752.65449.qm@web56413.mail.re3.yahoo.com>
	<47D2229A.9090300@linuxtv.org>
In-Reply-To: <47D2229A.9090300@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: WinTV-HVR-1800 help...
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

Michael Krufky wrote:
> r bartlett wrote:
>   
>> Silly as it sounds, I'm a television noobie here and have been wading around for months trying to get my WinTV-HVR-1800 card to just play television.  I don't need any of the PVR stuff or recording, and I only have Basic (analog) cable...I'm hoping to match the functionality I have in Windo$e so that I don't have to reboot every time I want to see a show.
>>
>> Any and all help would be greatly appreciated.  Part of the trouble has been I'm unfamiliar with the various television terms (ATSC, for example, until recently) so I kind of need a walk through of what steps I need to take to get my system working.
>>
>> I'm running 2.6.24.3 kernel, Fedora Core 8 distro, in a KDE environment.  I have a /dev/dvb/adapter0/* device but no /dev/video0.  I have gotten the updated firmware from http://steventoth.net/linux/hvr1800/ and put it into /lib/firmware...
>>
>> And still no dice.  Xawtv chokes, giving me this message:
>>
>> This is xawtv-3.95, running on Linux/i686 (2.6.24.3-12.fc8)
>> X Error of failed request:  XF86DGANoDirectVideoMode
>>   Major opcode of failed request:  136 (XFree86-DGA)
>>   Minor opcode of failed request:  1 (XF86DGAGetVideoLL)
>>   Serial number of failed request:  68
>>   Current serial number in output stream:  68
>>
>> If I try scantv, in hopes of getting a channel file, I get:
>> scantv
>> ioctl: VIDIOC_G_STD(std=0x8058688bf91f308 [PAL_H,PAL_M,PAL_N,NTSC_M,NTSC_M_JP,?,?,SECAM_B,SECAM_K,?ATSC_8_VSB,ATSC_16_VSB,(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)]): Invalid argument
>>
>> please select your TV norm
>> nr ?   
>>
>> And no matter what I write in the "nr?" section (0, 1, PAL_M, NTSC_M...) it just keeps giving me that error.
>>
>> So I'm kind of stumped.  Am I still having a firmware problem?  Am I missing a step necessary before running "scantv"?
>>
>> I'm terribly sorry for the noobie aspects of all this, but any clear, precise help would be greatly appreciated, particularly from someone who has gotten the analog part working.  I'm pretty sure the digital side is not going to happen without subscribing to digital channels.  I'd just like to open a window every so often and watch plain old analog tv.
>>     
>
> The digital side is 100% supported.  The analog side is not supported at all in the 2.6.24.y kernel series.  The master v4l-dvb development tree adds support for analog video with no audio.  If you pull down stoth's cx23885-video tree, you can enable the mpeg2 hardware encoder, and then you'll have analog mpeg audio and video fully working .  After some more testing and cleanups, that will eventually be merged into the master branch.
>
> You should give digital a try -- you do not need any subscription to receive Free-To-Air ATSC broadcasts (using an antennae).  Likewise, you can also receive digital cable SDTV and Clear QAM broadcasts on your standard cable at no extra charge -- give it a try, you may be surprised 8-).
>   
And, to make the decision simpler, most TV stations these days duplicate 
the analog channels on a digital multiplex, so if you drop the analog, 
you really don't miss anything.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
