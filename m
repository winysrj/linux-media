Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1B1D1pT003174
	for <video4linux-list@redhat.com>; Sun, 10 Feb 2008 20:13:01 -0500
Received: from po-out-1718.google.com (po-out-1718.google.com [72.14.252.153])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1B1CR61009659
	for <video4linux-list@redhat.com>; Sun, 10 Feb 2008 20:12:27 -0500
Received: by po-out-1718.google.com with SMTP id b23so8395387poe.1
	for <video4linux-list@redhat.com>; Sun, 10 Feb 2008 17:12:26 -0800 (PST)
Message-ID: <18b102300802101712w245b7302ta4976a49bd34de5f@mail.gmail.com>
Date: Sun, 10 Feb 2008 20:12:26 -0500
From: "James Klaas" <jklaas@appalachian.dyndns.org>
To: sboyce@blueyonder.co.uk
In-Reply-To: <47AF7265.1070803@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18b102300801311533y65b32651v651e853ae3aea3d4@mail.gmail.com>
	<20080201001958.GA21437@plankton.ifup.org>
	<18b102300802011808w7a0ac750qf491d1aaa59efca3@mail.gmail.com>
	<20080207233507.GA21273@plankton.ifup.org>
	<18b102300802100801h295d15aan810313ae18c6fb6b@mail.gmail.com>
	<18b102300802100802p282b6d4fs4f45822b29d6d3d2@mail.gmail.com>
	<47AF7265.1070803@blueyonder.co.uk>
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: gspca drivers
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

On 2/10/08, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
> James Klaas wrote:
> > Sorry, forgot to send to video4linux list as well.
> >
> > ---------- Forwarded message ----------
> > From: James Klaas <jklaas@appalachian.dyndns.org>
> > Date: Feb 10, 2008 11:01 AM
> > Subject: Re: gspca drivers
> > To: Brandon Philips <brandon@ifup.org>
> >
> >
> > On 2/7/08, Brandon Philips <brandon@ifup.org> wrote:
> >> On 21:08 Fri 01 Feb 2008, James Klaas wrote:
> >>> On 1/31/08, Brandon Philips <brandon@ifup.org> wrote:
> >>>> On 18:33 Thu 31 Jan 2008, James Klaas wrote:
> >>>>> I was hoping to get my webcam working with the latest v4l-dvb sources.
> >>>>>  After reading about on this list and elsewhere, I ran:
> >>>>>
> >>>>> # make kernel-links
> >>>>>
> >>>>> from my v4l-dvb directory in order to modify my current linux sources
> >>>>> to use the v4l-dvb drivers.  Then I went to my gspca directory and ran
> >>>>> the "gspca_build" script:
> >>>>>
> >>>>> ./gspca_build
> >>>>>
> >>>>>  REMOVE the old module if present
> >>>>> Unknown symbol in module, or unknown parameter (see dmesg)
> >>>>>
> >>>>>  PRINT COMPILATION MESSAGES if ERRORS look kgspca.err
> >>>>> make -C /lib/modules/`uname -r`/build SUBDIRS=/usr/src/modules/gspca
> >>>>> CC=cc modules
> >>>>> make[1]: Entering directory `/usr/src/linux-source-2.6.22'
> >>>>>   CC [M]  /usr/src/modules/gspca/gspca_core.o
> >>>>> /usr/src/modules/gspca/gspca_core.c:2542: error: unknown field
> >>>>> 'hardware' specified in initializer
> >>>> Are you using the latest gspca driver?  The hardware field was removed
> >>>> months ago.
> >>> [ 1026.765596] gspca: disagrees about version of symbol video_devdata
> >> ...
> >>> [ 1977.737339] gspca: Unknown symbol video_device_release
> >> Did you "make install" the v4l tree you built against and make sure none
> >> of the old video modules were loaded (see lsmod) when you modprobe'd
> >> gspca?
> >>
> >> Thanks,
> >>
> >>         Brandon
> >>
> >
> > I checked the installed versions of videodev and gspca and both are
> > the same versions as the versions in the build directories, so they
> > installed fine.  I also checked the depends for videodev, v4l2-common
> > and v4l1-compat, and those were also the correct versions.
> >
> > I double checked to make sure there weren't any modules left over in
> > other directories in /lib/modules/`uname -r` and didn't find any.
> >
> > Since the machine in question also has a PCI video4linux device in it,
> > the drivers for that card already load the videodev modules.
> >
> > James
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >
> >
>
> Something isn't quite right, the latest driver 20071224 is OK on the
> latest 2.6.24-git kernels and the precious one 20071214 also built going
> way back. These are the lines in 20071224.
> tindog:/usr/src/gspcav1-20071224 # grep -rn hardware  *
> changelog:46:   hardware.:)
> Etoms/et61xx51.h:3:# This driver is design for embedded Linux hardware
> but should work happy
> gspca_core.c:1345:
> spca50x->mode = spca50x->mode_cam[j].mode;      // overwrite by the
> hardware mode
> gspca_core.c:1348:                                      }       // end
> match hardware mode
> gspca_core.c:1361:/* nothing todo hardware found stream */
> gspca_core.c:1837:* a process, not as read from camera hardware.
> gspca_core.c:2135:/* exclude hardware channel reserved */
> gspca_core.c:2613:      .hardware = VID_HARDWARE_GSPCA,
> gspca.h:412:/* What we think the hardware is currently set to */
> READ_AND_INSTALL:264:adjust video0 to your hardware
> Sunplus/spca505.dat:513:    {0x04, 0x41, 0x01},         //hardware
> snapcontrol
> Sunplus/spca561-OSX.h:204:    {0, 0x0001, 0x8200},      // OprMode to be
> executed by hardware
> Sunplus/spca561-OSX.h:207:    {0, 0x0001, 0x8200},      // OprMode to be
> executed by hardware
> Sunplus/spca561.h:204:    {0, 0x0001, 0x8200},  // OprMode to be
> executed by hardware
> Sunplus/spca561.h:207:    {0, 0x0001, 0x8200},  // OprMode to be
> executed by hardware
>
> tindog:/usr/src/gspcav1-20071224 # grep -rn video_device_release *
> gspca_core.c:2616:      .release = video_device_release,
> gspca_core.c:4325:                      video_device_release(spca50x->vdev);
> Binary file gspca_core.o matches
> Binary file gspca.ko matches
> gspca.mod.c:27: { 0x7ff0c04f, "video_device_release" },
> Binary file gspca.mod.o matches
> Binary file gspca.o matches
> utils/spcaCompat.h:27:static inline void video_device_release(struct
> video_device *vdev)
>
> Check if this tallies with what you have.

Here's what I get:

adirondack:/usr/src/gspca/gspcav1-20071224# grep -rn hardware  *
Etoms/et61xx51.h:3:# This driver is design for embedded Linux hardware
but should work happy
READ_AND_INSTALL:264:adjust video0 to your hardware
Sunplus/spca505.dat:513:    {0x04, 0x41, 0x01},         //hardware snapcontrol
Sunplus/spca561-OSX.h:204:    {0, 0x0001, 0x8200},      // OprMode to
be executed by hardware
Sunplus/spca561-OSX.h:207:    {0, 0x0001, 0x8200},      // OprMode to
be executed by hardware
Sunplus/spca561.h:204:    {0, 0x0001, 0x8200},  // OprMode to be
executed by hardware
Sunplus/spca561.h:207:    {0, 0x0001, 0x8200},  // OprMode to be
executed by hardware
changelog:46:   hardware.:)
gspca.h:412:/* What we think the hardware is currently set to */
gspca_core.c:1345:
 spca50x->mode = spca50x->mode_cam[j].mode;      // overwrite by the
hardware mode
gspca_core.c:1348:                                      }       // end
match hardware mode
gspca_core.c:1361:/* nothing todo hardware found stream */
gspca_core.c:1837:* a process, not as read from camera hardware.
gspca_core.c:2135:/* exclude hardware channel reserved */
gspca_core.c:2613:      .hardware = VID_HARDWARE_GSPCA,

Am I pulling the source from the wrong place?  It came as a tarball.

> Regards
> Sid.
> --
> Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
> Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
> Specialist, Cricket Coach
> Microsoft Windows Free Zone - Linux used for all Computing Tasks
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>


James

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
