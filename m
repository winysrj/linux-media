Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49121 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752435Ab2LPMaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 07:30:11 -0500
Date: Sun, 16 Dec 2012 14:30:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC 1/2] V4L: Add auto focus selection targets
Message-ID: <20121216123006.GB4738@valkosipuli.retiisi.org.uk>
References: <1355147019-25375-1-git-send-email-a.hajda@samsung.com>
 <1355147019-25375-2-git-send-email-a.hajda@samsung.com>
 <20121211210449.GB3747@valkosipuli.retiisi.org.uk>
 <50C88DC4.3090206@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C88DC4.3090206@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andzej,

On Wed, Dec 12, 2012 at 02:59:32PM +0100, Andrzej Hajda wrote:
> On 11.12.2012 22:04, Sakari Ailus wrote:
> >Hi Andrzej,
> >
> >Many thanks for the patch!
> >
> >On Mon, Dec 10, 2012 at 02:43:38PM +0100, Andrzej Hajda wrote:
> >>From: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >>
> >>The camera automatic focus algorithms may require setting up
> >>a spot or rectangle coordinates.
> >>
> >>The automatic focus selection targets are introduced in order
> >>to allow applications to query and set such coordinates. Those
> >>selections are intended to be used together with the automatic
> >>focus controls available in the camera control class.
> >>
> >>Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >>Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >>Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>---
> >>  Documentation/DocBook/media/v4l/selection-api.xml  |   32 ++++++++++++++++-
> >>  .../DocBook/media/v4l/selections-common.xml        |   37 ++++++++++++++++++++
> >>  .../media/v4l/vidioc-subdev-g-selection.xml        |    4 +--
> >>  include/uapi/linux/v4l2-common.h                   |    5 +++
> >>  4 files changed, 75 insertions(+), 3 deletions(-)
> >>
> >>diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
> >>index 4c238ce..8caf67b 100644
> >>--- a/Documentation/DocBook/media/v4l/selection-api.xml
> >>+++ b/Documentation/DocBook/media/v4l/selection-api.xml
> >>@@ -1,6 +1,6 @@
> >>  <section id="selection-api">
> >>-  <title>Experimental API for cropping, composing and scaling</title>
> >>+  <title>Experimental selections API</title>
> >Hmm. I wonder if it'd be enough to call this just "Selection API". There's a
> >note just below telling it's experimental.
> >
> >>        <note>
> >>  	<title>Experimental</title>
> >>@@ -9,6 +9,10 @@
> >>  interface and may change in the future.</para>
> >>        </note>
> >>+ <section>
> >>+
> >>+ <title>Image cropping, composing and scaling</title>
> >>+
> >>    <section>
> >>      <title>Introduction</title>
> >>@@ -321,5 +325,31 @@ V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> for other devices</para>
> >>        </example>
> >>     </section>
> >>+ </section>
> >>+
> >>+ <section>
> >>+     <title>Automatic focus regions of interest</title>
> >>+
> >>+<para>The camera automatic focus algorithms may require configuration of
> >>+regions of interest in form of rectangle or spot coordinates. The automatic
> >>+focus selection targets allow applications to query and set such coordinates.
> >>+Those selections are intended to be used together with the
> >>+<constant>V4L2_CID_AUTO_FOCUS_AREA</constant> <link linkend="camera-controls">
> >>+camera class</link> control. The <constant>V4L2_SEL_TGT_AUTO_FOCUS</constant>
> >>+target is used for querying or setting actual spot or rectangle coordinates,
> >>+while <constant>V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS</constant> target determines
> >>+bounds for a single spot or rectangle.
> >>+These selections are only effective when the <constant>V4L2_CID_AUTO_FOCUS_AREA
> >>+</constant>control is set to
> >>+<constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>. The new coordinates shall
> >>+be accepted and applied to hardware when the focus area control value is
> >>+changed and also during a &VIDIOC-S-SELECTION; ioctl call, only when the focus
> >>+area control is already set to required value.</para>
> >>+
> >>+<para>When the <structfield>width</structfield> and
> >>+<structfield>height</structfield> of the selection rectangle are set to 0 the
> >>+selection determines spot coordinates, rather than a rectangle.</para>
> >>+
> >>+ </section>
> >>  </section>
> >>diff --git a/Documentation/DocBook/media/v4l/selections-common.xml b/Documentation/DocBook/media/v4l/selections-common.xml
> >>index 7502f78..9f0c477 100644
> >>--- a/Documentation/DocBook/media/v4l/selections-common.xml
> >>+++ b/Documentation/DocBook/media/v4l/selections-common.xml
> >>@@ -93,6 +93,22 @@
> >>  	    <entry>Yes</entry>
> >>  	    <entry>No</entry>
> >>  	  </row>
> >>+	  <row>
> >>+	    <entry><constant>V4L2_SEL_TGT_AUTO_FOCUS</constant></entry>
> >>+	    <entry>0x1001</entry>
> >>+	    <entry>Actual automatic focus rectangle.</entry>
> >>+	    <entry>Yes</entry>
> >>+	    <entry>Yes</entry>
> >>+	  </row>
> >>+	  <row>
> >>+	    <entry><constant>V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS</constant></entry>
> >>+	    <entry>0x1002</entry>
> >>+	    <entry>Bounds of the automatic focus region of interest. All valid
> >>+	    automatic focus rectangles fit inside the automatic focus bounds
> >>+	    rectangle.</entry>
> >>+	    <entry>Yes</entry>
> >>+	    <entry>Yes</entry>
> >>+	  </row>
> >>  	</tbody>
> >>        </tgroup>
> >>      </table>
> >>@@ -158,7 +174,28 @@
> >>  	</tbody>
> >>        </tgroup>
> >>      </table>
> >>+  </section>
> >>+
> >>+  <section>
> >>+      <title>Automatic focus regions of interest</title>
> >>+
> >>+      <para>The camera automatic focus algorithms may require configuration
> >>+      of a region or multiple regions of interest in form of rectangle or spot
> >>+      coordinates.</para>
> >>+
> >>+      <para>A single rectangle of interest is represented in &v4l2-rect;
> >>+      by the coordinates of the top left corner and the rectangle size. Both
> >>+      the coordinates and sizes are expressed in pixels. When the <structfield>
> >>+      width</structfield> and <structfield>height</structfield> fields of
> >>+      &v4l2-rect; are set to 0 the selection determines spot coordinates,
> >>+      rather than a rectangle.</para>
> >>+      <para>Auto focus rectangles are reset to their default values when the
> >>+      output image format is modified. Drivers should use the output image size
> >>+      as the auto focus rectangle default value, but hardware requirements may
> >>+      prevent this.
> >>+      </para>
> >>+      <para>The auto focus selections on input pads are not defined.</para>
> >>    </section>
> >>  </section>
> >>diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> >>index 1ba9e99..95e759f 100644
> >>--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> >>+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> >>@@ -57,8 +57,8 @@
> >>      <para>The selections are used to configure various image
> >>      processing functionality performed by the subdevs which affect the
> >>-    image size. This currently includes cropping, scaling and
> >>-    composition.</para>
> >>+    image size. This currently includes cropping, scaling, composition
> >>+    and automatic focus regions of interest.</para>
> >AF window does not affect image size. :-)
> >
> >Also, on subdevs one needs to ask the question which other rectangle the AF
> >window is related to. On video nodes it's obvious that it's the captured
> >format (or is it?), but on subdevs I could imagine it might be related to
> >almost any rectangle, depending on hardware.
> >
> >One option would be to add a new field to tell the parent window.
> When user sets AF spot/rectangle his decision is based on what he receives,
> ie the output image. So I would prefer to stick the AF window to the
> output format of the source pad.

The source format should describe the format that's the output of the
subdev. In this case that'd be statistics, so I don't think using source
format as the parent for the statistics window would be meaningful.

I wouldn't define the parent rectangle (or format) yet. The selection API
may well be useful in configuring statistics generation, and we may well use
it for that. However we have no implementation on that yet (not even an
implementation that would use a video node to provide statistics to the user
space), so we shouldn't define something that we don't strictly need and
that also may make life difficult in future.

So I propose to leave this undefined for the time being.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
