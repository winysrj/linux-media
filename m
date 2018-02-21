Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44586 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754438AbeBUMu0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 07:50:26 -0500
Date: Wed, 21 Feb 2018 14:50:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 12/15] media: zero reservedX fields in media_v2_topology
Message-ID: <20180221125024.x4eflswo72vumobr@valkosipuli.retiisi.org.uk>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
 <20180219103806.17032-13-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180219103806.17032-13-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 19, 2018 at 11:38:03AM +0100, Hans Verkuil wrote:
> The MEDIA_IOC_G_TOPOLOGY implementation did not zero the reservedX fields.
> Fix this.
> 
> Found with v4l2-compliance.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
