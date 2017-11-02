Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51716 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750917AbdKBItJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 04:49:09 -0400
Date: Thu, 2 Nov 2017 10:49:07 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH v2 08/26] media: v4l2-async: shut up an unitialized
 symbol warning
Message-ID: <20171102084906.pjlittllatltkvwv@valkosipuli.retiisi.org.uk>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
 <e510e9651f4c8672ab7f64df4a55863b4b9cb787.1509569763.git.mchehab@s-opensource.com>
 <1844403.anYkCZaVIn@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1844403.anYkCZaVIn@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 02, 2017 at 04:51:40AM +0200, Laurent Pinchart wrote:
> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Wednesday, 1 November 2017 23:05:45 EET Mauro Carvalho Chehab wrote:
> > Smatch reports this warning:
> > 	drivers/media/v4l2-core/v4l2-async.c:597 v4l2_async_register_subdev()
> > error: uninitialized symbol 'ret'.
> > 
> > However, there's nothing wrong there. So, just shut up the
> > warning.
> 
> Nothing wrong, really ? ret does seem to be used uninitialized when the 
> function returns at the very last line.

There's another ret defined in a block under this one; removing that is the
correct fix. I wonder why GCC didn't complain about that to begin with...
usually it does.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
