Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n162A5JI024072
	for <video4linux-list@redhat.com>; Thu, 5 Feb 2009 21:10:05 -0500
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1629nKW020291
	for <video4linux-list@redhat.com>; Thu, 5 Feb 2009 21:09:50 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Yves Le Feuvre <yves.lefeuvre@inserm.fr>
In-Reply-To: <1233885291.2689.22.camel@pc10.localdom.local>
References: <497979FF.5090600@inserm.fr>
	<1232755686.5451.7.camel@pc10.localdom.local>	<497D71BB.4050306@inserm.fr>
	<1233179327.4396.42.camel@pc10.localdom.local>
	<4982B64C.3010608@inserm.fr> <4989A883.8050305@inserm.fr>
	<1233885291.2689.22.camel@pc10.localdom.local>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 03:10:29 +0100
Message-Id: <1233886229.2689.33.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: asus Europa2 OEM regression ?
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


Am Freitag, den 06.02.2009, 02:54 +0100 schrieb hermann pitton:
> Hi,
> 
> Am Mittwoch, den 04.02.2009, 15:38 +0100 schrieb Yves Le Feuvre:
> > Hi,
> > 
> > What should I try next ? I'll try to hack the driver source code, but my 
> > knowledge in linux drivers and v4l is very limited...
> > If you have some ideas where to start, they will be welcome.
> > 
> > yves
> 
> I don't understand it at this point for now.
> 
> The tuner in digital mode takes the instructions.
> 
> There is another clash between digital and analog again.
> 

Forgot to mention, the card specific tda9887 settings seem to not work
anymore after we fixed the tuner eeprom detection.

Do we fail here already with the need of the i2c_gate enabled to the
tuner by the tda10046 for this one?

We need some clean up here, the plan was to have the tda9887 config on
tuner-types, or even in user space ...

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
