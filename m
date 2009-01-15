Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FMNChM026909
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 17:23:12 -0500
Received: from iamta51.mxsweep.com (mail151.ix.emailantidote.com
	[89.167.219.151])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0FMMwPg004797
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 17:22:59 -0500
Message-ID: <496FB713.5020609@draigBrady.com>
Date: Thu, 15 Jan 2009 22:22:11 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
To: Carsten Meier <cm@trexity.de>
References: <20090115163348.5da9932a@tuvok>	<09CD2F1A09A6ED498A24D850EB10120817E30B7506@Colmatec004.COLMATEC.INT>
	<20090115175121.25c4bdaa@tuvok>
In-Reply-To: <20090115175121.25c4bdaa@tuvok>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: How to identify USB-video-devices
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

Carsten Meier wrote:
> Storing device-file-names is also not an option because they are
> created dynamicly.

You use udev rules to give persistent names.

Here is my /etc/udev/rules.d/video.rules file,
which creates /dev/webcam and /dev/tvtuner as appropriate.

KERNEL=="video*" SYSFS{name}=="USB2.0 Camera", NAME="video%n", SYMLINK+="webcam"
KERNEL=="video*" SYSFS{name}=="em28xx*", NAME="video%n", SYMLINK+="tvtuner"

To find distinguishing attributes to match on use:

echo /sys/class/video4linux/video* | xargs -n1 udevinfo -a -p

cheers,
Pádraig.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
