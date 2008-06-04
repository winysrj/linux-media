Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5478kZp004087
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 03:08:46 -0400
Received: from hirsch.in-berlin.de (hirsch.in-berlin.de [192.109.42.6])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m54783vi027454
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 03:08:03 -0400
Date: Wed, 4 Jun 2008 09:06:25 +0200
From: Ralf Stephan <ralf@ark.in-berlin.de>
To: Andres Suarez <andrestepeite@yahoo.com.mx>
Message-ID: <20080604070625.GA304@ark.in-berlin.de>
References: <20080603160014.D7A2A8E002E@hormel.redhat.com>
	<1212533424.7582.13.camel@pc2008>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212533424.7582.13.camel@pc2008>
Cc: video4linux-list@redhat.com
Subject: Re: Need help choosing a camera.
Reply-To: ralf@ark.in-berlin.de
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

Andres Suarez wrote 
> I need to build a machine vision system, I think it would be very useful
> to have a well suported good quality USB camera for that purpose (i.e.
> if I could focus using software it would be great). I would appreciate A
> LOT some advice about the right model to choose.

While I can't comment on cameras that are especially fit for
machine vision purposes, the problem is not the camera itself
since most cameras have Cinch/Chinch/Scart/Analog Video(AV)
output, or you use an adapter. The problem is the right
AV-to-USB-converter, and this is one topic of this list, as
I can understand it, after a few weeks.

One caveat I found is not to blindly buy any Hauppauge USB stick
(as I did with the 40240) because only USB 2.0 sticks are
supported by the em28xx driver. That leaves you with the models
HVR 900 and 1300.

Did I write anything stoopid?


ralf

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
