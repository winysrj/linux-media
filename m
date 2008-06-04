Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m54HOlkh007492
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 13:24:47 -0400
Received: from web903.biz.mail.mud.yahoo.com (web903.biz.mail.mud.yahoo.com
	[216.252.100.43])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m54HOYgU006348
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 13:24:34 -0400
Date: Wed, 4 Jun 2008 19:24:28 +0200 (CEST)
From: Markus Rechberger <mrechberger@empiatech.com>
To: ralf@ark.in-berlin.de, Andres Suarez <andrestepeite@yahoo.com.mx>
In-Reply-To: <20080604070625.GA304@ark.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <472733.34978.qm@web903.biz.mail.mud.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: Need help choosing a camera.
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


--- Ralf Stephan <ralf@ark.in-berlin.de> schrieb:

> Andres Suarez wrote 
> > I need to build a machine vision system, I think
> it would be very useful
> > to have a well suported good quality USB camera
> for that purpose (i.e.
> > if I could focus using software it would be
> great). I would appreciate A
> > LOT some advice about the right model to choose.
> 
> While I can't comment on cameras that are especially
> fit for
> machine vision purposes, the problem is not the
> camera itself
> since most cameras have Cinch/Chinch/Scart/Analog
> Video(AV)
> output, or you use an adapter. The problem is the
> right
> AV-to-USB-converter, and this is one topic of this
> list, as
> I can understand it, after a few weeks.
> 
> One caveat I found is not to blindly buy any
> Hauppauge USB stick
> (as I did with the 40240) because only USB 2.0
> sticks are
> supported by the em28xx driver. That leaves you with
> the models
> HVR 900 and 1300.
> 
> Did I write anything stoopid?
> 

yes em28xx based devices only support USB 2.0 with
full quality.

-Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
