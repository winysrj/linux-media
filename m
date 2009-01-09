Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0936YdD024922
	for <video4linux-list@redhat.com>; Thu, 8 Jan 2009 22:06:34 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0936Jdu026887
	for <video4linux-list@redhat.com>; Thu, 8 Jan 2009 22:06:19 -0500
Received: by wf-out-1314.google.com with SMTP id 25so9459002wfc.6
	for <video4linux-list@redhat.com>; Thu, 08 Jan 2009 19:06:19 -0800 (PST)
Message-ID: <b101ebb80901081906i5343bf1dl21020c2e89fdfdf0@mail.gmail.com>
Date: Fri, 9 Jan 2009 22:36:18 +1930
From: "Jose Diaz" <xt4mhz@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Help with Osprey 230 cards - no sound.
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

Hi.

I need help using Osprey 230 cards. I did a huge research but not success.

I have a server with two Osprey 230 cards:

1) /dev/video0 with /dev/dsp1
2) /dev/video1 with /dev/dsp2

I am using VLC to stream a data and using VLM to manage the stream event.

The problem is that I cant mix the video and the audio from the Osprey 230
card because the audio is not recorded. I can stream the video but not with
the audio. I tried using another pci sound card (/dev/dsp) and worked very
well mixing the audio and the video.

I am using the RCA cables.

To create an evento I send to VLM this lines:

new evento0 broadcast enabled

setup evento0 input "v4l:///dev/video0:*adev=/dev/dsp*
:audio=1:norm=1:frequency=-1:caching=300:fps=-1.000000:channel=0:tuner=-1:width=0:height=0:brightness=-1:colour=-1:hue=-1:contrast=-1:decimation=1:quality=100"

setup evento0 output

#transcode{vcodec=WMV1,vb=128,scale=1,width=320,height=240,fps=5,acodec=mp3,ab=128,channels=0,samplerate=44100}:duplicate{dst=std{access=http,mux=asf{title="EVENTO0-CAM0",author=MEMPET,copyright="INFORMACION
PUBLICA"},dst=200.90.37.84:1234/evento0.asf}}

As you can see, "adev" parameter is the sound device used for the capture.

Do I have to set a parameter to the driver ?

Do I have to change with v4lctl something in the card ? .... I noticed that
"mute" attribute is "On" but I cant change it to "off" using "setattr" with
v4lctl.

Please, I really need some help ... this card is very expensive here and
Viewcast says that its compatible with linux :(

Thanks a lot.

Jose.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
