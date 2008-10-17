Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9HE0W8k005144
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 10:00:32 -0400
Received: from mail1.mxsweep.com (mail150.ix.emailantidote.com
	[89.167.219.150])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9HE0Sig001021
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 10:00:28 -0400
Message-ID: <48F89A75.1000100@draigBrady.com>
Date: Fri, 17 Oct 2008 15:00:21 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
To: ian@pickworth.me.uk
References: <48F895F9.5010205@pickworth.me.uk>
In-Reply-To: <48F895F9.5010205@pickworth.me.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: How to force the device assignment with V4l V2.0?
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

Ian Pickworth wrote:
> I have two devices - a CX88 based Hauppauge TV PCI card, and a USB
> webcam. In the "old" style drivers, I could force the loading of the two
> modules (cx8800 and gspca) in a set sequence, using blacklist and
> modules.autoload. This is enough to ensure that cx88 gets /dev/video0,
> and the usb webcam gets /dev/video1.

I use udev rules to give persistent names.

Here is my /etc/udev/rules.d/video.rules file,
which creates /dev/webcam and /dev/tvtuner as appropriate.

KERNEL=="video*" SYSFS{name}=="USB2.0 Camera", NAME="video%n", SYMLINK+="webcam"
KERNEL=="video*" SYSFS{name}=="em28xx*", NAME="video%n", SYMLINK+="tvtuner"

To find distinguishing attributes to match on use:

echo /sys/class/video4linux/video* | xargs -n1 udevinfo -a -p

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
