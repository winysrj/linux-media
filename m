Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8CD9hGh001975
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 09:09:43 -0400
Received: from smtp-vbr13.xs4all.nl (smtp-vbr13.xs4all.nl [194.109.24.33])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8CD9W6A022434
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 09:09:32 -0400
Message-ID: <25482.208.105.65.130.1221224970.squirrel@webmail.xs4all.nl>
Date: Fri, 12 Sep 2008 15:09:30 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Christian Gmeiner" <christian.gmeiner@gmail.com>,
	video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: Extending current adv717x drivers
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

Hi Christian,

> Hi all,
>
> I am one of the supporters of the dxr3 drivers for Linux [0]. The big
> goal is it to get the driver ready
> for the mainline kernel.

Very nice!

> As this needs lot of work to be done, I will
> start with one of the top items
> of my todo list. Extending current adv717x drivers with new functionality.
>
> As you can see here [1] and [2] the adv717x driver offers some more
> functions, which are needed
> for the dxr3 driver - e.g. switching pixel port between 8-bit
> multiplexed YCrCb and 16 bit YCrCb.
>
> The current drivers used v4l1 include and so I had a look at the v4l2
> api but I am not sure how such
> a driver can be switched to v4l2. If this is not the case, whats the
> best way to "merge" dxr3s driver
> with the in-kernel driver?

Your timing is most unfortunate. I'm pretty much the contact for helping
you doing this. However, I'm travelling abroad and do not have the time or
resources to assist you until I return at the end of the month.

I do know that this tree:

http://linuxtv.org/hg/~mchehab/decoders/

already contains an old attempt at converting these drivers to v4l2.

The core problem are the zoran drivers: they are in need of an overhaul
and a full conversion to v4l2. Bits and pieces of such work are in several
places, but no one had the time to pull it all together. I want to do it,
but I doubt I will have time to do that before November. Unless someone
else is willing to work on the zoran drivers.

I think you should just use the version of adv717x that dxr3 is using for
the time being and concentrate on the other parts of the dxr3 merge. There
is no doubt enough to do.

Regards,

      Hans

>
> [0] http://dxr3.sf.net
> [1]
> http://dxr3.sourceforge.net/hg/em8300-nboullis/file/37328a436d49/modules/adv717x.c
> [2]
> http://dxr3.sourceforge.net/hg/em8300-nboullis/file/37328a436d49/modules/adv717x.h
>
>
> Thanks for your help,
> --
> BSc, Christian Gmeiner
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
