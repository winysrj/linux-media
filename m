Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55646 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726141AbeKCHtS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Nov 2018 03:49:18 -0400
Date: Sat, 3 Nov 2018 00:40:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: jacopo mondi <jacopo@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCH v3 1/4] dt-bindings: media: i2c: Add bindings for Maxim
 Integrated MAX9286
Message-ID: <20181102224015.kszkxpch6gflqkx7@valkosipuli.retiisi.org.uk>
References: <20181009205726.7664-1-kieran.bingham@ideasonboard.com>
 <20181009205726.7664-2-kieran.bingham@ideasonboard.com>
 <20181015164524.kazxgbxwsc3abxok@valkosipuli.retiisi.org.uk>
 <71c30ead-66cd-2c84-3349-0dd393f66300@ideasonboard.com>
 <20181015193714.GG21294@w540>
 <cca2a23f-3e95-0902-3182-d1a551ebc9d8@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cca2a23f-3e95-0902-3182-d1a551ebc9d8@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Fri, Nov 02, 2018 at 01:29:54PM +0000, Kieran Bingham wrote:
...
> >>>> +Required endpoint nodes:
> >>>> +-----------------------
> >>>> +
> >>>> +The connections to the MAX9286 GMSL and its endpoint nodes are modeled using
> >>>> +the OF graph bindings in accordance with the video interface bindings defined
> >>>> +in Documentation/devicetree/bindings/media/video-interfaces.txt.
> >>>> +
> >>>> +The following table lists the port number corresponding to each device port.
> >>>> +
> >>>> +        Port            Description
> >>>> +        ----------------------------------------
> >>>> +        Port 0          GMSL Input 0
> >>>> +        Port 1          GMSL Input 1
> >>>> +        Port 2          GMSL Input 2
> >>>> +        Port 3          GMSL Input 3
> >>>> +        Port 4          CSI-2 Output
> >>>> +
> >>>> +Optional Endpoint Properties for GSML Input Ports (Port [0-3]):
> > 
> > I guess Sakari means s/3/4 here:                                 ^
> > 
> 
> That would be incorrect, because Port 4 is an output port, not an input
> port.
> 
> > Or didn't I get his questions and then neither your answer :) ?
> > 
> > Thanks
> >   j
> > 
> >>>
> >>> Isn't port 4 included?
> >>
> >> Hrm ... yes well I guess these are mandatory for port 4. I'll look at
> >> the wording here.
> 
> Port 4 does also need a remote-endpoint, but it is to a CSI2 sink
> endpoint node. Not a GMSL source endpoint node - hence it's not
> appropriate to just 's/3/4/' above.

Ah, right. And now I recall Rob's position has been that remote-endpoint
property doesn't really need documenting in per-device bindings as it's
part of the graph bindings anyway; just refer to the graph bindings ---
just like you refer to video-interfaces.txt.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
