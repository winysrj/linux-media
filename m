Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36508 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751135AbdH1Jg0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 05:36:26 -0400
Date: Mon, 28 Aug 2017 12:36:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] cobalt: do not register subdev nodes
Message-ID: <20170828093623.jk6sxiov6kxc7dp2@valkosipuli.retiisi.org.uk>
References: <d913ad14-79e1-1c2d-e692-4941ccf9b9a5@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d913ad14-79e1-1c2d-e692-4941ccf9b9a5@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 28, 2017 at 10:45:58AM +0200, Hans Verkuil wrote:
> In the distant past the adv7604 driver used private controls. In order to access
> them the v4l-subdevX nodes were needed. Later the is_private tag was removed in
> the adv7604 driver and the need for v4l-subdevX device nodes disappeared.
> 
> Remove the creation of those device nodes from this driver.
> 
> Note: the cobalt card is only used inside Cisco and we never actually used the
> v4l-subdevX nodes for anything. So this API change can be done safely without
> breaking anything.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
