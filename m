Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:2537 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752500AbcIHGoh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 02:44:37 -0400
Message-ID: <1473317069.22713.24.camel@mtksdaap41>
Subject: Re: [PATCH 2/4] docs-rst: Add compressed video formats used on
 MT8173 codec driver
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>
Date: Thu, 8 Sep 2016 14:44:29 +0800
In-Reply-To: <246f1aca-0b46-b2f1-edd0-158a2a07b1d9@xs4all.nl>
References: <1473231403-14900-1-git-send-email-tiffany.lin@mediatek.com>
         <1473231403-14900-2-git-send-email-tiffany.lin@mediatek.com>
         <1473231403-14900-3-git-send-email-tiffany.lin@mediatek.com>
         <246f1aca-0b46-b2f1-edd0-158a2a07b1d9@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, 2016-09-07 at 11:23 +0200, Hans Verkuil wrote:
> On 09/07/16 08:56, Tiffany Lin wrote:
> > Add V4L2_PIX_FMT_MT21C documentation
> >
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> > ---
> >  Documentation/media/uapi/v4l/pixfmt-reserved.rst |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> > index 0dd2f7f..2e21fbc 100644
> > --- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> > +++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> > @@ -339,7 +339,13 @@ please make a proposal on the linux-media mailing list.
> >  	  array. Anything what's in between the UYVY lines is JPEG data and
> >  	  should be concatenated to form the JPEG stream.
> >
> > +    -  .. _V4L2-PIX-FMT-MT21C:
> >
> > +       -  ``V4L2_PIX_FMT_MT21C``
> > +
> > +       -  'MT21C'
> > +
> > +       -  Compressed two-planar YVU420 format used by Mediatek MT8173.
> 
> This really needs to be expanded.
> 
> Ideally this should reference the precise specification of this format if
> available.
> 

> It certainly should explain which HW blocks of the mediatek SoC use this
> format, it should explain that is it meant as an opaque intermediate format
> between those blocks.
> 

Yes. it is an opaque intermediate format.
VDEC HW only output MT21C format, and it need MDP HW to convert to other
standard format.

At first, we plan to put "convert MT21C to other standard format" in our
v4l2 decoder driver, actually in VPU firmware.
In this case, there is no need to expose MT21C format to user space.

But consider that MDP is a stand alone HW (interrupt, power, clk),
combine decode and format convert in one decode step impact performance.
VDEC HW and MDP HW could process different frame at same time.
MDP may also used by other modules to do format convert, not only VDEC.

That's why we need to expose MT21C to user space.
When user space application enumerate VDEC and display HW and found that
the format is not match.
It need to use MDP driver to do format convert.


> If you have some characteristics (i.e. is it lossy or lossless 
> compression, I
> presume it's lossless), then that will be useful to add as well.
> 
I will update this in next version.


best regards,
Tiffany

> We like to have as much information about formats as possible.
> 
> Regards,
> 
> 	Hans
> 
> >
> >  .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
> >
> >


