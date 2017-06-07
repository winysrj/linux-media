Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51531
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751670AbdFGJzG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 05:55:06 -0400
Date: Wed, 7 Jun 2017 06:54:52 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        hverkuil@xs4all.nl
Subject: Re: [PATCH v3 5/7] docs-rst: media: Sort topic list alphabetically
Message-ID: <20170607065452.5faeb157@vento.lan>
In-Reply-To: <4d1b8a9a-af82-c72d-3554-f1844d5a5b08@linux.intel.com>
References: <1491829376-14791-1-git-send-email-sakari.ailus@linux.intel.com>
        <1491829376-14791-6-git-send-email-sakari.ailus@linux.intel.com>
        <20170606094834.0152cd6f@vento.lan>
        <4d1b8a9a-af82-c72d-3554-f1844d5a5b08@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 6 Jun 2017 23:57:55 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
> 
> Mauro Carvalho Chehab wrote:
> > Em Mon, 10 Apr 2017 16:02:54 +0300
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >  
> >> Bring some order by alphabetically ordering the list of topics.
> >>
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> ---
> >>  Documentation/media/kapi/v4l2-core.rst | 18 +++++++++---------
> >>  1 file changed, 9 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
> >> index d8f6c46..2fbf532 100644
> >> --- a/Documentation/media/kapi/v4l2-core.rst
> >> +++ b/Documentation/media/kapi/v4l2-core.rst
> >> @@ -4,23 +4,23 @@ Video4Linux devices
> >>  .. toctree::
> >>      :maxdepth: 1
> >>
> >> -    v4l2-intro  
> >
> > NACK.
> >
> > The order of the documentation should match what makes sense for the
> > user that will be reading the docs, and *not* an alphabetical order.  
> 
> I wrote the patch to address some of the review comments I got over the 
> several versions of the patchset. I have no objections to maintaining 
> the current order.

Yeah, developers love putting things in alphabetical order ;)

I remember I had myself the same doubt when I did conversions to ReST :-)
See changeset 58759874002a71cbd48a01b615a210bb474e1f2b: there, everything
but the introduction document (v4l2-framework - on that time) were in
alphabetical order:

+.. toctree::
+    :maxdepth: 1
+
+    v4l2-framework
+    v4l2-async
+    v4l2-controls
+    v4l2-device
+    v4l2-dv-timings
+    v4l2-event
+    v4l2-flash-led-class
+    v4l2-mc
+    v4l2-mediabus
+    v4l2-mem2mem
+    v4l2-of
+    v4l2-rect
+    v4l2-subdev
+    v4l2-tuner
+    v4l2-tveeprom
+    v4l2-videobuf2
+    v4l2-videobuf

However, after reading the documentation, it became clear to me that this
was not a good idea, as the first topic out of v4l2-framework was
V4L2 async framework (with is, IMHO, an "advanced" topic - as not every 
"citizen" needs it). On the other hand, VB/VB2 were the last ones. 
Clearly, VB2 were misplaced, and should come before v4l2-async.

So, the topics were reorganized at changeset f6fa883bb733 to place the
more commonly used categories of functions at the beginning, and the
less used ones at the end.

That's said, the current order may not be perfect. IMHO, we should
some day use multiple TOC trees, adding a description before each
one.

It would also make sense to improve VB2 documentation (currently, it
has only 256 bytes with just include kernel headers), based on what's
written at VB book (with is a real framework description), and move VB
to a legacy section (or remove it, after we get rid of the last driver
using it).

Thanks,
Mauro
