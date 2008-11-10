Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAA9UvT2012081
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 04:30:57 -0500
Received: from redneck.websupport.sk (redneck.websupport.sk [82.119.226.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAA9UiRr015192
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 04:30:44 -0500
Received: from redneck.websupport.sk (localhost [127.0.0.1])
	by clamsmtp.websupport.sk (Postfix) with ESMTP id 39F451C04C206
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 10:30:44 +0100 (CET)
Received: from [192.168.1.52] (static-dsl-170.87-197-103.telecom.sk
	[87.197.103.170]) (Authenticated sender: peter.v@datagate.sk)
	by redneck.websupport.sk (Postfix) with ESMTPA id 0DED41C04C202
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 10:30:44 +0100 (CET)
Message-ID: <4917FF40.6080500@datagate.sk>
Date: Mon, 10 Nov 2008 10:30:40 +0100
From: =?UTF-8?B?UGV0ZXIgVsOhZ25lcg==?= <peter.v@datagate.sk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <patchbomb.1226272760@roadrunner.athome>
In-Reply-To: <patchbomb.1226272760@roadrunner.athome>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0 of 2] cx88: add optional stereo detection to PAL-BG
 mode	with A2 sound system
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

Hello,

On 10.11.2008 0:19, Marton Balint wrote:
> This patchset adds support for optional stereo detection for PAL-BG mode. This
> is a slightly modified version of the original patch I sent to this list
> earlier this year.  The first patch disables the audio thread in cx88, and the
> second implements stereo detection.
>
> The audio thread in the cx88 code is totally useless, because cx88_get_stereo
> is not implemented correctly. Because of this, the audio thread occaisonally
> sets the audio to MONO after starting a TV application, and unfortuantely this
> may happen after the stereo detection.
>
> Stereo detection is optional, and is not enabled by default, because it is not
> always reliable, the actual results may depend on your TV application and your
> provider. It works 100% for me using tvtime, and another guy reported success
> earlier, as a result of my original posting.
>
I am the one who has tried original Marton's patches this year.
After applying I was able to get stereo working with Aver TV Studio 303 
using mplayer / mencoder. When there were multiple audio streams 
broadcasted I was getting them in the respective channels I.E. I had no 
mono sound.
I am using this setup for recording only so actually this is great for 
me as I can do multidub rips when available.

Do you recommend to update to latest V4L and apply new patches?

Regards

Peter Vágner

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
