Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2S6xmq0012900
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 02:59:48 -0400
Received: from sparc.fpv.umb.sk (sparc.fpv.umb.sk [194.160.44.70])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2S6xanx006358
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 02:59:37 -0400
Message-ID: <47EC9739.4050109@datagate.sk>
Date: Fri, 28 Mar 2008 07:59:05 +0100
From: =?ISO-8859-2?Q?Peter_V=E1gner?= <peter.v@datagate.sk>
MIME-Version: 1.0
To: Balint Marton <cus@fazekas.hu>
References: <patchbomb.1206497254@bluegene.athome>
	<47E9F4F4.2050503@datagate.sk>
	<Pine.LNX.4.64.0803261520340.14189@cinke.fazekas.hu>
	<1206553154.7076.4.camel@vb>
	<Pine.LNX.4.64.0803262037560.9392@cinke.fazekas.hu>
In-Reply-To: <Pine.LNX.4.64.0803262037560.9392@cinke.fazekas.hu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 3] cx88: fix oops on rmmod and implement stereo
	detection
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

Balint Marton  wrote / napísal(a):
> Try the attached patch. It disables the audio thread completely.
>


Thanks now this is wonderfull for recording.

Based on some comments posted to this list I have tryed to let the tv 
runing for a few hours and I am getting no unusual behaviour nor 
distorted sound. Here in slovakia all the channels I can tune to are 
also pal-BG. Literally I can tune no mono channels here. Their are 
either broadcasting stereo, or dual (2 independent language track per 
audio channel) or they are sending the same mono track to each channel 
So I am really not woried about the mono audio. The only thing which is 
not very confortable is stereo versus dual audio detection. If it's 
forced to stereo, I am getting both the audio tracks when it changes 
during a viewing session. Ideally it would be nice to be able to switch 
this on the fly. Or perhaps mplayer has some filter where I can 
temporarily enable left or right channel only based off my actual 
preference. I have to look into this further.
I am saying it's fine for the recording because in that case both 
language tracks are great if stereo is not broadcasted. It can be 
processed later.

thanks much again Now I think I can get more from this card using v4l 
than I was used to do under windows. E.G. channel switching is almost 
instantaneous.


Peter

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
