Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41869 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3DLKRO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 06:17:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christian Rhodin <Crhodin@aptina.com>, linux-media@vger.kernel.org
Subject: Re: Pixel Formats
Date: Fri, 12 Apr 2013 12:17:15 +0200
Message-ID: <1521576.ES8kTFfaXd@avalon>
In-Reply-To: <Pine.LNX.4.64.1303072227570.20470@axis700.grange>
References: <B4589F7BF62FDC409F64E48C95EC0572113A6BFC@sjcaex01.aptad.aptina.com> <Pine.LNX.4.64.1303072227570.20470@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(A bit late, sorry)

On Thursday 07 March 2013 22:37:26 Guennadi Liakhovetski wrote:
> On Wed, 6 Mar 2013, Christian Rhodin wrote:
> > Hi,
> > 
> > I'm looking for some guidance on the correct way to handle a new pixel
> > format.  What I'm dealing with is a CMOS image sensor that supports
> > dynamic switching between linear and iHDR modes.  iHDR stands for
> > "interlaced High Dynamic Range" and is a mode where odd and even lines
> > have different exposure times, typically with an 8:1 ratio.  When I
> > started implementing a driver for this sensor I used
> > "V4L2_MBUS_FMT_SGRBG10_1X10" as the format for the linear mode and
> > defined a new format "V4L2_MBUS_FMT_SGRBG10_IHDR_1X10" for the iHDR
> > mode.  I used the format to control which mode I put the sensor in.  But
> > now I'm having trouble switching modes without reinitializing the
> > sensor.  Does anyone (everyone?) have an opinion about the correct way
> > to implement this?  I'm thinking that the format is overloaded because
> > it represents both the size and type of the data.  Should I use a single
> > format and add a control to switch the mode?
> 
> I would vote for a single format with a control, maybe even somehow
> cluster it with the normal exposure, but I'm not an expert in that, not
> sure if it would make sense.

>From the above explanation about iHDR I assume that enabling iHDR mode 
produces an image with the same resolution as linear mode, not an image with 8 
times the number of lines compared to the linear mode. Please correct me if 
I'm wrong.

If my understanding of iHDR mode is correct, I agree with Guennadi. I don't 
think enabling iHDR changes the format, it "just" modifies the exposure time 
algorithm. A V4L2 control would thus be better than adding an iHDR variant to 
all existing formats.

-- 
Regards,

Laurent Pinchart

