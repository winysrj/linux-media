Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:16500
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbZBWWhj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 17:37:39 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] How to pass camera Orientation to userspace
Date: Mon, 23 Feb 2009 22:37:31 +0000
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	kilgota@banach.math.auburn.edu,
	Olivier Lorin <o.lorin@laposte.net>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <20090223080715.0c97774e@pedra.chehab.org>
In-Reply-To: <20090223080715.0c97774e@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902232237.32362.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 23 February 2009, Mauro Carvalho Chehab wrote:
> On Sat, 21 Feb 2009 12:53:57 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Adam,
> >
> > Sorry for the late reply, it's been very busy.
>
> Me too.
>
> > > 1) Reuse the existing HFLIP and VFLIP controls, marking them as
> > > read-only Pros : No change needed to videodev2.h
> > > Cons: It is confusing to have controls that have a subtly different
> > > meaning if they are read only. Existing apps that support those
> > > controls might get confused. Would require polling to support the case
> > > of a camera being turned toward / away from the user while streaming.
>
> Reusing an existing control for a different meaning seems wrong. What
> happens when some cam has the capability of doing hardware flipping, and
> have the cam flipped?

I thought that case had already been agreed, implement the flip controls but
set the flip flag in the hardware to the opposite of what the control says.


>
> > > 4) Use some reserved bits from the v4l2_capability structure
> > > Pros: Less overhead than controls.
> > > Cons: Would require polling to support the case of a camera being
> > > turned toward / away from the user while streaming. Can't easily
> > > identify drivers that don't support it.
> > > 5) Use some reserved bits from the v4l2_input structure (or possibly
> > > the status word but that is normally only valid for current input)
> > > Pros: Less overhead than controls. Could support multiple sensors in
> > > one camera if such a beast exists.
> >
> > What does exist is devices with a video input (e.g. composite) and a
> > camera input: each input will have different flags. Since these
> > vflip/hflip properties do not change they can be enumerated in advance
> > and you know what each input supports.
> >
> > > Cons: Would require polling to support the case of a camera being
> > > turned toward / away from the user while streaming.
> >
> > Polling applies only to the bits that tell the orientation of the camera.
> > See below for a discussion of this.
>
> Analog tv does polling for signal strength, since userspace apps do mute
> and stops presenting video, if the signal is too weak. IMO, a similar
> mechanism should be used by pivoting.
>
> IMO, this would be better addressed as a property of v4l2_input. So, I
> think that (5) is better than (4).
>
> > > Can't easily identify drivers that don't support it.
> >
> > Not too difficult to add through the use of a capability bit. Either in
> > v4l2_input or (perhaps) v4l2_capability.
> >
> > Another Pro is that this approach will also work for v4l2_output in the
> > case of, say, rotated LCD displays. Using camera orientation bits in
> > v4l2_buffer while capturing will work, but using similar bits for output
> > will fail since the data is going in the wrong direction.
> >
> > > The interest in detecting if a driver provides this informnation is to
> > > allow libv4l to know when it should use the driver provided information
> > > and when it should use its internal table (which needs to be retained
> > > for backward compatibility). With no detection capability the driver
> > > provided info should be ignored for USB IDs in the built in table.
> > >
> > > Thoughts please
>
> There is a case that we should think: at libv4l, we may need to override
> the "default" orientation, by a custom one. For example: Surveillance
> systems have cameras mounted on a fixed position. Depending on the camera,
> and the desired position, some cameras may needed to be mounted rotated
> (the same case also applies to some embedded hardware like ATM machines,
> where a webcam maybe mounted with 180 degrees, due to hardware
> constraints).

Agreed, Hans de Geode pointed out the similar case that 2 laptops may use the 
same camera but one mount it upside down so hardware info unrelated to the 
camera indicates the orientation.

>
> Ok, this is nothing that kernel needs to handle, but, at userspace, we need
> to have a file where the user could edit and store the camera position, to
> override whatever we have in kernel.

Unfortunately what that doesn't address is the problem that first started this 
discussion. A camera where the orientation information is contained in the 
USB messages from the camera so the driver is the only thing that can 
reasonably access it.

Note also that for sensor orientation I doubt that 90 or 270 degrees rotation 
will be seen but I do know that the case of data being flipped on just one 
axis does exist.

>
> > Is polling bad in this case? It is not something that needs immediate
> > attention IMHO. The overhead for checking once every X seconds is quite
> > low. Furthermore, it is only needed on devices that cannot do v/hflipping
> > in hardware.
> >
> > An alternative is to put some effort in a proper event interface. There
> > is one implemented in include/linux/dvb/video.h and used by ivtv for
> > video decoding. The idea is that the application registers events it
> > wants to receive, and whenever such an event arrives the select() call
> > will exit with a high-prio event (exception). The application then checks
> > what happened.
> >
> > The video.h implementation is pretty crappy, but we can make something
> > more useful. Alternatively, I believe there are other event mechanisms as
> > well in the kernel. I know some work was done on that, but I don't know
> > what the end result was.
> >
> > Note that this does not apply to sensor mount information. I think that
> > v4l2_input is the perfect place for that. It is after all an
> > input-specific property and static property, and it maps 1-on-1 to the
> > output case as well, should we need it there as well.
>
> I think we will need an event interface sooner or later. I had some
> discussions in the past about servo mechanisms to control the webcam
> position. Let's consider a webcam with movement servos at vertical and
> horizontal, and that we want to follow an object, like a person face. After
> sending a command to the servo, it will start moving, but it will take some
> time until it reaches the point. An event interface seems interesting to
> advice userspace that the movement already happened.

I suspect it would make most sense in that sort of scenario to consider the 
servos as a separate device - they might easily be part of a mount that is 
usable independent of the camera fitted to it.

Adam

