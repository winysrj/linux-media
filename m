Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from chokecherry.srv.cs.cmu.edu ([128.2.185.41])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rajesh@cs.cmu.edu>) id 1JTFEz-0000fY-Ua
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 12:41:58 +0100
Received: from [192.168.1.129] (cm29.delta204.maxonline.com.sg [59.189.204.29])
	(authenticated bits=0)
	by chokecherry.srv.cs.cmu.edu (8.13.6/8.13.6) with ESMTP id
	m1OBfkD5021869
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Sun, 24 Feb 2008 06:41:51 -0500 (EST)
Message-ID: <47C15803.3020306@cs.cmu.edu>
Date: Sun, 24 Feb 2008 19:41:55 +0800
From: Rajesh Balan <rajesh@cs.cmu.edu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47AB0219.8050408@cs.cmu.edu>
In-Reply-To: <47AB0219.8050408@cs.cmu.edu>
Subject: [linux-dvb] HVR-1300 Audio Issues. Audio works but is way too loud
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


I've managed to smack down most of the other issues I had. But the last 
issue with analog recording remains -- I can get audio but it is way too 
loud.

I'm using the hvr-1300 hg branch with the PAL-BG audio fix (last patch). 
My input is from my cable box into the composite in of the HVR-1300.

The video is fine but the audio is way too loud. It sounds like the 
internal gain setting is set way too high. no audio control (alsamixer, 
v4l2-ctl -c volume 1  etc.) seem to work. The volume never changes.

I have a sample of the audio at http://www.cs.cmu.edu/~rajesh/foo.wav

This was recorded using  arecord -D hw:1,0 -c 2 -r 48000 -f S16_LE -t 
wav > foo.wav
I've replicated this same audio problem using mythtv's live tv function 
and with mplayer (with the tv:// option)

I noticed that the audio is also finicky. I sometimes get silence or 
static until I do v4l2-ctl -i 1. This is even with a proper video being 
displayed.

Any suggestions for fixing this? for reference, cat /dev/video1 > 
foo.mpg  has perfect audio synced with the video.

Rajesh


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
