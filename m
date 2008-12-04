Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB42mZC9011108
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 21:48:35 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB42mKXH016536
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 21:48:20 -0500
From: Andy Walls <awalls@radix.net>
To: Mark Jenks <mjenks1968@gmail.com>
In-Reply-To: <e5df86c90812031712oa73fb5av3a4b239ae0b5f76e@mail.gmail.com>
References: <e5df86c90811291616s65209d26q3471213958bdfde6@mail.gmail.com>
	<de8cad4d0812022114n11544dc1ve8fbca5d2d21eb57@mail.gmail.com>
	<e5df86c90812030409m736a45b1xb851b01e349d23eb@mail.gmail.com>
	<de8cad4d0812031245n5a47c330o5fe1fafa52703820@mail.gmail.com>
	<e5df86c90812031712oa73fb5av3a4b239ae0b5f76e@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 21:50:12 -0500
Message-Id: <1228359012.3104.64.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: S-Video analog Capture.
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

On Wed, 2008-12-03 at 19:12 -0600, Mark Jenks wrote:
> On Wed, Dec 3, 2008 at 2:45 PM, Brandon Jenkins <bcjenkins@tvwhere.com>wrote:
> 
> > On Wed, Dec 3, 2008 at 7:09 AM, Mark Jenks <mjenks1968@gmail.com> wrote:
> > > No, I don't need PCI, PCIe is just what I had room for and bought it.
> > The
> > > Backend is sitting in a media closet, so it's a fullsize case. ;)
> > >
> > > So, with the 1600, Svideo in, w/ Audio interleaved in mpg format, you say
> > it
> > > works?
> > >
> > > Can anyone verify this, before I go out and purchase this, or a PVR-250.
> > >
> > > -Mark
> > >
> >
> > I run three of them using DCT700 set top boxes on Verizon FiOS. (Note:
> > I use CommandIR II for control) via svideo and r/l minijack inputs.
> > This is in SageTV though, if that matters.
> >
> > Brandon
> 
> 
> No, that does not matter, as long as you can catch a mpeg stream, it should
> work just fine.   I already have 1394 channel changing working without a
> hitch.

Mark,

Just to manage expectations, you may want to read the ivtv-users and
ivtv-driver mailing list archive for the past month or so.  Some users
have absolutely no problems.  Others have noticed some audio or video
playback annoyances with analog captures (which I am working to get
resolved).

Personally, I like my HVR-1600's and don't have problems with analog and
digital tuner captures.  I don't use S-Video or CVBS composite
regularly.  You will need to do buffered playback, which MythTV does
always, and mplayer does when you use the '-cache 8192' commandline
option.  (I'm hoping to resolve the need for that too.)


> Time to hunt out a 1600.

NewEgg or e-Bay. :)

Regards,
Andy


> -Mark

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
