Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33242 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbdESPUW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 11:20:22 -0400
Subject: Re: [RFC PATCH v2 1/4] media: i2c: adv748x: add adv748x driver
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6aba7dbe2cdecc1afe6efc25fd0cea3f26508b1d.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170512164633.GL3227@valkosipuli.retiisi.org.uk>
 <399f5310-1270-40a0-843a-3a07ebf47f38@ideasonboard.com>
 <20170516115430.GN3227@valkosipuli.retiisi.org.uk>
 <76dee3f6-0187-1b9d-06ea-d49d85741d14@ideasonboard.com>
 <20170516222622.GQ3227@valkosipuli.retiisi.org.uk>
 <8db3955c-27fb-7c99-baa9-6337af7befac@ideasonboard.com>
 <550d08a6-a8af-975e-156e-b6daaa2923ef@ideasonboard.com>
 <20170518211240.GY3227@valkosipuli.retiisi.org.uk>
Cc: Kieran Bingham <kbingham@kernel.org>,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        gennarone@gmail.com
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <da801e78-6120-85b4-e683-0f7af015484f@ideasonboard.com>
Date: Fri, 19 May 2017 16:20:07 +0100
MIME-Version: 1.0
In-Reply-To: <20170518211240.GY3227@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

>>
>> Finding and matching the parent of the SD would allow a driver to register a
>> notifier ASD with a dev node, and expect to match a subdevice that has
>> registered it's subdev with an EP node. This would erroneously allow drivers to
>> register a notifier that would match against *both* of the ADV748x CSI2 entities.
> 
> You'd first have to have a board that has the two devices, and then ignore
> what the drivers are doing. :-) I guess an error would be encountered at
> some point in driver initialisation.

Ah yes of course - I see it now...

The only erroneous case is a scenario that should be fixed by whomever wants to
use that. Where as the rest of the "ep - dev" matches become a master driver
which has not converted to endpoint matching, during the phase of which
subdevices have.

Adding this in for v3, along with the rebase to your acpi-graph-cleaned.

> 
> Anyway, I don't think this situation should be a lasting one, and that
> endpoint matching is the way to go.

Yes, of course hopefully we'll make a full transition along the way.

--
Regards

Kieran
