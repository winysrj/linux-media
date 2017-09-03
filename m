Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52295
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751568AbdICTEA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 15:04:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Aviv Greenberg <aviv.d.greenberg@intel.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Vincent ABRIOU <vincent.abriou@st.com>
Subject: [PATCH 0/7] Another set of fixes for PDF output
Date: Sun,  3 Sep 2017 16:03:46 -0300
Message-Id: <cover.1504464984.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are other things that are needed for a proper PDF output,
and a fix for yet another Sphinx 1.6 breakage.

After this patch series, PDF output now looks OK on Sphinx 1.4 to 1.6.

There's, however, one step back on Sphinx 1.6: I couldn't find any
way to use a background color for notifications (note, attention,
important, etc).

In thesis, on Sphinx 1.6, this is natively supported. However, in
practice, support for it is broken: if a note is inserted inside a table,
it sometimes put at the wrong cell and with the wrong size.

I was not able to fix it there. Yet, it fails gracefully, as it will just
display those boxes on boring black on white. While, IMHO, it
fails to the idea of giving a highlight to the text, it is readable.

That is a shame, as, except for this, Sphinx 1.6 seems to produce
a better table output than previous versions, when cell span is
used. Also, less hacks at the latex_preamble are now required
on newer versions. Well, maybe some day we may be able to
remove all hacks on newer versions of it...


Mauro Carvalho Chehab (7):
  media: format.rst: use the right markup for important notes
  media: v4l2 uapi book: get rid of driver programming's chapter
  media: vivid.rst: add a blank line to correct ReST format
  media: vidioc-g-fmt.rst: adjust table format
  media: fix build breakage with Sphinx 1.6
  media: pixfmt*.rst: replace a two dots by a comma
  media: index.rst: don't write "Contents:" on PDF output

 Documentation/media/index.rst                    |  6 +++++-
 Documentation/media/uapi/v4l/driver.rst          |  9 ---------
 Documentation/media/uapi/v4l/format.rst          |  2 +-
 Documentation/media/uapi/v4l/pixfmt-m420.rst     |  2 +-
 Documentation/media/uapi/v4l/pixfmt-nv12.rst     |  2 +-
 Documentation/media/uapi/v4l/pixfmt-nv12m.rst    |  2 +-
 Documentation/media/uapi/v4l/pixfmt-nv16.rst     |  2 +-
 Documentation/media/uapi/v4l/pixfmt-nv16m.rst    |  2 +-
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst | 16 ++++++++++++++--
 Documentation/media/uapi/v4l/pixfmt-uyvy.rst     |  2 +-
 Documentation/media/uapi/v4l/pixfmt-vyuy.rst     |  2 +-
 Documentation/media/uapi/v4l/pixfmt-y41p.rst     |  2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv410.rst   |  2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv411p.rst  |  2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv420.rst   |  2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv420m.rst  |  2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv422m.rst  |  2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv422p.rst  |  2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv444m.rst  |  2 +-
 Documentation/media/uapi/v4l/pixfmt-yuyv.rst     |  2 +-
 Documentation/media/uapi/v4l/pixfmt-yvyu.rst     |  2 +-
 Documentation/media/uapi/v4l/v4l2.rst            |  1 -
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst    |  2 +-
 Documentation/media/v4l-drivers/vivid.rst        |  1 +
 24 files changed, 39 insertions(+), 32 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/driver.rst

-- 
2.13.5
