Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45130 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1424648AbdD1H7r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 03:59:47 -0400
Date: Fri, 28 Apr 2017 10:59:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [bug] omap3isp: missing support for ENUM_FMT
Message-ID: <20170428075940.GD7456@valkosipuli.retiisi.org.uk>
References: <20161228183036.GA13139@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170304153946.GA3220@valkosipuli.retiisi.org.uk>
 <2578197.Jc2St0chTa@avalon>
 <20170426211933.GA13593@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170426211933.GA13593@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Wed, Apr 26, 2017 at 11:19:33PM +0200, Pavel Machek wrote:
> Hi!
> 
> Currently, ispvideo.c does not support enum_format. This causes
> problems for example for libv4l2.
> 
> Now, I'm pretty sure patch below is not the right fix. But it fixes
> libv4l2 problem for me.
> 
> Pointer to right solution welcome.

The issue with providing ENUM_FMT support on MC-enabled drivers is that the
media bus format has an effect to which pixel formats are available.

What has been discussed in the past but what remains unimplemented is to add
the media bus code to v4l2_fmtdesc for user to choose. That would allow
meaningful ENUM_FMT support.

For users such as libv4l2, i.e. code == 0 --- it should just tell the user
what it can do with the active media bus format.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
