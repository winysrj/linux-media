Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:1346 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757529AbcGKC4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 22:56:17 -0400
Message-ID: <1468205771.3725.8.camel@mtksdaap41>
Subject: Re: [PATCH v3 3/9] DocBook/v4l: Add compressed video formats used
 on MT8173 codec driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Mon, 11 Jul 2016 10:56:11 +0800
In-Reply-To: <5a793171-24a7-4e9e-8bfd-f668c789f8e0@xs4all.nl>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
	 <1464611363-14936-2-git-send-email-tiffany.lin@mediatek.com>
	 <1464611363-14936-3-git-send-email-tiffany.lin@mediatek.com>
	 <1464611363-14936-4-git-send-email-tiffany.lin@mediatek.com>
	 <5a793171-24a7-4e9e-8bfd-f668c789f8e0@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, 2016-07-08 at 12:23 +0200, Hans Verkuil wrote:
> On 05/30/2016 02:29 PM, Tiffany Lin wrote:
> > Add V4L2_PIX_FMT_MT21 documentation
> > 
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> > ---
> >  Documentation/DocBook/media/v4l/pixfmt.xml |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> > index 5a08aee..d40e0ce 100644
> > --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> > +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> > @@ -1980,6 +1980,12 @@ array. Anything what's in between the UYVY lines is JPEG data and should be
> >  concatenated to form the JPEG stream. </para>
> >  </entry>
> >  	  </row>
> > +	  <row id="V4L2_PIX_FMT_MT21">
> > +	    <entry><constant>V4L2_PIX_FMT_MT21</constant></entry>
> > +	    <entry>'MT21'</entry>
> > +	    <entry>Compressed two-planar YVU420 format used by Mediatek MT8173
> > +	    codec driver.</entry>
> 
> Can you give a few more details? The encoder driver doesn't seem to produce this
> format, so who is creating this? Where is this format documented?
> 

It can be as input format for encoder, MDP and display drivers in our
platform.
This private format is only available in our platform.
So I put it in "Reserved Format Identifiers" sections.


best regards,
Tiffany

> Regards,
> 
> 	Hans
> 
> > +	  </row>
> >  	</tbody>
> >        </tgroup>
> >      </table>
> > 


