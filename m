Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sat, 29 Nov 2008 00:39:40 +0100
References: <200811271536.46779.laurent.pinchart@skynet.be>
	<200811281730.55232.laurent.pinchart@skynet.be>
	<20081128164707.2c0889c9@pedra.chehab.org>
In-Reply-To: <20081128164707.2c0889c9@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811290039.41099.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Michael Schimek <mschimek@gmx.at>
Subject: Re: [PATCH 4/4] v4l2: Document zoom and privacy controls
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

Hi Mauro,

On Friday 28 November 2008, Mauro Carvalho Chehab wrote:
> On Fri, 28 Nov 2008 17:30:55 +0100
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > On Friday 28 November 2008, Mauro Carvalho Chehab wrote:
> > > On Thu, 27 Nov 2008 15:48:31 +0100
> > > Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > > > +
> > > > +          <row>
> > > > +            <entry
> > > > spanname="id"><constant>V4L2_CID_ZOOM_ABSOLUTE</constant>&nbsp;</entr
> > > >y> + <entry>integer</entry>
> > > > +          </row><row><entry spanname="descr">Specify the objective
> > > > lens +focal length as an absolute value. The zoom unit is
> > > > driver-specific and its +value should be a positive integer.</entry>
> > >
> > > Hmm... I think it would be better to have some unit for the controls,
> > > or at least a way to report the unit to userspace.
> >
> > Why ? Does it matter if the zoom is expressed as an absolute focal lens
> > in millimetres or mils, or as a relative value between 0 an 255 ? Most
> > devices will use an arbitrary scale, probably 0-255, to cover the whole
> > zoom range. There is no unit associated with that.
>
> This may matter on professional cameras, like those used on surveillance,
> and special-purpose cameras like microscope cams, dental cams and cameras
> used in robotics.

Cameras (or rather drivers) will report the zoom minimum and maximum values 
through VIDIOC_QUERY_CTRL. The vast majority of devices will use an arbitrary 
scale. As long as the userspace application knows the zoom boundaries, which 
would it need a unit ? What added value would that bring, beside just being 
displayed on a GUI label ? Specialised applications performing complex 
computation on the focal length involving units will need to be device-aware 
anyway.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
