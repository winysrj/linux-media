Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34760 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751982AbdDCKpR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 06:45:17 -0400
Date: Mon, 3 Apr 2017 13:45:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] subdev-formats.rst: remove spurious '-'
Message-ID: <20170403104511.GC3207@valkosipuli.retiisi.org.uk>
References: <2a9e644e-3c20-4d51-8caa-310c81d7f7c2@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a9e644e-3c20-4d51-8caa-310c81d7f7c2@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 03, 2017 at 12:05:45PM +0200, Hans Verkuil wrote:
> Remove spurious duplicate '-' in the Bayer Formats description. This resulted in a
> weird dot character that also caused the row to be double-height.
> 
> The - character was probably used originally as indicator of an unused bit, but as the
> number of columns was increased it was never used for the new columns.
> 
> Other tables do not use '-' either, so just remove it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
