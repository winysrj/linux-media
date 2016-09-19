Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:17319 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S936368AbcISCGi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Sep 2016 22:06:38 -0400
Message-ID: <1474250793.25758.8.camel@mtksdaap41>
Subject: Re: [PATCH v2 2/4] docs-rst: Add compressed video formats used on
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
Date: Mon, 19 Sep 2016 10:06:33 +0800
In-Reply-To: <e0d40ba4-a53e-72ca-0c45-2ab578922d9c@xs4all.nl>
References: <1473436087-21943-1-git-send-email-tiffany.lin@mediatek.com>
         <1473436087-21943-2-git-send-email-tiffany.lin@mediatek.com>
         <1473436087-21943-3-git-send-email-tiffany.lin@mediatek.com>
         <e0d40ba4-a53e-72ca-0c45-2ab578922d9c@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, 2016-09-14 at 13:51 +0200, Hans Verkuil wrote:
> Hi Tiffany,
> 
> On 09/09/2016 05:48 PM, Tiffany Lin wrote:
> > Add V4L2_PIX_FMT_MT21C documentation
> > 
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> > ---
> >  Documentation/media/uapi/v4l/pixfmt-reserved.rst |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> > index 0dd2f7f..0989e99 100644
> > --- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> > +++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> > @@ -339,7 +339,17 @@ please make a proposal on the linux-media mailing list.
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
> > +          The compression is lossless.
> > +          It is an opaque intermediate format, and MDP HW could convert
> 
> Is it OK if I change this to:
> 
> " and the MDP hardware must be used to convert"
> 

Yes. It's better to make it more clear how to use MT21C.
Thanks for the help.

> > +          V4L2_PIX_FMT_MT21C to V4L2_PIX_FMT_NV12M,
> > +          V4L2_PIX_FMT_YUV420M and V4L2_PIX_FMT_YVU420.
> 
> and here "and" should be replaced by "or".
> 
Yes. it should be "or". Sorry about that.


best regards,
Tiffany

> Regards,
> 
> 	Hans
> 
> >  
> >  .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
> >  
> > 


