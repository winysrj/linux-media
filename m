Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:55319 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab2AaRJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 12:09:06 -0500
Date: Tue, 31 Jan 2012 19:09:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	g.liakhovetski@gmx.de, teturtia@gmail.com
Subject: [ANN] Notes on subdev selections API on #v4l-meeting 2012-01-31
Message-ID: <20120131170900.GD16140@valkosipuli.localdomain>
References: <20120129180641.GA16140@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120129180641.GA16140@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

We had a meeting on #v4l-meeting on the topic of subdev selections, and I
can summarise the conclusions as follows. The full meeting log is available
in [3].

Two main topics were discussed, the behaviour and functionality of the
selection API and the naming of different rectangles. A conclusion was
reached in both.

- The sink COMPOSE rectangle in my latest proposal [1] is a hardware limit
rather than something user configurable. This means the rectangle is
correctly considered as COMPOSE BOUNDS target in V4L2 selection API as
well.

  - This is actually correct in the previous proposal [2].

  - There are no dependencies between sink / source pad coordinates as such:
  both refer to the coordinates of the sink COMPOSE BOUNDS rectangle. Source
  CROP BOUNDS also refer to the same, and this rectangle might be different
  from sink COMPOSE BOUNDS rectangle.

- The COMPOSE rectangle will, as it was in the previous proposal, continue
to be called the COMPOSE rectangle (and not SCALING rectangle).

- The definition of the BOUNDS rectangle is "smallest rectangle which
contains all valid ACTIVE rectangles". This does not specify what is the
largest possible ACTIVE rectangle.

- It was agreed to drop DEFAULT targets for now. The same had been done
to PADDED targets already previously.

- More documentation is needed: a few sample use cases to be included into
documentation.

- No need for COMPOSE on source pads, so COMPOSE rectangle is will not be a
valid target on source pads. Sylwester's use case [4], composing into video
buffers, can be equally implemented using the compose rectangle on the sink
pad. It is to be discussed should this be rather implemented using the
selection API on the video node instead. The source pad image size will be
equal to the size of the source crop rectangle.

- Information to the diagram on what rectangles refer to which coordinates
to be added.

I will also make the necessary changes to my selection patchset and re-post
it.

[1] http://www.spinics.net/lists/linux-media/msg43723.html

[2] http://www.spinics.net/lists/linux-media/msg42991.html

[3] http://www.retiisi.org.uk/v4l2/notes/v4l2-selection-api-2012-01-31.txt

[4] http://www.spinics.net/lists/linux-media/msg43746.html

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
