Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59422 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab2IMKQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-kernel@vger.kernel.org,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	linux-doc@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2] media: v4l2-ctrls: add control for test pattern
Date: Thu, 13 Sep 2012 03:04:58 +0200
Message-ID: <2535230.94CWWn0niF@avalon>
In-Reply-To: <20120909074017.GF6834@valkosipuli.retiisi.org.uk>
References: <1347007309-6913-1-git-send-email-prabhakar.lad@ti.com> <201209081311.04861.hverkuil@xs4all.nl> <20120909074017.GF6834@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 09 September 2012 10:40:17 Sakari Ailus wrote:
> On Sat, Sep 08, 2012 at 01:11:04PM +0200, Hans Verkuil wrote:
> > On Fri September 7 2012 20:20:51 Sakari Ailus wrote:
> > > Prabhakar Lad wrote:
> > > > From: Lad, Prabhakar <prabhakar.lad@ti.com>
> > > > 
> > > > add V4L2_CID_TEST_PATTERN of type menu, which determines
> > > > the internal test pattern selected by the device.
> > > > 
> > > > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > > > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > > > Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > > > Cc: Hans de Goede <hdegoede@redhat.com>
> > > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > > Cc: Rob Landley <rob@landley.net>
> > > > ---
> > > > This patches has one checkpatch warning for line over
> > > > 80 characters altough it can be avoided I have kept it
> > > > for consistency.
> > > > 
> > > > Changes for v2:
> > > > 1: Included display devices in the description for test pattern
> > > >     as pointed by Hans.
> > > > 
> > > > 2: In the menu replaced 'Test Pattern Disabled' by 'Disabled' as
> > > >     pointed by Sylwester.
> > > > 
> > > > 3: Removed the test patterns from menu as the are hardware specific
> > > >     as pointed by Sakari.
> > > >   
> > > >   Documentation/DocBook/media/v4l/controls.xml |   20 ++++++++++++++++
> > > >   drivers/media/v4l2-core/v4l2-ctrls.c         |    8 ++++++++
> > > >   include/linux/videodev2.h                    |    4 ++++
> > > >   3 files changed, 32 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> > > > b/Documentation/DocBook/media/v4l/controls.xml index ad873ea..173934e
> > > > 100644
> > > > --- a/Documentation/DocBook/media/v4l/controls.xml
> > > > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > > > @@ -4311,6 +4311,26 @@ interface and may change in the future.</para>
> > > >   	      </tbody>
> > > >   	    </entrytbl>
> > > >   	  </row>
> > > > +	  <row>
> > > > +	    <entry
> > > > spanname="id"><constant>V4L2_CID_TEST_PATTERN</constant></entry> +	  
> > > >  <entry>menu</entry>
> > > > +	  </row>
> > > > +	  <row id="v4l2-test-pattern">
> > > > +	    <entry spanname="descr"> The Capture/Display/Sensors have the
> > > > capability
> > > > +	    to generate internal test patterns and this are hardware
> > > > specific. This
> > > > +	    test patterns are used to test a device is properly working and
> > > > can generate
> > > > +	    the desired waveforms that
> > > > it supports.</entry>
> > > > +	  </row>
> > > > +	  <row>
> > > > +	    <entrytbl spanname="descr" cols="2">
> > > > +	      <tbody valign="top">
> > > > +	        <row>
> > > > +	        
> > > > <entry><constant>V4L2_TEST_PATTERN_DISABLED</constant></entry>
> > > > +	          <entry>Test pattern generation is disabled</entry>
> > > > +	        </row>
> > > > +	      </tbody>
> > > > +	    </entrytbl>
> > > > +	  </row>
> > > >   	<row><entry></entry></row>
> > > >   	</tbody>
> > > >         </tgroup>
> > > > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> > > > b/drivers/media/v4l2-core/v4l2-ctrls.c index 8f2f40b..d731422 100644
> > > > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > > > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > > > @@ -430,6 +430,10 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
> > > >   		"Advanced",
> > > >   		NULL,
> > > >   	};
> > > > +	static const char * const test_pattern[] = {
> > > > +		"Disabled",
> > > > +		NULL,
> > > > +	};
> > > > 
> > > >   	switch (id) {
> > > >   	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
> > > > @@ -509,6 +513,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
> > > >   		return jpeg_chroma_subsampling;
> > > >   	case V4L2_CID_DPCM_PREDICTOR:
> > > >   		return dpcm_predictor;
> > > > +	case V4L2_CID_TEST_PATTERN:
> > > > +		return test_pattern;
> > > 
> > > I think it's not necessary to define test_pattern (nor be prepared to
> > > return it) since the menu is going to be device specific. So the driver
> > > is responsible for all of the menu items. Such menus are created using
> > > v4l2_ctrl_new_custom() instead of v4l2_ctrl_new_std_menu().
> > > 
> > > Looks good to me otherwise.
> > 
> > I would suggest that we *do* make this a standard control, but the menu
> > consists of just one item: "Disabled". After creating the control you can
> > just set the ctrl->qmenu pointer to the device-specific menu. I like
> > using standard controls because they guarantee standard naming and type
> > conventions. They are also easier to use in an application.
> 
> That's not quite enough. Also menu_skip_mask and max also need to be
> replaced. In a general case min as well. It's easy to do mistakes in that
> --- how about a separate function for doing that? It'd be also nice to be
> able to use the existing standardised menu item strings, but that's just an
> extra plus.

Agreed. A way to create a standard menu control with driver-supplied menu 
items would be a good addition to the control framework API.

> However I think it's beyond this patch, which I think then is be fine w/o
> modifications. So on my behalf,
> 
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Regards,

Laurent Pinchart

