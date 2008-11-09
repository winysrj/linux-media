Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9NaZN2004952
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 18:36:35 -0500
Received: from www.tglx.de (www.tglx.de [62.245.132.106])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9NX808008393
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 18:33:09 -0500
Date: Mon, 10 Nov 2008 00:32:59 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: urpion urpion <urpion@linuxwaves.com>
Message-ID: <20081109233259.GB2974@local>
References: <20081106040617.69FB8454@resin09.mta.everyone.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106040617.69FB8454@resin09.mta.everyone.net>
Cc: video4linux-list@redhat.com
Subject: Re: Canon Powershot S80 Remote Capture ability
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

On Thu, Nov 06, 2008 at 04:06:17AM -0800, urpion urpion wrote:
> I am trying to access the remote capture ability of of a Canon Powershot S80 digital camera

[...]

> ... Am I in the right place? I think this camera is a v4l device!

Nope. gphoto2 (or better, libgphoto2) talks to your camera using
protocols like PTP or MTP through USB. You should probably ask the
gphoto2 community. They've got their own mailing lists:

http://www.gphoto.org/mailinglists/

Thanks,
Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
