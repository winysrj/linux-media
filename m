Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36990 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754287AbdJIUYj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 16:24:39 -0400
Date: Mon, 9 Oct 2017 23:24:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 10/24] media: v4l2-subdev: use kernel-doc markups to
 document subdev flags
Message-ID: <20171009202436.z73ve4534cnbulmc@valkosipuli.retiisi.org.uk>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <170d2a91bb05ae196ea65713e4f9cd179c7cc4b2.1507544011.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170d2a91bb05ae196ea65713e4f9cd179c7cc4b2.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Oct 09, 2017 at 07:19:16AM -0300, Mauro Carvalho Chehab wrote:
> Right now, those are documented together with the subdev struct,
> instead of together with the definitions.
> 
> Convert the definitions to an enum, use BIT() macros and document
> it at its right place.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

For patches 10--14:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
