Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54407 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab3GPNER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 09:04:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bard Eirik Winther <bwinther@cisco.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH 4/4] qv4l2: add OpenGL video render
Date: Tue, 16 Jul 2013 15:05 +0200
Message-ID: <3035536.XabkRYWs1N@avalon>
In-Reply-To: <6029532.8F5QMT0oxE@bwinther>
References: <1373973848-4084-1-git-send-email-bwinther@cisco.com> <1609457.OFIJZjqBDN@avalon> <6029532.8F5QMT0oxE@bwinther>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bård,

On Tuesday 16 July 2013 14:59:04 Bard Eirik Winther wrote:
> On Tuesday, July 16, 2013 02:01:45 PM you wrote:
> > Hi Bård,
> > 
> > Thank you for the patches.
> > 
> > On Tuesday 16 July 2013 13:24:08 Bård Eirik Winther wrote:
> > > The qv4l2 test utility now supports OpenGL-accelerated display of video.
> > > This allows for using the graphics card to render the video content to
> > > screen and to performing color space conversion.
> > > 
> > > Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
> > > ---
> > > 
> > >  configure.ac                |   8 +-
> > >  utils/qv4l2/Makefile.am     |   9 +-
> > >  utils/qv4l2/capture-win.cpp | 559 +++++++++++++++++++++++++++++++++++--
> > >  utils/qv4l2/capture-win.h   |  81 ++++++-
> > >  utils/qv4l2/qv4l2.cpp       | 173 +++++++++++---
> > >  utils/qv4l2/qv4l2.h         |   8 +
> > >  6 files changed, 782 insertions(+), 56 deletions(-)
> > 
> > Is there a chance you could split the OpenGL code to separate classes, in
> > a
> > separate source file ? This would allow implementing other renderers, such
> > as KMS planes on embedded devices.
> 
> Hi.
> 
> Do you mean to separate the GL class only or all the different
> shaders/renderes as well?

Basically, what would be nice to get is an easy way to extend qv4l2 with 
different renderers. OpenGL is fine on the desktop, but for embedded devices a 
KMS planes backend would work best given the mess that the embedded GPU 
situation is. Instead of adding #ifdef ENABLE_OGL and if (use_ogl) through the 
code, abstracting the rendering code in a separate base class that renderers 
could inherit from would make the code simpler to read, maintain and extend.

I haven't looked at the details so I'm not sure how much work that would be, 
but if the effort is reasonable I think it would be a nice improvement.

-- 
Regards,

Laurent Pinchart

