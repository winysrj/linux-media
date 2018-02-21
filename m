Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44610 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753291AbeBUMvJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 07:51:09 -0500
Date: Wed, 21 Feb 2018 14:51:07 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 13/15] media: document the reservedX fields in
 media_v2_topology
Message-ID: <20180221125106.ieqf5l5tebfgyvo2@valkosipuli.retiisi.org.uk>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
 <20180219103806.17032-14-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180219103806.17032-14-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 19, 2018 at 11:38:04AM +0100, Hans Verkuil wrote:
> The MEDIA_IOC_G_TOPOLOGY documentation didn't document the reservedX
> fields. Related to that was that the documented type of the num_* fields
> was also wrong.
> 
> Fix both.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
