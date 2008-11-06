Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA60BZO1010938
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 19:11:35 -0500
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA60BL2J007403
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 19:11:22 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: picciuX <matteo@picciux.it>, Ricardo Cerqueira <v4l@cerqueira.org>
In-Reply-To: <c41ce8440811040609v591ae268y80d6669dccf55862@mail.gmail.com>
References: <c41ce8440810310231gdb614bcred3f4386de883abb@mail.gmail.com>
	<1225586521.2642.7.camel@pc10.localdom.local>
	<c41ce8440811040609v591ae268y80d6669dccf55862@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 01:09:31 +0100
Message-Id: <1225930171.3338.8.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Pinnacle PCTV 310i Remote: i2c 'ERROR: NO_DEVICE'
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

Hi Matteo,

Am Dienstag, den 04.11.2008, 15:09 +0100 schrieb picciuX:
> 2008/11/2 hermann pitton <hermann-pitton@arcor.de>:
> 
> > don't have that remote, but also enable ir-kbd-i2c debug=1.
> >
> > ir-kbd-i2c: probe 0x7a @ saa7133[0]: no
> > ir-kbd-i2c: probe 0x47 @ saa7133[0]: no
> > ir-kbd-i2c: probe 0x71 @ saa7133[0]: no
> > ir-kbd-i2c: probe 0x2d @ saa7133[0]: no
> > ir-kbd-i2c: probe 0x7a @ saa7133[1]: no
> > ir-kbd-i2c: probe 0x47 @ saa7133[1]: no
> > ir-kbd-i2c: probe 0x71 @ saa7133[1]: no
> > ir-kbd-i2c: probe 0x2d @ saa7133[1]: no
> >
> > You should have the device found at 0x47.
> >
> 
> In fact i see:
> 
> ir-kbd-i2c: probe 0x47 @ saa7133[0]: yes
> 
> So everything seemed to go well. But, same story for the rest: ERROR:
> NO_DEVICE when i press buttons on the remote.
> What seems strange to me is the fact that the driver *reacts* to
> remote key presses, but reacts with an error.
> 
> Cheers
> Matteo
> 

since you reported the trouble was already visible for you on earlier
kernels, we might try to get a second confirmation at first.

Anyone out there? I'm sending a copy to Ricardo too, who added the
support, not sure if he currently has time to read the list.

Cheers,
Hermann





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
