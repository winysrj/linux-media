Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37320 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750939AbeCIJYV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 04:24:21 -0500
Date: Fri, 9 Mar 2018 11:24:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH 2/2] media: v4l2-core: get rid of videobuf-dvb
Message-ID: <20180309092417.ujuzk76mvinyobse@valkosipuli.retiisi.org.uk>
References: <dd7ed7485c5c2bdff0aa157579ed578e19e8f178.1520584203.git.mchehab@s-opensource.com>
 <149554ed3a9b0b9ace8f34d49b22676560c69e0b.1520584203.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149554ed3a9b0b9ace8f34d49b22676560c69e0b.1520584203.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 09, 2018 at 05:30:48AM -0300, Mauro Carvalho Chehab wrote:
> Videobuf has been replaced by videobuf2. Now, no drivers use
> the videobuf-dvb helper module anymore. So, get rid of it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Nice set!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
