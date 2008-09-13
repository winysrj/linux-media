Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8E00nIJ030437
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 20:00:50 -0400
Received: from zim.mi-connect.com (zim.mi-connect.com [208.73.200.230])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8E00bJU013002
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 20:00:38 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zim.mi-connect.com (Postfix) with ESMTP id 5E2D22338733
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 19:44:38 -0400 (EDT)
Received: from zim.mi-connect.com ([127.0.0.1])
	by localhost (zim.mi-connect.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mARCCulsAUV3 for <video4linux-list@redhat.com>;
	Sat, 13 Sep 2008 19:44:36 -0400 (EDT)
Received: from zim.mi-connect.com (zim.mi-connect.com [208.73.200.230])
	by zim.mi-connect.com (Postfix) with ESMTP id 4392223386A5
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 19:44:36 -0400 (EDT)
Date: Sat, 13 Sep 2008 19:44:35 -0400 (EDT)
From: ron gage <ron@rongage.org>
To: video4linux-list@redhat.com
Message-ID: <1307084.71221349475763.JavaMail.root@zim.mi-connect.com>
In-Reply-To: <11204850.51221349360873.JavaMail.root@zim.mi-connect.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Osprey 230 - no audio
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

Greetings!

I have an Osprey 230 capture card that is giving me fits.  I have video working from it without issue but can't for the life of me get any audio from it at all.

I am working from Slackware 12 and kernel 2.6.26.5.

I have checked that sound is going to the card (verified by connecting headphones directly to the audio cable).

While audio is going to the card, I have ran the following command: sox -w -r 48000 -t ossdsp /dev/dsp1 -t wav try.wav   - this gives me a wav file with no audio.

dmesg shows nothing wrong at all.  Module insertion (snd-bt87x) creates the device nodes without issue.

output from amixer -c 1:
ron@video:/root/vlc/vlc-0.9.2$ amixer -c 1
Simple mixer control 'FM',0
  Capabilities: cswitch cswitch-joined cswitch-exclusive
  Capture exclusive group: 0
  Capture channels: Mono
  Mono: Capture [off]
Simple mixer control 'Mic/Line',0
  Capabilities: cswitch cswitch-joined cswitch-exclusive
  Capture exclusive group: 0
  Capture channels: Mono
  Mono: Capture [off]
Simple mixer control 'Capture',0
  Capabilities: cvolume
  Capture channels: Mono
  Limits: Capture 0 - 15
  Mono: Capture 0 [0%]
Simple mixer control 'Capture Boost',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [off]
Simple mixer control 'TV Tuner',0
  Capabilities: cswitch cswitch-joined cswitch-exclusive
  Capture exclusive group: 0
  Capture channels: Mono
  Mono: Capture [on]
ron@video:/root/vlc/vlc-0.9.2$


Setting the capture control to 100% does nothing - still no sound out.

Does anyone have any ideas on what to try here?

Thanks!

Ron

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
