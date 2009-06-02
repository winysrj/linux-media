Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n52LRwUD021155
	for <video4linux-list@redhat.com>; Tue, 2 Jun 2009 17:27:58 -0400
Received: from relay-pt2.poste.it (relay-pt2.poste.it [62.241.5.253])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n52LR9Nx026725
	for <video4linux-list@redhat.com>; Tue, 2 Jun 2009 17:27:33 -0400
Received: from geppetto.reilabs.com (78.15.188.69) by relay-pt2.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 4A245DBE00007FE4 for video4linux-list@redhat.com;
	Tue, 2 Jun 2009 23:27:09 +0200
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1MBbUK-0005xH-SL
	for video4linux-list@redhat.com; Tue, 02 Jun 2009 23:25:40 +0200
Date: Tue, 2 Jun 2009 23:25:40 +0200
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: video4linux-list@redhat.com
Message-ID: <20090602212540.GA22683@geppetto>
References: <c0bb0a707b4a3686331865c42cc1694d@kinuxlinux.org>
	<5e9665e10904282024g7e9df63fq182d868380945f29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e9665e10904282024g7e9df63fq182d868380945f29@mail.gmail.com>
Subject: Re: Record a capture
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

On date Wednesday 2009-04-29 12:24:37 +0900, Dongsoo, Nathaniel Kim wrote:
> Hello,
> 
> I think you can take a look at gstreamer and some plugins like ffmpeg
> or something.
> Here it is the URL : http://www.gstreamer.net/
> Cheers,
> 
> Nate
> 
> On Wed, Apr 29, 2009 at 3:14 AM,  <gabrield@kinuxlinux.org> wrote:
> > Hello All!
> > I'd like to know how I can record in a file (such as an .avi, .ogv, so on)
> > what I'm capturing. I already have an application that capture and show it
> > in a window, my next step will be save this capture in a file. Anyone can
> > help?

ffmpeg can do that:
ffmpeg -f video4linux2 -s WxH /dev/video out.avi

[...]

Regards.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
