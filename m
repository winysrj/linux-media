Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAGI3FVD018564
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 13:03:15 -0500
Received: from smtp123.rog.mail.re2.yahoo.com (smtp123.rog.mail.re2.yahoo.com
	[206.190.53.28])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAGI2d0T008312
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 13:02:39 -0500
Message-ID: <4920603D.20906@rogers.com>
Date: Sun, 16 Nov 2008 13:02:37 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Jay Novak <novakjs@umich.edu>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	V4L <video4linux-list@redhat.com>
References: <491CC096.7090107@rogers.com>
	<f3ae23390811140559i5e235c3bvabe8d5004d57165@mail.gmail.com>
In-Reply-To: <f3ae23390811140559i5e235c3bvabe8d5004d57165@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: AVerMedia EZMaker USB Gold
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

Jay Novak wrote:
> >I don't believe there is a driver that supports the 7136 part.
>
> do you know when one is coming? or how hard it world be to developing
> my own is that part that much deferent from the saa713x? Im a computer
> science student at UofM and i think i could help with it with some
> guidance.
>
> Jay Novak
>
> On Thu, Nov 13, 2008 at 7:04 PM, CityK <cityk@rogers.com
> <mailto:cityk@rogers.com>> wrote:
>
>     >
>     > Im using the AVerMedia EZMaker USB Gold it has a SAA7136AE. is
>     there any
>     > support for this device in linux?
>
>     I don't believe there is a driver that supports the 7136 part.
>
>     --
>     video4linux-list mailing list
>     Unsubscribe mailto:video4linux-list-request@redhat.com
>     <mailto:video4linux-list-request@redhat.com>?subject=unsubscribe
>     https://www.redhat.com/mailman/listinfo/video4linux-list
>
>

Hi Jay,

Please make sure to "reply to all" so that the messages don't get
dropped from the list. (also please don't top post)

Re: 7136

Currently there haven't been many reports of devices using this IC. 
Last spring, Janneg obtained a device using the 7136 and this lead to a
brief discussion on irc about it.  IIRC, Manu Abrahams, who had access
to the datasheet at the time and upon a cursory inspection of its info,
thought that it was likely that support for the chip could be
incorporated into the existing 713x driver.  I forget any specifics
about the chip, but I seem to recall that there is something unique
about it.  (I also seem to recall that it has component input that is
good enough for capturing full res HDTV...not that many vendors would
ever implement access to that though).

Anyway, I haven't seen much mention of the chip since, but did happen to
coincidently catch this post just the other day:
* http://marc.info/?l=linux-video&m=122675953217105&w=2
The importance of which becomes clear when seeing:
*
http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Ultimate_Stick_(808e)

So I have cc'ed Devin in on the message as perhaps you two could
collaborate on this, and I imagine Devin would appreciate any help once
all the "fun" legal aspect is settled with NXP.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
