Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52537 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1GYCpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 22:45:03 -0400
Received: by fxd18 with SMTP id 18so8235897fxd.11
        for <linux-media@vger.kernel.org>; Sun, 24 Jul 2011 19:45:01 -0700 (PDT)
MIME-Version: 1.0
From: Dave Fine <finerrecliner@gmail.com>
Date: Sun, 24 Jul 2011 22:44:41 -0400
Message-ID: <CAOMmEg=SRi64zgSebzBpVTaur-k4_2QEyqvsbXbkA9sGyWO8Zg@mail.gmail.com>
Subject: webcam doesn't work on some USB ports (gspca_sonixj module)
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a Microsoft LifeCam VX-3000. My desktop computer has two USB
buses. 4 external ports on one bus in the back of the computer, and 2
external ports on another bus in the front. The webcam only works
properly on the front-facing ports. I'm using the lastest stable
release of the gspca_sonixj module.

The problems I experience is that the webcam is not able to work with
Google's gchat video chatting. The screen remains black for a few
seconds, before fading to gray. Sometimes I see myself for a
split-second before it fades to gray permanently. The webcam always
work fine with local programs like cheese.

syslog output:

webcam plugged into "bad" USB bus:

Jul 24 22:09:22 Bluemoon kernel: [432235.451132] usb 1-1.3: new full
speed USB device using ehci_hcd and address 10
Jul 24 22:09:22 Bluemoon kernel: [432235.562660] gspca-2.13.2: probing 045e:00f5
Jul 24 22:09:22 Bluemoon kernel: [432235.563467] sonixj-2.13.2: Sonix
chip id: 11
Jul 24 22:09:22 Bluemoon kernel: [432235.564042] input: sonixj as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/input/input17
Jul 24 22:09:22 Bluemoon kernel: [432235.564178] gspca-2.13.2: video0 created
Jul 24 22:09:22 Bluemoon rtkit-daemon[1365]: Successfully made thread
9824 of process 1506 (n/a) owned by '1000' RT at priority 5.
Jul 24 22:09:22 Bluemoon rtkit-daemon[1365]: Supervising 4 threads of
1 processes of 1 users.
Jul 24 22:09:40 Bluemoon kernel: [432253.344199] gspca-2.13.2:
bandwidth not wide enough - trying again
Jul 24 22:09:41 Bluemoon kernel: [432254.622338] gspca-2.13.2:
bandwidth not wide enough - trying again
Jul 24 22:09:42 Bluemoon kernel: [432255.900844] gspca-2.13.2:
bandwidth not wide enough - trying again
Jul 24 22:09:44 Bluemoon kernel: [432257.179608] gspca-2.13.2:
bandwidth not wide enough - trying again
Jul 24 22:09:45 Bluemoon kernel: [432258.457975] gspca-2.13.2:
bandwidth not wide enough - trying again
... (repeats)



webcam plugged into "good" USB bus:
Jul 24 22:06:47 Bluemoon kernel: [432080.751839] usb 2-1.4: new full
speed USB device using ehci_hcd and address 9
Jul 24 22:06:47 Bluemoon kernel: [432080.863272] gspca-2.13.2: probing 045e:00f5
Jul 24 22:06:47 Bluemoon kernel: [432080.863943] sonixj-2.13.2: Sonix
chip id: 11
Jul 24 22:06:47 Bluemoon kernel: [432080.864304] input: sonixj as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/input/input15
Jul 24 22:06:47 Bluemoon kernel: [432080.864578] gspca-2.13.2: video0 created
Jul 24 22:06:47 Bluemoon rtkit-daemon[1365]: Successfully made thread
9637 of process 1506 (n/a) owned by '1000' RT at priority 5.
Jul 24 22:06:47 Bluemoon rtkit-daemon[1365]: Supervising 4 threads of
1 processes of 1 users.
Jul 24 22:07:22 Bluemoon kernel: [432116.213808] gspca-2.13.2:
bandwidth not wide enough - trying again
Jul 24 22:07:24 Bluemoon kernel: [432117.542586] gspca-2.13.2:
bandwidth not wide enough - trying again
Jul 24 22:07:25 Bluemoon kernel: [432118.831024] gspca-2.13.2:
bandwidth not wide enough - trying again
(webcam operates normally at this point)


Has anyone seen this before? Any suggestions to help debug this?

-Dave
