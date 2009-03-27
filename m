Return-path: <video4linux-list-bounces@redhat.com>
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: dean <dean@sensoray.com>
Date: Thu, 26 Mar 2009 22:31:17 -0300
References: <20090326160017.048668E03F1@hormel.redhat.com>
	<49CBB06E.4070305@sensoray.com>
In-Reply-To: <49CBB06E.4070305@sensoray.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903262231.18841.lamarque@gmail.com>
Cc: hdegoede@redhat.com, video4linux-list@redhat.com, Greg KH <greg@kroah.com>
Subject: Re: Skype and libv4
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

Em Thursday 26 March 2009, dean escreveu:
> Hi, Please see comments below:
> > Subject:
> > Re: Skype and libv4
> > From:
> > Lamarque Vieira Souza <lamarque@gmail.com>
> > Date:
> > Thu, 26 Mar 2009 10:36:56 -0300
> > To:
> > Hans de Goede <hdegoede@redhat.com>
> >
> > To:
> > Hans de Goede <hdegoede@redhat.com>
> > CC:
> > video4linux-list@redhat.com
> >
> > Em Thursday 26 March 2009, Hans de Goede escreveu:
> >> Hi all,
> >>
> >> Not quite, the correct behaviour is:
> >> "If the field value is set to an unsupported value, then set the field
> >> value to *a* value that the driver accepts"
> >
> > 	Now I get it. This webcam only accepts V4L2_FIELD_NONE, so commenting
> > that part of try_fmt makes it compliant with v4l2 standard. Thank you for
> > helping me with this. The zr364xx's maintainer contacted me yesterday, he
> > is busy theses days, when he has more time he is going to take a look at
> > my changes. With lucky the changes will be in 2.6.30. At least 2.6.29
> > sets the compat_ioctl32 automatically for all drivers, in 2.6.28.8 I had
> > to set it in the driver to make Skype and mplayer (32-bit) work, one less
> > change for the driver :-)
>
> The lack of V4L2_FIELD_NONE caused what sort of problems in these
> applications/drivers?  Did you the driver recover without it?

	Skype+libv4l did not work and let the driver in unsable state (no application 
worked until I reloaded the driver). mplayer and Kopete+libv4l work without 
changing this part of the driver because they probably passed V4L2_FIELD_ANY, 
which makes the driver return V4L2_FIELD_NONE. Skypes passes 
V4L2_FIELD_INTERLACED, which this card does not support. 

	One strange thing is that Skype returns two error messages: one about the 
v4l2 format and this one "Skype Xv: No suitable overlay format found". I think 
this message is misleading because there is no problem with Xv's overlay, it 
just the stream format from the v4l2's driver that was not recognized. I have 
seen several people on the Internet with problem with Skype and this error 
message, maybe the drivers they are using is doing the wrong thing in try_fmt 
too. meye.c is another one which probably has this problem with Skype.

> >> This takes in to account certain devices can support multiple field
> >> types, which is the whole purpose of the field value.
> >>
> >> And yes unfortunately many many v4l drivers have various bugs in their
> >> implementation, in some cases I do work around driver bugs in libv4l,
> >> but it this case that would hurt proper use of the field value, and that
> >> is not acceptable, so fixing the driver is the only solution.
>
> Can you elaborate on the V4L drivers with bugs?  If they aren't
> identified, they won't be fixed.
>
> > 	Have you tried to contact the drivers' maintainers for fixing those
> > bugs?
> >
> >> Note, that the v4l2 API is pretty well documented, and the correct
> >> behaviour as I describe it can be found in the docs too:
> >> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/r10944.ht
> >>m
> >>
> >> And the "Return Value" section, note how EINVAL is only supposed to be
> >> returned up on an invalid, or unsupported type value. And also from the
> >> description: "Drivers should not return an error code unless the input
> >> is ambiguous"
> >
> > ------------------------------------------------------------------------
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe
> > mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
>
> I also have a question about the removal of videobuf_waiton in the
> patch.  Only 3 other drivers are using videobuf_waiton. Should
> videobuf_waiton be removed from them also?  I believe it was in vivi.c
> at some point, but I'll have to double check...

	I think it should be removed. As far as I understand videobuf_waiton(&buf-
>vb, 0, 0) will block forever until the video buffer list is emptied, but if 
the driver is an unload module state nobody will empty the list. If the 
application works as expected it will empty the list before closing the device 
and everything works, but Skype was not working properly because of the 
V4L2_FIELD_INTERLACED problem, it issued some vidioc_qbuf calls but no 
vidioc_dqbuf calls reached the driver accordingly to my logs, so the dead lock 
when trying to unload the driver's module.

-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
