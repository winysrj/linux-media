Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46560 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754388AbeBUOR2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 09:17:28 -0500
Date: Wed, 21 Feb 2018 16:17:26 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 10/15] media-device.c: zero reserved fields
Message-ID: <20180221141726.vdbydu64p2vkdjuo@valkosipuli.retiisi.org.uk>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
 <20180219103806.17032-11-hverkuil@xs4all.nl>
 <20180221124954.4tgygs34mpl3s2ze@valkosipuli.retiisi.org.uk>
 <8c18e38e-11f4-3779-3767-f3001afec053@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c18e38e-11f4-3779-3767-f3001afec053@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 21, 2018 at 02:17:37PM +0100, Hans Verkuil wrote:
> On 02/21/18 13:49, Sakari Ailus wrote:
> > On Mon, Feb 19, 2018 at 11:38:01AM +0100, Hans Verkuil wrote:
> >> MEDIA_IOC_SETUP_LINK didn't zero the reserved field of the media_link_desc
> >> struct. Do so in media_device_setup_link().
> >>
> >> MEDIA_IOC_ENUM_LINKS didn't zero the reserved field of the media_links_enum
> >> struct. Do so in media_device_enum_links().
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > If you haven't sent a pull request including your patch "media-device: zero
> > reserved media_links_enum field", could you add it to the next version of
> > this set (or the same pull request)?
> 
> It's folded into this patch. It made no sense to have that in a separate patch.
> 

Ah, indeed it is. Then please ignore my comment apart from the ack.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
