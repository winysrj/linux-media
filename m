Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35472 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752020AbdI2G0f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 02:26:35 -0400
Date: Fri, 29 Sep 2017 09:26:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 7/7] media: open.rst: add a notice about subdev-API on
 vdev-centric
Message-ID: <20170929062631.rjajujgbfhf6o6lz@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
 <628a25e694c33ab6dd1ea061bc4d766ec4fe30ef.1506550930.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <628a25e694c33ab6dd1ea061bc4d766ec4fe30ef.1506550930.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 27, 2017 at 07:23:49PM -0300, Mauro Carvalho Chehab wrote:
> The documentation doesn't mention if vdev-centric hardware
> control would have subdev API or not.
> 
> Add a notice about that, reflecting the current status, where
> three drivers use it, in order to support some subdev-specific
> controls.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
