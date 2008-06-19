Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5JFR638013626
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 11:27:06 -0400
Received: from horsea.3ti.be (horsea.3ti.be [62.213.193.164])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5JFQqbl024595
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 11:26:52 -0400
Date: Thu, 19 Jun 2008 17:26:51 +0200 (CEST)
From: Dag Wieers <dag@wieers.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <23809.62.70.2.252.1213888764.squirrel@webmail.xs4all.nl>
Message-ID: <alpine.LRH.1.10.0806191722250.24892@horsea.3ti.be>
References: <23809.62.70.2.252.1213888764.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com
Subject: Re: Looking for a well suppord TV card with some requirements
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

On Thu, 19 Jun 2008, Hans Verkuil wrote:

>> I am looking for a well support TV card with the following feature list:
>>
>>    - Must have at least one tuner (PAL), preferably two
>>    - Must have composite input (for connecting a Nintendo Wii)
>>    - Should not have any delay between input signal and output
>>    - Works on kernel 2.6.18 (either vanilla, or by adding a driver)
>>    - Additionally, DVB-T would be nice
>>
>> I bought a Hauppauge PVR-150 because I thought it complied to the above,
>> but apparently (because it is an MPEG encoder and not a real TV card)
>> there was a 2 second delay between the image from the Wii and the output
>> on screen which is unacceptable for playing games.
>
> Before you buy something else, read this thread on how to avoid the 2
> second delay with a PVR-150:
>
> http://www.gossamer-threads.com/lists/ivtv/devel/36688

Hey Hans,

I read that thread when looking for a solution but could not make mplayer 
do what he did. Maybe my mplayer is older or newer.

However the fact that the card (or the ivtv driver that worked with 
2.6.18) only provided an MPEG stream on /dev/video made me uninterested to 
pursue the path. VLC has a special PVR input mode for that reason, one 
cannot use tvtime or zapping with this PVR-150 card and the only way to 
control the tuner is with another commandline tool.

I returned the card immediately for that reason.

-- 
--   dag wieers,  dag@wieers.com,  http://dag.wieers.com/   --
[Any errors in spelling, tact or fact are transmission errors]

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
