Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0IErC3i031633
	for <video4linux-list@redhat.com>; Sun, 18 Jan 2009 09:53:12 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0IEqtOh028135
	for <video4linux-list@redhat.com>; Sun, 18 Jan 2009 09:52:55 -0500
Received: by wf-out-1314.google.com with SMTP id 25so2476624wfc.6
	for <video4linux-list@redhat.com>; Sun, 18 Jan 2009 06:52:55 -0800 (PST)
Message-ID: <b101ebb80901180652mda95999j6df3efb1df950423@mail.gmail.com>
Date: Mon, 19 Jan 2009 10:22:54 +1930
From: "Jose Diaz" <xt4mhz@gmail.com>
To: "Akhila Madhukumar" <akhilapisces@gmail.com>
In-Reply-To: <1249fb080901180425s5caf1b4ds4fc508ef06c79f30@mail.gmail.com>
MIME-Version: 1.0
References: <1249fb080901180425s5caf1b4ds4fc508ef06c79f30@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: Re: Project help
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

Hi Akhila.

I did something similar but just two cameras with two Osprey 230 cards.

VLC have a a management interface name VLM accesible via telnet.

Let me explain a little more:

1) Hardware 100% identfied in Linux box: I use Ubuntu Server Hardy Heron
with "medubuntu.org" repos configured.

2) VLC and FFMPEG from mediubuntu.org repos: its because they have mp3 and
FLV bundled support.

3) Start the VLC service accessible via telnet using this command:

vlc -v --color -I telnet --telnet-port 7777 --telnet-password COCACOLA
--rtsp-host 200.90.37.84:4321 &

4) VLM can read a script file. You can write "script.txt" whith this lines:

new event broadcast enabled
setup event input
"v4l:///dev/video0:adev=/dev/dsp:audio=1:norm=1:frequency=-1:caching=300:fps=4:channel=0:tuner=-1:width=0:height=0:brightness=-1:colour=-1:hue=-1:contrast=-1:decimation=1:quality=100"
setup event output
#transcode{vcodec=WMV1,vb=128,scale=1,width=320,height=240,fps=5,acodec=mp3,ab=128,channels=0,samplerate=44100,sfilter=time}:duplicate{dst=std{access=http,mux=asf{title="EVENTO0-CAM0",author=MEMPET,copyright="INFORMACION
PUBLICA"},dst=200.90.37.84:1234/event.asf
},dst=std{access=file,mux=asf,dst="/home/operador/event.asf"}}
control event play

5) To access VLM in shell do:

telnet localhost 7777
(enter COCACOLA)
(load the script.txt file)
load /home/operador/script.txt

6) This code willl stream through "http://200.90.37.84:1234/event0.asf"

7) To stop and clean VLM "event":

control event stop
del event

You have to change "transcode" module parameters to you need.

Hope this help.

Success!

Jose

2009/1/19 Akhila Madhukumar <akhilapisces@gmail.com>

> Hi.
>   My group of 4 are doing a project on "Video Streaming in Linux"
>   We are taking the input thru 150 capture card and then passing it on to
> ffmpeg to get flv file format which will then be streamed and stored
> simultaneously. Please give us some information on how should we proceed,
> also about the v4l2 source code!
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
