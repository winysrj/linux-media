Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:36144 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbeKAWHP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 18:07:15 -0400
Subject: Re: i.MX6: can't capture on MIPI-CSI2 with DS90UB954
To: Jean-Michel Hautbois <jhautbois@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <CAL8zT=g1dquRZC=ZNO97nYjoX47JrZAUVrwJ+xVcR6LcmwY22g@mail.gmail.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
        <kieran.bingham@ideasonboard.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <9ec2a051-c1d4-ae82-d125-4e74437a2c97@mentor.com>
Date: Thu, 1 Nov 2018 15:04:05 +0200
MIME-Version: 1.0
In-Reply-To: <CAL8zT=g1dquRZC=ZNO97nYjoX47JrZAUVrwJ+xVcR6LcmwY22g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

On 10/30/2018 06:41 PM, Jean-Michel Hautbois wrote:
> Hi there,
> 
> I am using the i.MX6D from Digi (connect core 6 sbc) with a mailine
> kernel (well, 4.14 right now) and have an issue with mipi-csi2
> capture.
> First I will give brief explanation of my setup, and then I will
> detail the issue.
> I have a camera sensor (OV2732, but could be any other sensor)
> connected on a DS90UB953 FPD-Link III serializer.
> Then a coax cable propagates the signal to a DS90UB954 FPD-Link III
> deserializer.
> 
> The DS90UB954 has the ability to work in a pattern generation mode,
> and I will use it for the rest of the discussion.
> It is an I²C device, and I have written a basic driver (for the moment
> ;)) in order to make it visible on the imx6-mipi-csi2 bus as a camera
> sensor.
> I can give an access to the driver if necessary.

It's sort of indirectly related, anyway, I utterly hope that the
generic IC drivers will be ready and accepted for v4.21, see 
https://lwn.net/ml/devicetree/20181008211205.2900-1-vz@mleia.com/

Adding more ICs and cell devices to the framework is appreciated, 
in the queue there are DS90UB913, DS90Ux929, DS90Ux947, DS90UB964.

Steve, in case if you're unaware, that's FYI also.

--
Best wishes,
Vladimir
