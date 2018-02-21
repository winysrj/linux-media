Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44574 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753192AbeBUMt6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 07:49:58 -0500
Date: Wed, 21 Feb 2018 14:49:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 10/15] media-device.c: zero reserved fields
Message-ID: <20180221124954.4tgygs34mpl3s2ze@valkosipuli.retiisi.org.uk>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
 <20180219103806.17032-11-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180219103806.17032-11-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 19, 2018 at 11:38:01AM +0100, Hans Verkuil wrote:
> MEDIA_IOC_SETUP_LINK didn't zero the reserved field of the media_link_desc
> struct. Do so in media_device_setup_link().
> 
> MEDIA_IOC_ENUM_LINKS didn't zero the reserved field of the media_links_enum
> struct. Do so in media_device_enum_links().
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

If you haven't sent a pull request including your patch "media-device: zero
reserved media_links_enum field", could you add it to the next version of
this set (or the same pull request)?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
