Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1L4aOB-0001Vl-Dq
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 13:18:04 +0100
From: Darron Broad <darron@kewl.org>
To: "Eduard Huguet" <eduardhc@gmail.com>
In-reply-to: <617be8890811240346r3aae6f31rfab45804419bfade@mail.gmail.com> 
References: <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com>
	<29500.1227284783@kewl.org>
	<617be8890811240346r3aae6f31rfab45804419bfade@mail.gmail.com>
Date: Mon, 24 Nov 2008 12:17:59 +0000
Message-ID: <18885.1227529079@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Distorted analog sound when using an HVR-3000
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <617be8890811240346r3aae6f31rfab45804419bfade@mail.gmail.com>, "Eduard Huguet" wrote:

hi

>Nothing :(. The results are exactly the same: when I use the analog TV
>input, the sound is bad but understable, but somehow "high pitched" fro some
>reason.

okay. as it stands, analogue TV audio isn't affected by these changes
so no change here is expected. i could see about changing this if you
could live with mono only. however, this really would depend on whether
any of this works for you at all...

>When using s-video or composite (this, capturing sound from LineIn input)
>the sound is completely broken: I'm getting only crackling noise,
>ocassionaly disrupted by some fragments of which it should be the original
>input sound...

if this is the same problem as which has been addressed for analogue
input (LINE-IN) for me on both an hvr-1300 and hvr-4000 then you can try to
attenuate the input level even more to see if it improves things.

>This happens both in MythTV and when using mplayer, like i.e. using the
>following command line:
>
>mplayer tv:// -tv driver=v4l2:device=/dev/video0:norm=PAL-BG:\
>input=1:alsa:adevice=hw.1,0:amode=1:volume=50:immediatemode=0:buffersize=3
>
>Any ideas? I'm using a fresh copy of http://hg.kewl.org/v4l-dvb/ repository.

The volume level can be from 0 to 63 try something even lower (10).
If the volume= option doesn't work as anticipated then
try v4l2-ctl -d /dev/video --set-ctrl=volume=XX as well.

We can look at other things if you have the time for it, e-mail me off-list
and we can look work something out.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
