Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUK74md010811
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 15:07:04 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBUK5rSn004061
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 15:05:53 -0500
Received: by rv-out-0506.google.com with SMTP id f6so5612590rvb.51
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 12:05:52 -0800 (PST)
From: Alex Teiche <xelapond@gmail.com>
To: Jim Paris <jim@jtan.com>
In-Reply-To: <20081229205154.GB9421@psychosis.jim.sh>
References: <99cd09480812272114n356fd157o5a416b46e1723250@mail.gmail.com>
	<20081229205154.GB9421@psychosis.jim.sh>
Content-Type: text/plain
Date: Tue, 30 Dec 2008 15:05:46 -0500
Message-Id: <1230667546.6877.6.camel@Andromeda>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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

>Jim Paris wrote:
> >xelapond wrote:
> > alex@Andromeda:~$ mplayer -vo ov534 -ao alsa -tv driver=v4l2:device=/dev/video0 tv://
> 
> Hi Alex,
> 
> As Antonio mentioned, remove '-vo ov534' and it should work.
> 
Thank you both for your replies, I got it to work with the following
command:

mplayer -vo gl -ao alsa -fps 50  -tv driver=v4l2:device=/dev/video0
tv://

> > Any ideas how I can get this to work?  Ultimately I would like to be able to
> > use the camera within openFrameworks, which uses unicap.
> 
> I tested unicap using ucview and it works with the Playstation Eye
> just fine.

How were you able to get this to work?  On my machine ucview complains
it can't start the video signal, and just shows me a yellow screen.
Here are the errors:

(ucview:26333): GConf-CRITICAL **: gconf_client_set_string: assertion
`val != NULL' failed

** (ucview:26333): WARNING **: Failed to start video capture


Any ideas?  This is the first time Google has ever failed me in
searching for errors, it returned literally no results.

I'm really sorry if this got posted twice, I was using the GMail online
client, which isn't the best for mailing lists:)  I'm now using
Thunderbird, so it should be OK.

Thanks!

~Alex

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
