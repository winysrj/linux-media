Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37962 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751167AbcIULeC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 07:34:02 -0400
Date: Wed, 21 Sep 2016 14:33:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 5/7] ov7670: add devicetree support
Message-ID: <20160921113328.GD18295@valkosipuli.retiisi.org.uk>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
 <1471415383-38531-6-git-send-email-hverkuil@xs4all.nl>
 <3513546.0HAk52lbkG@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3513546.0HAk52lbkG@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Aug 17, 2016 at 03:44:00PM +0300, Laurent Pinchart wrote:
> > +			assigned-clock-rates = <24000000>;
> 
> You should compute and set the clock rate dynamically in the driver, not 
> hardcode it in DT.

This frequency is typically defined by hardware engineers and it's
hand-picked from possible ranges. What counts is EMC so you don't disturb
a GSM/3G/4G modem (if you have one) or GPS receiver, for instance. In order
to freely choose this frequency, you'd also need to be aware of the limits
of the sensor's internal clock tree, and make sure you still would be able
to obtain the desired frame rates for there are often corner cases where the
resulting maximum pixel clock may be substantially lower if your input
frequency goes up.

I also haven't encountered a use case for more than a single, fixed
frequency. In other words I'd keep this constant.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
