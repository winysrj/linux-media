Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48363 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbeFDIe7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 04:34:59 -0400
Message-ID: <1528101294.5808.6.camel@pengutronix.de>
Subject: Re: [PATCH v2 10/10] media: imx.rst: Update doc to reflect fixes to
 interlaced capture
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Date: Mon, 04 Jun 2018 10:34:54 +0200
In-Reply-To: <fc9933d7-93d0-1e0c-ca63-70a4f3faf618@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
         <1527813049-3231-11-git-send-email-steve_longerbeam@mentor.com>
         <1527860665.5913.13.camel@pengutronix.de>
         <fc9933d7-93d0-1e0c-ca63-70a4f3faf618@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2018-06-02 at 11:44 -0700, Steve Longerbeam wrote:
> 
> On 06/01/2018 06:44 AM, Philipp Zabel wrote:
> > On Thu, 2018-05-31 at 17:30 -0700, Steve Longerbeam wrote:
> > <snip>
> > > +
> > > +.. code-block:: none
> > > +
> > > +   # Setup links
> > > +   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
> > > +   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> > > +   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> > > +   # Configure pads
> > > +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> > > +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
> > > +   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480 field:interlaced]"
> > 
> > Could the example suggest using interlaced-bt to be explicit here?
> > Actually, I don't think we should allow interlaced on the CSI src pads
> > at all in this case. Technically it always writes either seq-tb or seq-
> > bt into the smfc, never interlaced (unless the input is already
> > interlaced).
> > 
> 
> Hmm, if the sink is 'alternate', and the requested source is
> 'interlaced*', perhaps we should allow the source to be
> 'interlaced*' and not override it. For example, if requested
> is 'interlaced-tb', let it be that. IOW assume user knows something
> we don't about the original field order, or is experimenting
> with finding the correct field order.

If the source material is really interlaced and not alternate, shouldn't
the sink pad be set to interlaced?

regards
Philipp
