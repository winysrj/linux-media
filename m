Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40082 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750839AbaJIL4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Oct 2014 07:56:22 -0400
Date: Thu, 9 Oct 2014 14:55:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com
Subject: Re: [RFC PATCH 00/11] Add configuration store support
Message-ID: <20141009115542.GZ2939@valkosipuli.retiisi.org.uk>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the set, and my apologies for taking a look only now.

On Sun, Sep 21, 2014 at 04:48:18PM +0200, Hans Verkuil wrote:
> This patch series adds support for configuration stores to the control
> framework. This allows you to store control values for a particular
> configuration (up to VIDEO_MAX_FRAME configuration stores are currently
> supported). When you queue a new buffer you can supply the store ID and
> the driver will apply all controls for that configuration store.
> 
> When you set a new value for a configuration store then you can choose
> whether this is 'fire and forget', i.e. after the driver applies the
> control value for that store it won't be applied again until a new value
> is set. Or you can set the value every time that configuration store is
> applied.

This does work for video device nodes but not for sub-device nodes which
have no buffer queues. Also if you think of using just a value from the
closest video buffer queue, that doesn't work either since there could be
more than one of those.

Most of the time the controls that need to be applied on per-frame basis are
present in embedded systems with complex media pipelines where most of the
controls are present on sub-device nodes.

In other words this approach alone is not sufficient to bind control related
configurations to individual frames. For preparing and applying
configurations it is applicable.

Thinking about the Android camera API v3, controls are a part of the picture
only: capture requests contain buffer sets as well. I think the concept
makes sense also outside Android. Let's discuss this further at the Media
summit.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
