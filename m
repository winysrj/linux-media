Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:32888 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751008AbdDCJ3R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 05:29:17 -0400
Date: Mon, 3 Apr 2017 12:28:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-ctrls.c: fix RGB quantization range control menu
Message-ID: <20170403092842.GB3207@valkosipuli.retiisi.org.uk>
References: <32481bd6-1c56-43f1-f3fb-7ec99b4c8503@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32481bd6-1c56-43f1-f3fb-7ec99b4c8503@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 03, 2017 at 10:21:07AM +0200, Hans Verkuil wrote:
> All control menus use the english capitalization rules of titles.
> 
> The only menu not following these rules is the RGB Quantization Range control
> menu. Fix this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
