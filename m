Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:37453 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751419Ab0I0H6r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 03:58:47 -0400
Date: Mon, 27 Sep 2010 09:58:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v1 0/9] Sub-device pad-level operations
In-Reply-To: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1009270958090.16377@axis700.grange>
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 26 Sep 2010, Laurent Pinchart wrote:

> Hi everybody,
> 
> Here's the first version of the sub-device pad-level operations patches (this
> is actually not strictly true, as other versions have been posted before as
> sample code, but this one is the first version officially sent for public
> review).
> 
> Anyway, try to enjoy the documentation (I've spent quite a lot of time on it,
> and it's not the most enjoyable part of kernel development, so be nice :-)).
> Guennadi, don't forget that you owe me a drink for documenting your media bus
> format codes :-)

Any time, Laurent, any time;)

Guennadi

> 
> If you're careful enough during the review (I shouldn't have said that, it
> could have been a test) you will notice that the cropping behaviour on subdev
> output pads isn't defined. This one requires some brainstorming, which by
> definition I can't do alone. Comments are, as usual, more than welcome.
> 
> The patches apply on top of the "RFC/PATCH v3 V4L2 subdev userspace API" and
> "RFC/PATCH v5 Media controller (core and V4L2)" patch series. They are available
> from the http://git.linuxtv.org/pinchartl/media.git git tree (media-000*
> branches).
> 
> Antti Koskipaa (1):
>   v4l: v4l2_subdev userspace crop API
> 
> Laurent Pinchart (7):
>   v4l: Move the media/v4l2-mediabus.h header to include/linux
>   v4l: Group media bus pixel codes by types and sort them
>     alphabetically
>   v4l: Add 8-bit YUYV on 16-bit bus and SGRBG10 media bus pixel codes
>   v4l: Add remaining RAW10 patterns w DPCM pixel code variants
>   v4l: v4l2_subdev pad-level operations
>   v4l: v4l2_subdev userspace format API
>   v4l: v4l2_subdev userspace frame interval API
> 
> Stanimir Varbanov (1):
>   v4l: Create v4l2 subdev file handle structure
> 
>  Documentation/DocBook/Makefile                     |    5 +-
>  Documentation/DocBook/media-entities.tmpl          |   26 +
>  Documentation/DocBook/v4l/bayer.pdf                |  Bin 0 -> 12116 bytes
>  Documentation/DocBook/v4l/bayer.png                |  Bin 0 -> 9725 bytes
>  Documentation/DocBook/v4l/dev-subdev.xml           |  300 +++++
>  Documentation/DocBook/v4l/pipeline.png             |  Bin 0 -> 12130 bytes
>  Documentation/DocBook/v4l/subdev-formats.xml       | 1282 ++++++++++++++++++++
>  Documentation/DocBook/v4l/v4l2.xml                 |    7 +
>  Documentation/DocBook/v4l/vidioc-streamon.xml      |    9 +
>  .../v4l/vidioc-subdev-enum-frame-interval.xml      |  147 +++
>  .../DocBook/v4l/vidioc-subdev-enum-frame-size.xml  |  148 +++
>  .../DocBook/v4l/vidioc-subdev-enum-mbus-code.xml   |  113 ++
>  Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml |  143 +++
>  Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml  |  168 +++
>  .../DocBook/v4l/vidioc-subdev-g-frame-interval.xml |  135 ++
>  drivers/media/video/v4l2-subdev.c                  |  175 +++-
>  include/linux/Kbuild                               |    2 +
>  include/linux/v4l2-mediabus.h                      |   91 ++
>  include/linux/v4l2-subdev.h                        |  141 +++
>  include/media/soc_mediabus.h                       |    3 +-
>  include/media/v4l2-mediabus.h                      |   53 +-
>  include/media/v4l2-subdev.h                        |   53 +
>  22 files changed, 2919 insertions(+), 82 deletions(-)
>  create mode 100644 Documentation/DocBook/v4l/bayer.pdf
>  create mode 100644 Documentation/DocBook/v4l/bayer.png
>  create mode 100644 Documentation/DocBook/v4l/dev-subdev.xml
>  create mode 100644 Documentation/DocBook/v4l/pipeline.png
>  create mode 100644 Documentation/DocBook/v4l/subdev-formats.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-interval.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-frame-interval.xml
>  create mode 100644 include/linux/v4l2-mediabus.h
>  create mode 100644 include/linux/v4l2-subdev.h
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
