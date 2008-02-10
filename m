Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1AG31oP013744
	for <video4linux-list@redhat.com>; Sun, 10 Feb 2008 11:03:01 -0500
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.189])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1AG2bQ5004767
	for <video4linux-list@redhat.com>; Sun, 10 Feb 2008 11:02:39 -0500
Received: by rv-out-0910.google.com with SMTP id k15so3254604rvb.51
	for <video4linux-list@redhat.com>; Sun, 10 Feb 2008 08:02:36 -0800 (PST)
Message-ID: <18b102300802100802p282b6d4fs4f45822b29d6d3d2@mail.gmail.com>
Date: Sun, 10 Feb 2008 11:02:36 -0500
From: "James Klaas" <jklaas@appalachian.dyndns.org>
To: video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <18b102300802100801h295d15aan810313ae18c6fb6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18b102300801311533y65b32651v651e853ae3aea3d4@mail.gmail.com>
	<20080201001958.GA21437@plankton.ifup.org>
	<18b102300802011808w7a0ac750qf491d1aaa59efca3@mail.gmail.com>
	<20080207233507.GA21273@plankton.ifup.org>
	<18b102300802100801h295d15aan810313ae18c6fb6b@mail.gmail.com>
Subject: gspca drivers
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

Sorry, forgot to send to video4linux list as well.

---------- Forwarded message ----------
From: James Klaas <jklaas@appalachian.dyndns.org>
Date: Feb 10, 2008 11:01 AM
Subject: Re: gspca drivers
To: Brandon Philips <brandon@ifup.org>


On 2/7/08, Brandon Philips <brandon@ifup.org> wrote:
> On 21:08 Fri 01 Feb 2008, James Klaas wrote:
> > On 1/31/08, Brandon Philips <brandon@ifup.org> wrote:
> > > On 18:33 Thu 31 Jan 2008, James Klaas wrote:
> > > > I was hoping to get my webcam working with the latest v4l-dvb sources.
> > > >  After reading about on this list and elsewhere, I ran:
> > > >
> > > > # make kernel-links
> > > >
> > > > from my v4l-dvb directory in order to modify my current linux sources
> > > > to use the v4l-dvb drivers.  Then I went to my gspca directory and ran
> > > > the "gspca_build" script:
> > > >
> > > > ./gspca_build
> > > >
> > > >  REMOVE the old module if present
> > > > Unknown symbol in module, or unknown parameter (see dmesg)
> > > >
> > > >  PRINT COMPILATION MESSAGES if ERRORS look kgspca.err
> > > > make -C /lib/modules/`uname -r`/build SUBDIRS=/usr/src/modules/gspca
> > > > CC=cc modules
> > > > make[1]: Entering directory `/usr/src/linux-source-2.6.22'
> > > >   CC [M]  /usr/src/modules/gspca/gspca_core.o
> > > > /usr/src/modules/gspca/gspca_core.c:2542: error: unknown field
> > > > 'hardware' specified in initializer
> > >
> > > Are you using the latest gspca driver?  The hardware field was removed
> > > months ago.
> >
> > [ 1026.765596] gspca: disagrees about version of symbol video_devdata
> ...
> > [ 1977.737339] gspca: Unknown symbol video_device_release
>
> Did you "make install" the v4l tree you built against and make sure none
> of the old video modules were loaded (see lsmod) when you modprobe'd
> gspca?
>
> Thanks,
>
>         Brandon
>

I checked the installed versions of videodev and gspca and both are
the same versions as the versions in the build directories, so they
installed fine.  I also checked the depends for videodev, v4l2-common
and v4l1-compat, and those were also the correct versions.

I double checked to make sure there weren't any modules left over in
other directories in /lib/modules/`uname -r` and didn't find any.

Since the machine in question also has a PCI video4linux device in it,
the drivers for that card already load the videodev modules.

James

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
