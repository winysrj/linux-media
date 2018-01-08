Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54074 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751326AbeAHVN1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 16:13:27 -0500
Date: Mon, 8 Jan 2018 23:13:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        niklas.soderlund@ragnatech.se, Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Archit Taneja <architt@codeaurora.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] v4l: doc: Clarify v4l2_mbus_fmt height definition
Message-ID: <20180108211322.ilzzgde4vh2eozsf@valkosipuli.retiisi.org.uk>
References: <1515434106-18747-1-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515434106-18747-1-git-send-email-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for the update.

On Mon, Jan 08, 2018 at 05:55:24PM +0000, Kieran Bingham wrote:
> The v4l2_mbus_fmt width and height corresponds directly with the
> v4l2_pix_format definitions, yet the differences in documentation make
> it ambiguous what to do in the event of field heights.
> 
> Clarify this using the same text as is provided for the v4l2_pix_format
> which is explicit on the matter, and by matching the terminology of
> 'image height' rather than the misleading 'frame height'.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
