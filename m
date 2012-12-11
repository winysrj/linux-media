Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:50254 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2LKJGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 04:06:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH RFC v2] media: v4l2-ctrl: Add gain controls
Date: Tue, 11 Dec 2012 10:05:59 +0100
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	LDOC <linux-doc@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Chris MacGregor <chris@cybermato.com>,
	Rob Landley <rob@landley.net>,
	Jeongtae Park <jtp.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1354708169-1139-1-git-send-email-prabhakar.csengg@gmail.com> <20121206095431.GA2887@valkosipuli.retiisi.org.uk> <201212110956.43081.hverkuil@xs4all.nl>
In-Reply-To: <201212110956.43081.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201212111005.59210.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 11 December 2012 09:56:42 Hans Verkuil wrote:
> On Thu 6 December 2012 10:54:32 Sakari Ailus wrote:
> > Hi Prabhakar and Hans,
> > 
> > On Thu, Dec 06, 2012 at 10:24:18AM +0530, Prabhakar Lad wrote:
> > > Hi Hans,
> > > 
> > > On Wed, Dec 5, 2012 at 5:38 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > (resend without HTML formatting)
> > > >
> > > > On Wed 5 December 2012 12:49:29 Prabhakar Lad wrote:
> > > >> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > > >>
> > > >> add support for per color component digital/analog gain controls
> > > >> and also their corresponding offset.
> > > >
> > > > Some obvious questions below...
> > > >
> > > >>
> > > >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > > >> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > > >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > >> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > >> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > >> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > > >> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > > >> Cc: Hans de Goede <hdegoede@redhat.com>
> > > >> Cc: Chris MacGregor <chris@cybermato.com>
> > > >> Cc: Rob Landley <rob@landley.net>
> > > >> Cc: Jeongtae Park <jtp.park@samsung.com>
> > > >> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > > >> ---
> > > >>  Changes for v2:
> > > >>  1: Fixed review comments pointed by Laurent.
> > > >>  2: Rebased on latest tree.
> > > >>
> > > >>  Documentation/DocBook/media/v4l/controls.xml |   54 ++++++++++++++++++++++++++
> > > >>  drivers/media/v4l2-core/v4l2-ctrls.c         |   11 +++++
> > > >>  include/uapi/linux/v4l2-controls.h           |   11 +++++
> > > >>  3 files changed, 76 insertions(+), 0 deletions(-)
> > > >>
> > > >> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> > > >> index 7fe5be1..847a9bb 100644
> > > >> --- a/Documentation/DocBook/media/v4l/controls.xml
> > > >> +++ b/Documentation/DocBook/media/v4l/controls.xml
> > > >> @@ -4543,6 +4543,60 @@ interface and may change in the future.</para>
> > > >>           specific test patterns can be used to test if a device is working
> > > >>           properly.</entry>
> > > >>         </row>
> > > >> +       <row>
> > > >> +         <entry spanname="id"><constant>V4L2_CID_GAIN_RED</constant></entry>
> > > >> +         <entry>integer</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="id"><constant>V4L2_CID_GAIN_GREEN_RED</constant></entry>
> > > >> +         <entry>integer</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="id"><constant>V4L2_CID_GAIN_GREEN_BLUE</constant></entry>
> > > >> +         <entry>integer</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="id"><constant>V4L2_CID_GAIN_BLUE</constant></entry>
> > > >> +         <entry>integer</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="id"><constant>V4L2_CID_GAIN_GREEN</constant></entry>
> > > >> +         <entry>integer</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="descr"> Some capture/sensor devices have
> > > >> +         the capability to set per color component digital/analog gain values.</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="id"><constant>V4L2_CID_GAIN_OFFSET</constant></entry>
> > > >> +         <entry>integer</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="id"><constant>V4L2_CID_BLUE_OFFSET</constant></entry>
> > > >> +         <entry>integer</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="id"><constant>V4L2_CID_RED_OFFSET</constant></entry>
> > > >> +         <entry>integer</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="id"><constant>V4L2_CID_GREEN_OFFSET</constant></entry>
> > > >> +         <entry>integer</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="id"><constant>V4L2_CID_GREEN_RED_OFFSET</constant></entry>
> > > >> +         <entry>integer</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="id"><constant>V4L2_CID_GREEN_BLUE_OFFSET</constant></entry>
> > > >> +         <entry>integer</entry>
> > > >> +       </row>
> > > >> +       <row>
> > > >> +         <entry spanname="descr"> Some capture/sensor devices have the
> > > >> +         capability to set per color component digital/analog gain offset values.
> > > >> +         V4L2_CID_GAIN_OFFSET is the global gain offset and the rest are per
> > > >> +         color component gain offsets.</entry>
> > > >
> > > > If I set both V4L2_CID_GAIN_RED and V4L2_CID_RED_OFFSET, how are they supposed
> > > > to interact? Or are they mutually exclusive?
> > > >
> > > > And if I set both V4L2_CID_GAIN_OFFSET and V4L2_CID_RED_OFFSET, how are they supposed
> > > > to interact?
> > > >
> > > > This questions should be answered in the documentation...
> > > >
> > > I haven’t worked on the hardware which supports both, What is the general
> > > behaviour when the hardware supports both per color component and global
> > > and both of them are set ? That could be helpful for me to document.
> > 
> > I'd guess most of the time only either one is supported,
> 
> Are you talking about GAIN_RED vs GAIN_RED_OFFSET or GAIN_OFFSET vs RED_OFFSET?
> Or both?

I guess GAIN_RED + GAIN_RED_OFFSET is fine as a combination after reading up on it
a bit. It's the global vs per-component that's the problem. After thinking about
it some more I'd say it should be either one or the other, with a possible control
to switch between the two if both modes are supported. It gets very messy otherwise.

Regards,

	Hans

> 
> > and when someone
> > thinks of supporting both on the same device, we can start thinking of the
> > interaction of per-component and global ones. That may be hardware specific
> > as well, so standardising it might not be possible.
> > 
> > I think it'd be far more important to know which unit is it. Many such
> > controls are indeed fixed point values but the location of the point varies.
> > For unstance, u16,u16 and u8,u8 aren't uncommon. We currently have no way to
> > tell this to the user space. This isn't in any way specific to gain or
> > offset controls, though.
> 
> There are no standardized units for gain at the moment, and I don't really see
> that happening any time soon. Fixed point isn't supported at all as a control
> type, so that will have to be converted to an integer anyway.
> 
> Prabhakar, which of these controls are actually supported by your hardware?
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
