Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:33679 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751720AbdFIOV0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 10:21:26 -0400
Date: Fri, 9 Jun 2017 09:21:23 -0500
From: Rob Herring <robh@kernel.org>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mark.rutland@arm.com, kernel@pengutronix.de, mchehab@kernel.org,
        hverkuil@xs4all.nl, p.zabel@pengutronix.de,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v8 02/34] [media] dt-bindings: Add bindings for i.MX
 media driver
Message-ID: <20170609142123.qo2fcxipwg2vdkts@rob-hp-laptop>
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
 <1496860453-6282-3-git-send-email-steve_longerbeam@mentor.com>
 <18997640-8cbd-734d-160e-a930f887d14f@gmail.com>
 <c7edc53b-bdfc-4a82-1c6c-70bf1c4db84a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7edc53b-bdfc-4a82-1c6c-70bf1c4db84a@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 08, 2017 at 10:08:35AM -0700, Steve Longerbeam wrote:
> 
> 
> On 06/08/2017 09:45 AM, Steve Longerbeam wrote:
> > Hi Rob, Mark,
> > 
> > Are there any remaining technical issues with this
> > binding doc? At this point an Ack from you is the only
> > thing holding up merge of the imx-media driver.
> > 
> > 
> 
> Note that the Synopsys core in the i.MX6 is a differently configured
> Synopsys core from the core as described in the bindings at [1].
> 
> Russell King provided more information on the differences between these
> cores at [2]. They are essentially different devices.
> 
> So perhaps the "snps,dw-mipi-csi2" compatibility needs to be removed
> from this binding, for now, until this driver is moved to drivers/media/
> and is made compatible with other MIPI CSI-2 Synopsys cores with
> different configurations.

Yes, it probably should be dropped. With that,

Acked-by: Rob Herring <robh@kernel.org>
