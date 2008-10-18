Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9I4vuox009798
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 00:58:06 -0400
Received: from hs-out-0708.google.com (hs-out-0708.google.com [64.233.178.241])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9I4ubgp020621
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 00:56:58 -0400
Received: by hs-out-0708.google.com with SMTP id x43so334263hsb.3
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 21:56:27 -0700 (PDT)
Message-ID: <8519cbc80810172156r1efbb5c1t6626b21ecf09ef7b@mail.gmail.com>
Date: Fri, 17 Oct 2008 21:56:26 -0700
From: "Brandon Philips" <brandon@ifup.org>
To: ian@pickworth.me.uk
In-Reply-To: <48F895F9.5010205@pickworth.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F895F9.5010205@pickworth.me.uk>
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

On Fri, Oct 17, 2008 at 6:41 AM, Ian Pickworth <ian@pickworth.me.uk> wrote:
> I'm having a play with the latest code from hg on the 2.6.27 kernel,
> Gentoo installation. This is triggered by the gspca driver being
> absorbed into the main tree (which is a great move by the way).
>
> I have two devices - a CX88 based Hauppauge TV PCI card, and a USB
> webcam. In the "old" style drivers, I could force the loading of the two
> modules (cx8800 and gspca) in a set sequence, using blacklist and
> modules.autoload. This is enough to ensure that cx88 gets /dev/video0,
> and the usb webcam gets /dev/video1.
>
> However, when trying a recent hg snapshot, the sequence of loading the
> modules does not change what the V4l driver is doing when loaded.
> Looking at dmesg, I see that the new drivers are doing quite a lot of
> detecting work themselves - it looks like they pick up the USB device
> first regardless of the module blacklist/load sequence I have specified.
>
> So, question is: Is there a preferred way of forcing the sequence of
> device assignment in V4L these days? I need the cx88 to be /dev/video0
> and the USB webcam to be /dev/video1 - otherwise all sorts of programs
> get confused.

If you have an up to date udev you should have rules that creates
persistent symlinks in /dev/v4l/by-path/

See the patches and rules here:
http://marc.info/?l=linux-video&m=120936768608839&w=2

Cheers,

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
