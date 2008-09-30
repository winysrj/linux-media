Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8UMiDFd029230
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 18:44:13 -0400
Received: from zim.mi-connect.com (zim.mi-connect.com [208.73.200.230])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8UMi1k8005754
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 18:44:01 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zim.mi-connect.com (Postfix) with ESMTP id C8487233877C
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 18:27:30 -0400 (EDT)
Received: from zim.mi-connect.com ([127.0.0.1])
	by localhost (zim.mi-connect.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gNI8vSA1mqeB for <video4linux-list@redhat.com>;
	Tue, 30 Sep 2008 18:27:29 -0400 (EDT)
Received: from [192.168.10.129] (s233-64-68-217.try.wideopenwest.com
	[64.233.217.68])
	by zim.mi-connect.com (Postfix) with ESMTP id 77C4523386A1
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 18:27:29 -0400 (EDT)
Message-ID: <48E2AD84.1090807@rongage.org>
Date: Tue, 30 Sep 2008 18:51:48 -0400
From: Ron Gage <ron@rongage.org>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: BT87x card - audio not working
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

Greetings:

I have a BT878 based capture card that is working wonderfully, except 
for audio.  The card is an Osprey 230 from Viewcast.  The card is 
supposed to support digital audio input - no need for a loopback cable 
from the card to the PC's line in.

The card is registering the audio device with the ALSA subsystem but no 
matter what I try, I can not get audio from the card into the PC.  I 
know that audio is going to the card as I have checked the signal 
presence at the input cable.

Kernel is 2.6.26.5  generic with no additional patches.  OS is Slackware 12.

The card is showing up in /proc/asound:
 root@video:/proc/asound# cat devices
  1:        : sequencer
 32: [ 1]   : control
 33:        : timer
 56: [ 1- 0]: digital audio capture
 57: [ 1- 1]: digital audio capture
root@video:/proc/asound#
root@video:/proc/asound/card1# cat id
Bt878
root@video:/proc/asound/card1/pcm0c# cat info
card: 1
device: 0
subdevice: 0
stream: CAPTURE
id: Bt87x Digital
name: Bt87x Digital
subname: subdevice #0
class: 0
subclass: 0
subdevices_count: 1
subdevices_avail: 1
root@video:/proc/asound/card1/pcm0c#


Can anyone provide any clues here?

Thanks!

Ron Gage


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
