Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA6C6WeH006892
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 07:06:32 -0500
Received: from omta0101.mta.everyone.net (imta-38.everyone.net
	[216.200.145.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA6C6ID6028830
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 07:06:18 -0500
Received: from dm24.mta.everyone.net (sj1-slb03-gw2 [172.16.1.96])
	by omta0101.mta.everyone.net (Postfix) with ESMTP id 9680B7C5708
	for <video4linux-list@redhat.com>; Thu,  6 Nov 2008 04:06:17 -0800 (PST)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20081106040617.69FB8454@resin09.mta.everyone.net>
Date: Thu, 6 Nov 2008 04:06:17 -0800
From: "urpion urpion" <urpion@linuxwaves.com>
To: <video4linux-list@redhat.com>
Subject: Canon Powershot S80 Remote Capture ability
Reply-To: urpion@linuxwaves.com
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

I am trying to access the remote capture ability of of a Canon Powershot S80 digital camera for animation purposes in a program called stopmotion. I have read that all the remote control abilities are supported by gphoto2. However, gphoto tells me this:

sequencer:/dev# gphoto2 -a
Abilities for camera             : Canon PowerShot S80 (PTP mode)
Serial port support              : no
USB support                      : yes
Capture choices                  :
                                 : Capture not supported by the driver
Configuration support            : yes
Delete selected files on camera  : yes
Delete all files on camera       : no
File preview (thumbnail) support : yes
File upload support              : yes
sequencer:/dev# gphoto2 --list-config
/main/settings/owner
/main/settings/model
/main/settings/firmwareversion
/main/settings/time
/main/settings/capturetarget
/main/settings/capture
/main/imgsettings/imgquality
/main/imgsettings/imgsize
/main/imgsettings/iso
/main/imgsettings/whitebalance
/main/imgsettings/photoeffect
/main/capturesettings/zoom
/main/capturesettings/assistlight
/main/capturesettings/exposurecompensation
/main/capturesettings/canonflashmode
/main/capturesettings/aperture
/main/capturesettings/focusingpoint
/main/capturesettings/shutterspeed
/main/capturesettings/meteringmode
/main/capturesettings/afdistance

...as soon as I plug in the camera in gphoto asks if I want to download the photos.  I can --set-config capture=on, and the camera lens extends, but the driver aparently does not support capture. Have I missed something? is there another program or driver that will work?  Am I in the right place? I think this camera is a v4l device!  I'm runnin 64studio on x386 Thank You

_____________________________________________________________
Get your FREE, LinuxWaves.com Email Now! --> http://www.LinuxWaves.com
Join Linux Discussions! --> http://Community.LinuxWaves.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
