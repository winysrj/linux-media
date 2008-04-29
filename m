Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3TMh6T3029166
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 18:43:06 -0400
Received: from mylar.outflux.net (mylar.outflux.net [69.93.193.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3TMgt5t009357
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 18:42:55 -0400
Date: Tue, 29 Apr 2008 15:42:41 -0700
From: Kees Cook <kees@outflux.net>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080429224241.GJ12850@outflux.net>
References: <20080417012354.GH18929@outflux.net>
	<200804212310.47130.laurent.pinchart@skynet.be>
	<20080421214717.GJ18865@outflux.net>
	<200804250055.45118.laurent.pinchart@skynet.be>
	<20080428072655.GB782@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428072655.GB782@plankton.ifup.org>
Cc: video4linux-list@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] v4l: Introduce "stream" attribute for persistent
	video4linux device nodes
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

Hi,

On Mon, Apr 28, 2008 at 12:26:55AM -0700, Brandon Philips wrote:
> Kees introduced a patch set last week that attempts to get stable device naming
> for v4l.  The set used a string attribute called function to allow udev to
> assemble a unique and stable path for device nodes.

Just a quick correction: that patch was 99% Kay's.  :)  I just jammed
stuff into individual drivers, and have been trying to run with it.
Thanks for cooking up an alternative we can poke at.  :)

> This patch is similar.  However, instead of a string an integer is used called
> "stream".  If the driver calls video_register_device in the same order every
> time it is loaded then we can end up with something like this with the right
> udev rules[1]:
> 
> /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video0
> /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video1
> /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video2

This would certainly work for me, and is much cleaner as far as not
needing to change each v4l device driver.  I do remember Kay objecting
to the idea of internal driver enumeration being exported to udev, but
I'll let him speak up if this method is a problem too.  :)

> Kees: I don't have a device that creates multiple device nodes.  Please
> test with ivtv.  :D

If Kay ACKs it, I will give it a spin -- I would expect it to run just
fine, though.  :)

-Kees

-- 
Kees Cook                                            @outflux.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
