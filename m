Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA6208hh017560
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 21:00:08 -0500
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA61waMu018202
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 20:58:37 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Ricardo Cerqueira <v4l@cerqueira.org>
In-Reply-To: <1225932395.13472.19.camel@frolic>
References: <c41ce8440810310231gdb614bcred3f4386de883abb@mail.gmail.com>
	<1225586521.2642.7.camel@pc10.localdom.local>
	<c41ce8440811040609v591ae268y80d6669dccf55862@mail.gmail.com>
	<1225930171.3338.8.camel@pc10.localdom.local>
	<1225932395.13472.19.camel@frolic>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 02:56:53 +0100
Message-Id: <1225936613.3602.24.camel@pc10.localdom.local>
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

Hi Ricardo,

Am Donnerstag, den 06.11.2008, 00:46 +0000 schrieb Ricardo Cerqueira:
> Hi all;
> 
> On Thu, 2008-11-06 at 01:09 +0100, hermann pitton wrote:
> > Hi Matteo,
> > 
> > Am Dienstag, den 04.11.2008, 15:09 +0100 schrieb picciuX:
> > > 2008/11/2 hermann pitton <hermann-pitton@arcor.de>:
> > > 
> > > > don't have that remote, but also enable ir-kbd-i2c debug=1.
> > > >
> > > > ir-kbd-i2c: probe 0x7a @ saa7133[0]: no
> > > > ir-kbd-i2c: probe 0x47 @ saa7133[0]: no
> > > > ir-kbd-i2c: probe 0x71 @ saa7133[0]: no
> > > > ir-kbd-i2c: probe 0x2d @ saa7133[0]: no
> > > > ir-kbd-i2c: probe 0x7a @ saa7133[1]: no
> > > > ir-kbd-i2c: probe 0x47 @ saa7133[1]: no
> > > > ir-kbd-i2c: probe 0x71 @ saa7133[1]: no
> > > > ir-kbd-i2c: probe 0x2d @ saa7133[1]: no
> > > >
> 
> 
> Sorry, I missed the rest of the thread;
> 
> In any case, from the above paste, it looks as if you have 2 saa713x
> boards in the system, right?

sorry, that was me to illustrate how the difference should look like.
Must be taken from the quadro md8800 machine.

I'm playing around with some other requests concerning remote behaviors,
but have to admit that getting some old PCs running on recent again is
not that much fun and I'm slow.

We have a case, where Asus stuff is not reliable on PCI subsystem IDs.
We can detect the different cards by a difference in the eeprom readout,
but this needs running i2c on saa7134 init2.

However, since input_init is on saa7134 init1, we fail here being too
late. Maybe we should have input init on saa7134 init2 in saa7134-core.
Roman with such a card mailed to me about that. At least I should be
close to be able to test it, but no i2c remote stuff is here.

> I suspect the bug is somehow related to that (ir-kbd-i2c is getting the
> events, but sending them to the wrong board). Have you tried removing
> one of them?

Maybe the card is even flaky in the PCI slot, that's why a second
confirmation would be nice.

Thanks,
Hermann

> --
> RC
> > > > You should have the device found at 0x47.
> > > >
> > > 
> > > In fact i see:
> > > 
> > > ir-kbd-i2c: probe 0x47 @ saa7133[0]: yes
> > > 
> > > So everything seemed to go well. But, same story for the rest: ERROR:
> > > NO_DEVICE when i press buttons on the remote.
> > > What seems strange to me is the fact that the driver *reacts* to
> > > remote key presses, but reacts with an error.
> > > 
> > > Cheers
> > > Matteo
> > > 
> > 
> > since you reported the trouble was already visible for you on earlier
> > kernels, we might try to get a second confirmation at first.
> > 
> > Anyone out there? I'm sending a copy to Ricardo too, who added the
> > support, not sure if he currently has time to read the list.
> > 
> > Cheers,
> > Hermann
> > 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
