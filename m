Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38686 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751420AbdIEJpb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Sep 2017 05:45:31 -0400
Date: Tue, 5 Sep 2017 12:45:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Aviv Greenberg <aviv.d.greenberg@intel.com>
Subject: Re: [PATCH 1/2] docs-rst: media: Don't use \small for
 V4L2_PIX_FMT_SRGGB10 documentation
Message-ID: <20170905094528.w3wvvccgzwm2lukv@valkosipuli.retiisi.org.uk>
References: <a9f55d8af529d904db475134271a37ab70ac5d38.1504557671.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9f55d8af529d904db475134271a37ab70ac5d38.1504557671.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Sep 04, 2017 at 05:41:27PM -0300, Mauro Carvalho Chehab wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> There appears to be an issue in using \small in certain cases on Sphinx
> 1.4 and 1.5. Other format documents don't use \small either, remove it
> from here as well.
> 
> [mchehab@s-opensource.com: kept tabularcolumns - readjusted - and
>  add a few blank lines for it to display better]
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks!

For both:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
