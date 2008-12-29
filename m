Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBTKrBEx026661
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 15:53:11 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBTKqwGI002999
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 15:52:58 -0500
Date: Mon, 29 Dec 2008 15:51:54 -0500
From: Jim Paris <jim@jtan.com>
To: xelapond <xelapond@gmail.com>
Message-ID: <20081229205154.GB9421@psychosis.jim.sh>
References: <99cd09480812272114n356fd157o5a416b46e1723250@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99cd09480812272114n356fd157o5a416b46e1723250@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: PS3Eye on Debian
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

xelapond wrote:
> alex@Andromeda:~$ mplayer -vo ov534 -ao alsa -tv driver=v4l2:device=/dev/video0 tv://

Hi Alex,

As Antonio mentioned, remove '-vo ov534' and it should work.

> Any ideas how I can get this to work?  Ultimately I would like to be able to
> use the camera within openFrameworks, which uses unicap.

I tested unicap using ucview and it works with the Playstation Eye
just fine.

-jim

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
