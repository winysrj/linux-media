Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m281SerW032502
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 20:28:40 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m281S8nP020575
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 20:28:09 -0500
Received: by wa-out-1112.google.com with SMTP id j37so704286waf.7
	for <video4linux-list@redhat.com>; Fri, 07 Mar 2008 17:28:08 -0800 (PST)
Date: Fri, 7 Mar 2008 17:27:55 -0800
From: Brandon Philips <brandon@ifup.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Message-ID: <20080308012755.GC8081@plankton.ifup.org>
References: <47C14336.9030903@gmail.com> <20080304104706.38666b7d@gaivota>
	<47D11BC9.2060307@gmail.com>
	<200803072105.08054.tobias.lorenz@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803072105.08054.tobias.lorenz@gmx.net>
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] v4l2: add hardware frequency seek
	ioctl interface
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

On 21:05 Fri 07 Mar 2008, Tobias Lorenz wrote:
> If a specific version is available to support the device's hardware
> seek functionality, then that's fine and we use it.  If the hardware
> doesn't support seek operations, then we have the compatibility
> function, that executes the usual "tune and check for signal strength"
> operation, as currently done in every application.  So we basically
> should move the functionality from the application to the kernel.

Please don't emulate hardware features in the Kernel.  

The V4L layer should do its best to expose all features of a device.
However, if a device needs emulation, translation or conversion of any
sort it should be done in userspace- preferably in a library.

Plus, I am sure the application developers would love to see a libradio
for V4L radio devices to simplify their apps :D

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
