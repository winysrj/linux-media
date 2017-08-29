Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49220 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750822AbdH2Iet (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 04:34:49 -0400
Date: Tue, 29 Aug 2017 11:34:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v5 3/7] media: open.rst: remove the minor number range
Message-ID: <20170829083446.pn6ktsqs2o5kkyts@valkosipuli.retiisi.org.uk>
References: <cover.1503924361.git.mchehab@s-opensource.com>
 <3c844b9d2b5ed9dc3a398c6e1166fad0ee44cd54.1503924361.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c844b9d2b5ed9dc3a398c6e1166fad0ee44cd54.1503924361.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 28, 2017 at 09:53:57AM -0300, Mauro Carvalho Chehab wrote:
> minor numbers use to range between 0 to 255, but that
> was changed a long time ago. While it still applies when
> CONFIG_VIDEO_FIXED_MINOR_RANGES, when the minor number is
> dynamically allocated, this may not be true. In any case,
> this is not relevant, as udev will take care of it.
> 
> So, remove this useless misinformation.
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
