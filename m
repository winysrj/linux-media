Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5TL4Z0F012580
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 17:04:35 -0400
Received: from yop.chewa.net (yop.chewa.net [91.121.105.214])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5TL3owL004727
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 17:03:50 -0400
Date: Sun, 29 Jun 2008 23:03:49 +0200
From: Antoine Cellerier <dionoea@videolan.org>
To: video4linux-list@redhat.com
Message-ID: <20080629210349.GA26587@chewa.net>
References: <4867F380.1040803@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4867F380.1040803@hhs.nl>
Subject: Re: Announcing libv4l 0.3.1 aka "the vlc release"
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

On Sun, Jun 29, 2008, Hans de Goede wrote:
> * Do not return an uninitialized variable as result code for GPICT
>   (fixes vlc, but see below)
> * Add a patches directory which includes:
>   * vlc-0.8.6-libv4l1.patch, modify vlc's v4l1 plugin to directly call into
>     libv4l1, in the end we want all apps todo this as its better then
>     LD_PRELOAD tricks, but for vlc this is needed as vlc's plugin system
>     causes LD_PRELOAD to not work on symbols in the plugins

You might want to submit those VLC specific patches upstream ...

-- 
Antoine Cellerier
dionoea

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
