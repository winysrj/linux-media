Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:37722 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab0BRCcq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 21:32:46 -0500
Message-ID: <4B7CA679.40906@oracle.com>
Date: Wed, 17 Feb 2010 18:31:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	g.liakhovetski@gmx.de
Subject: Re: [PATCH 0/4] DocBook additions for V4L new formats
References: <4B7C2203.1000707@redhat.com>
In-Reply-To: <4B7C2203.1000707@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/17/10 09:06, Mauro Carvalho Chehab wrote:
> Adds DocBook items for Bayer and two proprietary formats used on gspca.
> 
> In the past, a few targets were generated at the Mercurial development
> tree. However, at the beginning of this year, we moved to use -git as
> the primary resource. So, the Makefile logic to autogenerate those
> targets needs to be moved to git as well.
> 
> While here, I noticed that DocBook is too verbose to generate the
> htmldocs target. So, make it less verbose, if V=0.
> 
> Guennadi Liakhovetski (1):
>   V4L/DVB: v4l: document new Bayer and monochrome pixel formats
> 
> Mauro Carvalho Chehab (3):
>   DocBook/Makefile: Make it less verbose
>   DocBook: Add rules to auto-generate some media docbooks
>   DocBook/v4l/pixfmt.xml: Add missing formats for gspca cpia1 and
>     sn9c2028 drivers

Hi Mauro,

Patches 1 & 3 are OK.

I'm having problems with patch 2/4 when I use O=DOCDIR on the make command
(which I always do).  videodev2.h.xml is not being generated, and after
that it goes downhill.

I will let you know more when I have more info, or you or Guennadi can send
a fixup patch for that.



>  Documentation/DocBook/Makefile               |  493 +++++++-
>  Documentation/DocBook/dvb/frontend.h.xml     |  415 ------
>  Documentation/DocBook/media-entities.tmpl    |  383 ------
>  Documentation/DocBook/media-indices.tmpl     |   89 --
>  Documentation/DocBook/v4l/pixfmt-srggb10.xml |   90 ++
>  Documentation/DocBook/v4l/pixfmt-srggb8.xml  |   67 +
>  Documentation/DocBook/v4l/pixfmt-y10.xml     |   79 ++
>  Documentation/DocBook/v4l/pixfmt.xml         |   18 +-
>  Documentation/DocBook/v4l/videodev2.h.xml    | 1757 --------------------------
>  9 files changed, 738 insertions(+), 2653 deletions(-)
>  delete mode 100644 Documentation/DocBook/dvb/frontend.h.xml
>  delete mode 100644 Documentation/DocBook/media-entities.tmpl
>  delete mode 100644 Documentation/DocBook/media-indices.tmpl
>  create mode 100644 Documentation/DocBook/v4l/pixfmt-srggb10.xml
>  create mode 100644 Documentation/DocBook/v4l/pixfmt-srggb8.xml
>  create mode 100644 Documentation/DocBook/v4l/pixfmt-y10.xml
>  delete mode 100644 Documentation/DocBook/v4l/videodev2.h.xml
> 


-- 
~Randy
