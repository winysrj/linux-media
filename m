Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59362 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbeACLV5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 06:21:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/9] dt-bindings: media: Add Renesas CEU bindings
Date: Wed, 03 Jan 2018 13:22:18 +0200
Message-ID: <6187057.jxUe24LMpy@avalon>
In-Reply-To: <20180103084952.GA9493@w540>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <6263435.xWGUCtEJC1@avalon> <20180103084952.GA9493@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wednesday, 3 January 2018 10:49:52 EET jacopo mondi wrote:
> On Tue, Jan 02, 2018 at 01:45:30PM +0200, Laurent Pinchart wrote:
> > On Thursday, 28 December 2017 16:01:13 EET Jacopo Mondi wrote:
> >> Add bindings documentation for Renesas Capture Engine Unit (CEU).
> >> 
> >> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> ---
> >> 
> >>  .../devicetree/bindings/media/renesas,ceu.txt      | 85 +++++++++++++++
> >>  1 file changed, 85 insertions(+)
> >>  create mode 100644
> >>  Documentation/devicetree/bindings/media/renesas,ceu.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt
> >> b/Documentation/devicetree/bindings/media/renesas,ceu.txt new file mode
> >> 100644
> >> index 0000000..f45628e
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> >> @@ -0,0 +1,85 @@
> >>+Renesas Capture Engine Unit (CEU)
> >> +----------------------------------------------
> >> +
> >> +The Capture Engine Unit is the image capture interface found on Renesas
> >> +RZ chip series and on SH Mobile ones.
> > 
> > "ones" sound a bit weird. How about "... found in the Renesas SH Mobil and
> > RZ SoCs." ?
> > 
> >> +The interface supports a single parallel input with data bus width up
> >> to
> >> +8/16 bits.
> > 
> > What do you mean by "up to 8/16 bits" ?
> 
> The input bus width can be 8 or 16 bit.

Then how about writing it "The CEU supports a single parallel input with a 
data bus width of 8 or 16 bits." ?

> On a general note: I always assumed DT bindings should describe the
> hardware capabilities. In this case the hardware supports 8 or 16 bits
> as input width, but the driver only cares about the 8 bits case. Which
> one should I describe here?

You should describe the hardware.

> I will fix all of yours and Geert's remarks in V3.

[snip]

-- 
Regards,

Laurent Pinchart
