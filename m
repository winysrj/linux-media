Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58702 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752383AbdBTNJy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 08:09:54 -0500
Date: Mon, 20 Feb 2017 15:09:13 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [PATCH 1/4] v4l2: device_register_subdev_nodes: allow calling
 multiple times
Message-ID: <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170220103114.GA9800@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Mon, Feb 20, 2017 at 11:31:14AM +0100, Pavel Machek wrote:
> Hi!
> 
> On Tue 2017-02-14 23:38:49, Pavel Machek wrote:
> > From: Sebastian Reichel <sre@kernel.org>
> > 
> > If v4l2_device_register_subdev_nodes() is called multiple times, it is
> > better to return early than corrupt memory.
> > 
> > Without this, exposure / gain controls do not work in the camera
> > application on N900.
> > 
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> Can I get some updates/feedback here?
> 
> You liked this one and whole series should be ready...

:-)

I was just rebasing the CCP2 support on the fwnode patchset.

I'm just pushing the result here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=ccp2>

I've tested ACPI, will test DT soon...

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
