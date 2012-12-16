Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49142 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752629Ab2LPPA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 10:00:28 -0500
Date: Sun, 16 Dec 2012 17:00:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC 2/2] V4L: Add V4L2_CID_AUTO_FOCUS_AREA control
Message-ID: <20121216150023.GC4738@valkosipuli.retiisi.org.uk>
References: <1355147019-25375-1-git-send-email-a.hajda@samsung.com>
 <1355147019-25375-3-git-send-email-a.hajda@samsung.com>
 <20121211213404.GC3747@valkosipuli.retiisi.org.uk>
 <50C89F4E.6010701@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C89F4E.6010701@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On Wed, Dec 12, 2012 at 04:14:22PM +0100, Andrzej Hajda wrote:
> On 11.12.2012 22:34, Sakari Ailus wrote:
> >Hi Andrzej and Sylwester,
> >
> >Thanks for the patch!
> >
> >On Mon, Dec 10, 2012 at 02:43:39PM +0100, Andrzej Hajda wrote:
> >>From: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >>
> >>Add control for automatic focus area selection.
> >>This control determines the area of the frame that the camera uses
> >>for automatic focus.
> >>
> >>Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >>Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >>Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>---
> >>  Documentation/DocBook/media/v4l/compat.xml   |    9 +++--
> >>  Documentation/DocBook/media/v4l/controls.xml |   47 +++++++++++++++++++++++++-
> >>  Documentation/DocBook/media/v4l/v4l2.xml     |    7 ++++
> >>  drivers/media/v4l2-core/v4l2-ctrls.c         |   10 ++++++
> >>  include/uapi/linux/v4l2-controls.h           |    6 ++++
> >>  5 files changed, 76 insertions(+), 3 deletions(-)
> >>
> >>diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> >>index 4fdf6b5..e8b53da 100644
> >>--- a/Documentation/DocBook/media/v4l/compat.xml
> >>+++ b/Documentation/DocBook/media/v4l/compat.xml
> >>@@ -2452,8 +2452,9 @@ that used it. It was originally scheduled for removal in 2.6.35.
> >>  	  <constant>V4L2_CID_3A_LOCK</constant>,
> >>  	  <constant>V4L2_CID_AUTO_FOCUS_START</constant>,
> >>  	  <constant>V4L2_CID_AUTO_FOCUS_STOP</constant>,
> >>-	  <constant>V4L2_CID_AUTO_FOCUS_STATUS</constant> and
> >>-	  <constant>V4L2_CID_AUTO_FOCUS_RANGE</constant>.
> >>+	  <constant>V4L2_CID_AUTO_FOCUS_STATUS</constant>,
> >>+	  <constant>V4L2_CID_AUTO_FOCUS_RANGE</constant> and
> >>+	  <constant>V4L2_CID_AUTO_FOCUS_AREA</constant>.
> >>  	  </para>
> >>          </listitem>
> >>        </orderedlist>
> >>@@ -2586,6 +2587,10 @@ ioctls.</para>
> >>  	  <para>Vendor and device specific media bus pixel formats.
> >>  	    <xref linkend="v4l2-mbus-vendor-spec-fmts" />.</para>
> >>          </listitem>
> >>+        <listitem>
> >>+	  <para><link linkend="v4l2-auto-focus-area"><constant>
> >>+	  V4L2_CID_AUTO_FOCUS_AREA</constant></link> control.</para>
> >>+        </listitem>
> >>        </itemizedlist>
> >>      </section>
> >>diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> >>index 7fe5be1..9d4af8a 100644
> >>--- a/Documentation/DocBook/media/v4l/controls.xml
> >>+++ b/Documentation/DocBook/media/v4l/controls.xml
> >>@@ -3347,6 +3347,51 @@ use its minimum possible distance for auto focus.</entry>
> >>  	  </row>
> >>  	  <row><entry></entry></row>
> >>+	  <row id="v4l2-auto-focus-area">
> >>+	    <entry spanname="id">
> >>+	      <constant>V4L2_CID_AUTO_FOCUS_AREA</constant>&nbsp;</entry>
> >>+	    <entry>enum&nbsp;v4l2_auto_focus_area</entry>
> >>+	  </row>
> >>+	  <row><entry spanname="descr">Determines the area of the frame that
> >>+the camera uses for automatic focus. The corresponding coordinates of the
> >>+focusing spot or rectangle can be specified and queried using the selection API.
> >>+To change the auto focus region of interest applications first select required
> >>+mode of this control and then set the rectangle or spot coordinates by means
> >>+of the &VIDIOC-SUBDEV-S-SELECTION; or &VIDIOC-S-SELECTION; ioctl. In order to
> >>+trigger again a one shot auto focus with same coordinates applications should
> >>+use the <constant>V4L2_CID_AUTO_FOCUS_START </constant> control. Or alternatively
> >Extra space above.                            ^
> >
> >>+invoke a &VIDIOC-SUBDEV-S-SELECTION; or a &VIDIOC-S-SELECTION; ioctl again.
> >How about requiring explicit V4L2_CID_AUTO_FOCUS_START? If you need to
> >specify several AF selection windows, then on which one do you start the
> >algorithm? A bitmask control explicitly telling which ones are active would
> >also be needed --- but that's for the future. I think now we just need to
> >ascertain we don't make that difficult. :-)
> Do you mean only V4L2_CID_AUTO_FOCUS_START should start AF?
> What about continuous auto-focus (CAF)? In case of the sensor I am
> working on, face detection can work in both AF and CAF.

Continuous AF needs to be an exception to that. It's controlled by
V4L2_CID_FOCUS_AUTO, which interestingly doesn't even mention continuous AF.

> Should CAF be restarted (ie stopped and started again), to use face
> detection?

I wonder if V4L2_CID_AUTO_FOCUS_START should be defined to restart CAF when
V4L2_CID_FOCUS_AUTO is enabled. I don't think we currently have a way to do
that; the current definition says that using V4L2_CID_AUTO_FOCUS_START is
undefined then. What do you think?

> >>+In the latter case the new pixel coordinates are applied to hardware only when
> >>+the focus area control was set to
> >>+<constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>.</entry>
> >>+	  </row>
> >>+	  <row>
> >>+	    <entrytbl spanname="descr" cols="2">
> >>+	      <tbody valign="top">
> >>+		<row>
> >>+		  <entry><constant>V4L2_AUTO_FOCUS_AREA_ALL</constant>&nbsp;</entry>
> >>+		  <entry>Normal auto focus, the focusing area extends over the
> >>+entire frame.</entry>
> >Does this need to be explicitly specified? Shouldn't the user just choose
> >the largest possible AF window instead? I'd even expect that the AF window
> >might span the whole frame by default (up to driver, hardware etc.).
> Yes it could be removed. There are two reasons I have left it:
> 1. If hardware support only AF on spots, V4L2_AUTO_FOCUS_AREA_ALL
> seems to be more
> natural than focusing on the whole image.

If the hardware only supports spots, then wouldn't V4L2_AUTO_FOCUS_AREA_ALL
give false information to the user, suggesting the focus area is actually
the whole image?

> 2. (Hypothetical) Instructing HW to area-focusing on the whole are
> could have different results than just starting default auto-focus,
> ie there could be different algorithms involved. It is just a
> prediction based on my current experience :)

If the algorithm is different in that case, then it should be made a new
control, not implicitly throught a seemingly unrelated control.

We currently don't have one, and this kind of things could be hardware
specific, so this could be a private control IMO.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
