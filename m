Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17Na0Qt008919
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 18:36:00 -0500
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.235])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m17NZP6K024269
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 18:35:25 -0500
Received: by wx-out-0506.google.com with SMTP id t16so3137546wxc.6
	for <video4linux-list@redhat.com>; Thu, 07 Feb 2008 15:35:19 -0800 (PST)
Date: Thu, 7 Feb 2008 15:35:07 -0800
From: Brandon Philips <brandon@ifup.org>
To: James Klaas <jklaas@appalachian.dyndns.org>
Message-ID: <20080207233507.GA21273@plankton.ifup.org>
References: <18b102300801311533y65b32651v651e853ae3aea3d4@mail.gmail.com>
	<20080201001958.GA21437@plankton.ifup.org>
	<18b102300802011808w7a0ac750qf491d1aaa59efca3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18b102300802011808w7a0ac750qf491d1aaa59efca3@mail.gmail.com>
Cc: video4linux-list@redhat.com, linux-dvb <linux-dvb@linuxtv.org>
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

On 21:08 Fri 01 Feb 2008, James Klaas wrote:
> On 1/31/08, Brandon Philips <brandon@ifup.org> wrote:
> > On 18:33 Thu 31 Jan 2008, James Klaas wrote:
> > > I was hoping to get my webcam working with the latest v4l-dvb sources.
> > >  After reading about on this list and elsewhere, I ran:
> > >
> > > # make kernel-links
> > >
> > > from my v4l-dvb directory in order to modify my current linux sources
> > > to use the v4l-dvb drivers.  Then I went to my gspca directory and ran
> > > the "gspca_build" script:
> > >
> > > ./gspca_build
> > >
> > >  REMOVE the old module if present
> > > Unknown symbol in module, or unknown parameter (see dmesg)
> > >
> > >  PRINT COMPILATION MESSAGES if ERRORS look kgspca.err
> > > make -C /lib/modules/`uname -r`/build SUBDIRS=/usr/src/modules/gspca
> > > CC=cc modules
> > > make[1]: Entering directory `/usr/src/linux-source-2.6.22'
> > >   CC [M]  /usr/src/modules/gspca/gspca_core.o
> > > /usr/src/modules/gspca/gspca_core.c:2542: error: unknown field
> > > 'hardware' specified in initializer
> >
> > Are you using the latest gspca driver?  The hardware field was removed
> > months ago.
> 
> [ 1026.765596] gspca: disagrees about version of symbol video_devdata
...
> [ 1977.737339] gspca: Unknown symbol video_device_release

Did you "make install" the v4l tree you built against and make sure none
of the old video modules were loaded (see lsmod) when you modprobe'd
gspca?

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
