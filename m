Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55030 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752755AbdI1MyB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 08:54:01 -0400
Date: Thu, 28 Sep 2017 15:53:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [RESEND PATCH v2 13/17] media: v4l2-async: simplify
 v4l2_async_subdev structure
Message-ID: <20170928125358.pkolmjxc4hdqcrud@valkosipuli.retiisi.org.uk>
References: <cover.1506548682.git.mchehab@s-opensource.com>
 <cd089c6dac22c8ea2194c47c48386e52bb6e561f.1506548682.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd089c6dac22c8ea2194c47c48386e52bb6e561f.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Sep 27, 2017 at 06:46:56PM -0300, Mauro Carvalho Chehab wrote:
> The V4L2_ASYNC_MATCH_FWNODE match criteria requires just one
> struct to be filled (struct fwnode_handle). The V4L2_ASYNC_MATCH_DEVNAME
> match criteria requires just a device name.
> 
> So, it doesn't make sense to enclose those into structs,
> as the criteria can go directly into the union.
> 
> That makes easier to document it, as we don't need to document
> weird senseless structs.

The idea is that in the union, there's a struct which is specific to the
match_type field. I wouldn't call it senseless.

In the two cases there's just a single field in the containing struct. You
could remove the struct in that case as you do in this patch, and just use
the field. But I think the result is less clean and so I wouldn't make this
change.

The confusion comes possibly from the fact that the struct is named the
same as the field in the struct. These used to be called of and node, but
with the fwnode property framework the references to the fwnode are, well,
typically similarly called "fwnode". There's no underlying firmware
interface with that name, fwnode property API is just an API.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
