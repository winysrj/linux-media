Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:27876 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab3GQMJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 08:09:27 -0400
From: =?ISO-8859-1?Q?B=E5rd?= Eirik Winther <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 4/4] qv4l2: add OpenGL video render
Date: Wed, 17 Jul 2013 14:09:23 +0200
Message-ID: <1513301.Oklq3zxSl2@bwinther>
In-Reply-To: <201307171303.44303.hansverk@cisco.com>
References: <201307171303.44303.hansverk@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Wednesday, July 17, 2013 01:03:44 PM you wrote:
> Hi Bård,
> 
> On Tuesday 16 July 2013 14:59:04 Bard Eirik Winther wrote:
> > On Tuesday, July 16, 2013 02:01:45 PM you wrote:
> > > Hi Bård,
> > > 
> > > Thank you for the patches.
> > > 
> > > On Tuesday 16 July 2013 13:24:08 Bård Eirik Winther wrote:
> > > > The qv4l2 test utility now supports OpenGL-accelerated display of video.
> > > > This allows for using the graphics card to render the video content to
> > > > screen and to performing color space conversion.
> > > > 
> > > > Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
> > > > ---
> > > > 
> > > >  configure.ac                |   8 +-
> > > >  utils/qv4l2/Makefile.am     |   9 +-
> > > >  utils/qv4l2/capture-win.cpp | 559 +++++++++++++++++++++++++++++++++++--
> > > >  utils/qv4l2/capture-win.h   |  81 ++++++-
> > > >  utils/qv4l2/qv4l2.cpp       | 173 +++++++++++---
> > > >  utils/qv4l2/qv4l2.h         |   8 +
> > > >  6 files changed, 782 insertions(+), 56 deletions(-)
> > > 
> > > Is there a chance you could split the OpenGL code to separate classes, in
> > > a
> > > separate source file ? This would allow implementing other renderers, such
> > > as KMS planes on embedded devices.
> > 
> > Hi.
> > 
> > Do you mean to separate the GL class only or all the different
> > shaders/renderes as well?
> 
> Basically, what would be nice to get is an easy way to extend qv4l2 with 
> different renderers. OpenGL is fine on the desktop, but for embedded devices a 
> KMS planes backend would work best given the mess that the embedded GPU 
> situation is. Instead of adding #ifdef ENABLE_OGL and if (use_ogl) through the 
> code, abstracting the rendering code in a separate base class that renderers 
> could inherit from would make the code simpler to read, maintain and extend.
> 
> I haven't looked at the details so I'm not sure how much work that would be, 
> but if the effort is reasonable I think it would be a nice improvement.
> 
> 
I belive I have found a workable solution that should not take that much of time to implement.
The current interface for adding more render/display options is simply to extend this class:

class CaptureCanvas {
public:
        CaptureCanvas(){}
        virtual ~CaptureCanvas();

        virtual void setFrame(int width, int height, unsigned char *data, __u32 format);
        virtual void start();
        virtual void stop();
        virtual void hasNativeFormat(__u32 format);
        virtual static bool isSupportedRender();
};

It should cover any needs for display afaik, but then again I do not know every system that exists which might require more interaction.
