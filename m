Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:47096 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbeJPCr5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 22:47:57 -0400
Received: by mail-lf1-f66.google.com with SMTP id p143-v6so3876860lfp.13
        for <linux-media@vger.kernel.org>; Mon, 15 Oct 2018 12:01:24 -0700 (PDT)
Date: Mon, 15 Oct 2018 21:01:21 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCH v3 1/4] dt-bindings: media: i2c: Add bindings for Maxim
 Integrated MAX9286
Message-ID: <20181015190121.GI24305@bigcity.dyn.berto.se>
References: <20181009205726.7664-1-kieran.bingham@ideasonboard.com>
 <20181009205726.7664-2-kieran.bingham@ideasonboard.com>
 <20181015164524.kazxgbxwsc3abxok@valkosipuli.retiisi.org.uk>
 <71c30ead-66cd-2c84-3349-0dd393f66300@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71c30ead-66cd-2c84-3349-0dd393f66300@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On 2018-10-15 18:37:40 +0100, Kieran Bingham wrote:

> >> diff --git 
> >> a/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt 
> >> b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
> >> new file mode 100644
> >> index 000000000000..a73e3c0dc31b
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
> >> @@ -0,0 +1,182 @@
> >> +Maxim Integrated Quad GMSL Deserializer
> >> +---------------------------------------
> >> +
> >> +The MAX9286 deserializer receives video data on up to 4 Gigabit Multimedia
> >> +Serial Links (GMSL) and outputs them on a CSI-2 port using up to 4 data lanes.
> > 
> > CSI-2 D-PHY I presume?
> 
> Yes, that's how I've adapted the driver based on the latest bus changes.
> 
> Niklas - Could you confirm that everything in VIN/CSI2 is configured to
> use D-PHY and not C-PHY at all ?

Yes it's only D-PHY.

> >> +
> >> +- remote-endpoint: phandle to the remote GMSL source endpoint subnode in the
> >> +  remote node port.
> >> +
> >> +Required Endpoint Properties for CSI-2 Output Port (Port 4):
> >> +
> >> +- data-lanes: array of physical CSI-2 data lane indexes.
> >> +- clock-lanes: index of CSI-2 clock lane.
> > 
> > Is any number of lanes supported? How about lane remapping? If you do not
> > have lane remapping, the clock-lanes property is redundant.
> 
> 
> Uhm ... Niklas?

The MAX9286 documentation contains information on lane remapping and 
support for any number (1-4) of enabled data-lanes. I have not tested if 
this works in practice but the registers are there and documented :-)

-- 
Regards,
Niklas Söderlund
