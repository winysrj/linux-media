Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53930 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932301AbdERMFG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 08:05:06 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [RFC PATCH v2 1/4] media: i2c: adv748x: add adv748x driver
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6aba7dbe2cdecc1afe6efc25fd0cea3f26508b1d.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170512164633.GL3227@valkosipuli.retiisi.org.uk>
 <399f5310-1270-40a0-843a-3a07ebf47f38@ideasonboard.com>
 <20170516115430.GN3227@valkosipuli.retiisi.org.uk>
 <76dee3f6-0187-1b9d-06ea-d49d85741d14@ideasonboard.com>
 <20170516222622.GQ3227@valkosipuli.retiisi.org.uk>
 <8db3955c-27fb-7c99-baa9-6337af7befac@ideasonboard.com>
Cc: Kieran Bingham <kbingham@kernel.org>,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        gennarone@gmail.com
Message-ID: <550d08a6-a8af-975e-156e-b6daaa2923ef@ideasonboard.com>
Date: Thu, 18 May 2017 13:04:55 +0100
MIME-Version: 1.0
In-Reply-To: <8db3955c-27fb-7c99-baa9-6337af7befac@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

>>> In omap3isp/isp.c: isp_fwnodes_parse() the async notifier is registered looking
>>> at the endpoints parent fwnode:
>>>
>>> 		isd->asd.match.fwnode.fwnode =
>>> 			fwnode_graph_get_remote_port_parent(fwnode);
>>>
>>> This would therefore not support ADV748x ... (it wouldn't know which TX/CSI
>>> entity to match against)
>>>
>>> So the way I see it is that all devices which currently register an async
>>> notifier should now register the match against the endpoint instead of the
>>> parent device:
>>>
>>>  - isd->asd.match.fwnode.fwnode = fwnode_graph_get_remote_port_parent(fwnode);
>>>  + isd->asd.match.fwnode.fwnode = fwnode;
>>>
>>> And then if we adapt the match to check against:
>>>    fwnode == fwnode || fwnode == fwnode_graph_get_remote_port_parent(fwnode);
>>
>> That's not enough as a master driver may use device node whereas the
>> sub-device driver uses endpoint node. You need to do it both ways.
>>

I've worked through this and I'm convinced that it should not be both ways...

We are matching a Subdevice (SD) to an Async Subdevice Notifier (ASD)

Bringing in 'endpoints' gives us the following match combinations


  SD   ASD   : Result
  ep   ep    : Match ... Subdevices can specify their endpoint node.
                Notifiers can be updated to also specify the (remote) endpoint.

  dev  ep    : Match  - We should take the parent of the ASD to match SD,
                to support subdevices which default to their device node.

  dev  dev   : Match - This is the current case for all other drivers
                but Notifier ASDs can be converted to EP's

  ep   dev   : No Match - We should *not* take the parent of the SD
                If a subdevice has specified it's endpoint, (ADV748x)
                Matching against the parent device is invalid.

Finding and matching the parent of the SD would allow a driver to register a
notifier ASD with a dev node, and expect to match a subdevice that has
registered it's subdev with an EP node. This would erroneously allow drivers to
register a notifier that would match against *both* of the ADV748x CSI2 entities.

I have posted an implementation of this as:
 [PATCH v1 3/3] v4l: async: Match parent devices [0]

I believe this to be correct - but I'm aware that I'm only really considering
the OF side here... Please let me know if there's something I'm not taking into
account.

[0] https://www.spinics.net/lists/linux-media/msg115677.html

Regards
--
Kieran
