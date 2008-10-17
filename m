Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9HE9sxF010513
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 10:09:54 -0400
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9HE9oR4007109
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 10:09:50 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 1614912E27E0
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 15:09:50 +0100 (BST)
Received: from ian.pickworth.me.uk ([127.0.0.1])
	by localhost (ian.pickworth.me.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i1RDBnk28UnE for <video4linux-list@redhat.com>;
	Fri, 17 Oct 2008 15:09:49 +0100 (BST)
Received: from [192.168.1.11] (ian2.pickworth.me.uk [192.168.1.11])
	by ian.pickworth.me.uk (Postfix) with ESMTP id DF46112D0C12
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 15:09:49 +0100 (BST)
Message-ID: <48F89CAD.5080202@pickworth.me.uk>
Date: Fri, 17 Oct 2008 15:09:49 +0100
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
References: <48F895F9.5010205@pickworth.me.uk>
	<48F89A75.1000100@draigBrady.com>
In-Reply-To: <48F89A75.1000100@draigBrady.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: How to force the device assignment with V4l V2.0?
Reply-To: ian@pickworth.me.uk
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

Pádraig Brady wrote:
> Ian Pickworth wrote:
>> I have two devices - a CX88 based Hauppauge TV PCI card, and a USB
>> webcam. In the "old" style drivers, I could force the loading of the two
>> modules (cx8800 and gspca) in a set sequence, using blacklist and
>> modules.autoload. This is enough to ensure that cx88 gets /dev/video0,
>> and the usb webcam gets /dev/video1.
> 
> I use udev rules to give persistent names.
> 
> Here is my /etc/udev/rules.d/video.rules file,
> which creates /dev/webcam and /dev/tvtuner as appropriate.
> 
> KERNEL=="video*" SYSFS{name}=="USB2.0 Camera", NAME="video%n", SYMLINK+="webcam"
> KERNEL=="video*" SYSFS{name}=="em28xx*", NAME="video%n", SYMLINK+="tvtuner"
> 
> To find distinguishing attributes to match on use:
> 
> echo /sys/class/video4linux/video* | xargs -n1 udevinfo -a -p

I did think about that, but the problem is that applications want to see
/dev/video(n) style names. Especially TV Time that (I think) uses
/dev/video - set to link to /dev/video0 by the standard udev rules.

I could be wrong - how does one get these programs to recognize the
custom links created by udev rules? Or, is it possible to get udev to
change /dev/video(n) assignment based on udev rules? I'm thinking not,
since one of the things you can match on is KERNEL.

Regards
Ian

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
