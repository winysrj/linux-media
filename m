Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34006 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753719AbeBVMqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 07:46:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 11/11] media: i2c: ov7670: Fully set mbus frame fmt
Date: Thu, 22 Feb 2018 14:47:06 +0200
Message-ID: <4525290.Vz7vJ24K7t@avalon>
In-Reply-To: <20180222123600.GM7203@w540>
References: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org> <2864762.IPlziE6Y0S@avalon> <20180222123600.GM7203@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thursday, 22 February 2018 14:36:00 EET jacopo mondi wrote:
> On Thu, Feb 22, 2018 at 02:14:53PM +0200, Laurent Pinchart wrote:
> > On Thursday, 22 February 2018 14:04:12 EET jacopo mondi wrote:
> >> On Wed, Feb 21, 2018 at 10:28:06PM +0200, Laurent Pinchart wrote:
> >>> On Tuesday, 20 February 2018 10:58:57 EET jacopo mondi wrote:

[snip]

> >>>> This actually makes me wonder if those informations (ycbcb_enc,
> >>>> quantization and xfer_func) shouldn't actually be part of the
> >>>> supported format list... I blindly added those default fields in the
> >>>> try_fmt function, but I doubt they applies to all supported formats.
> >>>> 
> >>>> Eg. the sensor supports YUYV as well as 2 RGB encodings (RGB444 and
> >>>> RGB 565) and 1 raw format (BGGR). I now have a question here:
> >>>> 
> >>>> 1) ycbcr_enc transforms non-linear R'G'B' to Y'CbCr: does this
> >>>> applies to RGB and raw formats? I don't think so, and what value is
> >>>> the correct one for the ycbcr_enc field in this case? I assume
> >>>> xfer_func and quantization applies to all formats instead..
> >>> 
> >>> There's no encoding for RGB formats if I understand things correctly,
> >>> so I'd set ycbcr_enc to V4L2_YCBCR_ENC_DEFAULT. The transfer function
> >>> and the quantization apply to all formats, but I'd be surprised to find
> >>> a sensor outputting limited range for RGB.
> >> 
> >> Ack, we got the same understanding for RGB formats. I wonder if for
> >> those formats we wouldn't need a V4L2_YCBCR_ENC_NONE or similar...
> > 
> > That, or explicitly documenting that when the format is not YUV the field
> > should be set by both drivers and applications to V4L2_YCBCR_ENC_DEFAULT
> > when written and ignored when read.
> 
> Well, if no encoding is performed because the color encoding scheme is
> RGB, the colorspace does anyway define an encoding method, so it seems
> to me the latter is more appropriate (use DEFAULT and ignore when read).
> 
> That's anyway just my opinion, but I could send a patch for
> documentation and see what feedback it gets.
> 
> >>> Have you been able to check whether the sensor outputs limited range
> >>> of full range YUV ? If it outputs full range you can hardcode
> >>> quantization to V4L2_QUANTIZATION_FULL_RANGE for all formats.
> >> 
> >> In YUYV mode, I see values > 0xf0 ( > 240, which is the max value for
> >> CbCr samples in limited quantization range), so I assume quantization
> >> is full range.
> > 
> > It should be, yes. What's the minimum and maximum values you get ?
> 
> From a white surface:
> min = 0x39
> max = 0xfc
> 
> From a black surface:
> min = 0x00 (with 62 occurrences)
> max = 0x8b
> 
> I guess that's indeed full range quantization

Could you check Y and UV separately ?

#!/usr/bin/python
  
import sys

def main(argv):
    if len(argv) != 2:
        print('Usage: %s <file>' % argv[0])
        return 1

    data = open(argv[1], 'rb').read()

    y_min = 255
    y_max = 0
    uv_min = 255
    uv_max = 0

    for i in range(len(data) // 2):
        y = data[2*i]
        uv = data[2*i]

        y_min = min(y_min, y)
        y_max = max(y_max, y)
        uv_min = min(uv_min, uv)
        uv_max = max(uv_max, uv)

    print('Y [%u, %u] UV [%u, %u]' % (y_min, y_max, uv_min, uv_max))
    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))

> > > Actually the hardest part here was having a white enough surface to
> > > point the sensor to :)
> > 
> > Pointing a flashlight to the sensor usually does the trick.
> 
> I had a yellowish light that didn't work that well, I ended up putting
> a white paper sheet in front of it and then took the picture.

Time to get a white flashlight ? :-)

-- 
Regards,

Laurent Pinchart
