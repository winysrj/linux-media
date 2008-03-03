Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m23L8B3Q007100
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 16:08:11 -0500
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.238])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m23L7dqh025147
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 16:07:40 -0500
Received: by wr-out-0506.google.com with SMTP id c49so419651wra.21
	for <video4linux-list@redhat.com>; Mon, 03 Mar 2008 13:07:39 -0800 (PST)
Date: Mon, 3 Mar 2008 13:06:50 -0800
From: Brandon Philips <brandon@ifup.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Message-ID: <20080303210650.GA16515@plankton.ifup.org>
References: <47C14336.9030903@gmail.com> <20080226163918.GB9178@plankton>
	<20080227061107.2d5f9fc1@areia>
	<200803021242.58744.tobias.lorenz@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803021242.58744.tobias.lorenz@gmx.net>
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

On 12:42 Sun 02 Mar 2008, Tobias Lorenz wrote:
> Additionally these parameters are only used by the seek algorithm: -
> RSSI Seek Threshold (range: 0..254, 254=highest threshold) -
> Signal-Noise-Ratio (range: 0..15, 15=higest SNR ratio) - FM-Impulse
> Noise Detection Counter (range: 0..15, 15=best audio quality)
> 
> Propably it is wise to give the user space applications the possiblity
> to change these parameters at run time (ioctl).  
>
> Else I'll implement them as module parameters, too.

Please don't implement things like this as module parameters.  What
happens when you have two device plugged in and want different values?

Example case: Drivers that use module parameters for devices without
EEPROMs.  What happens when I have two different models without EEPROMs
in my box at the same time.

It would be far better to see these things defined per device in sysfs
if you can't manage an IOCTL.  However, in this case it should be an
IOCTL. 

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
