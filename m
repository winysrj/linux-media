Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34982 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751548AbdLNMMN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 07:12:13 -0500
Date: Thu, 14 Dec 2017 14:12:10 +0200
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
Message-ID: <20171214121209.of2xvhzyezp2r46g@valkosipuli.retiisi.org.uk>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
 <1844403.anYkCZaVIn@avalon>
 <20171211161058.6cdedb7a@vento.lan>
 <2408989.XGnSUWAzJY@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2408989.XGnSUWAzJY@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

On Tue, Dec 12, 2017 at 12:13:59AM +0200, Laurent Pinchart wrote:
> Hi Mauro,
> 
> On Monday, 11 December 2017 20:10:58 EET Mauro Carvalho Chehab wrote:
> > Em Thu, 02 Nov 2017 04:51:40 +0200 Laurent Pinchart escreveu:
> > > On Wednesday, 1 November 2017 23:05:45 EET Mauro Carvalho Chehab wrote:
> > >> Smatch reports this warning:
> > >> 	drivers/media/v4l2-core/v4l2-async.c:597 v4l2_async_register_subdev()
> > >> 
> > >> error: uninitialized symbol 'ret'.
> > >> 
> > >> However, there's nothing wrong there. So, just shut up the
> > >> warning.
> > > 
> > > Nothing wrong, really ? ret does seem to be used uninitialized when the
> > > function returns at the very last line.
> > 
> > There's nothing wrong. If you follow the logic, you'll see that
> > the line:
> > 
> > 	return ret;
> > 
> > is called only at "err_unbind" label, with is called only on
> > two places:
> > 
> >                 ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
> >                 if (ret)
> >                         goto err_unbind;
> > 
> >                 ret = v4l2_async_notifier_try_complete(notifier);
> >                 if (ret)
> >                         goto err_unbind;
> > 
> > There, ret is defined.
> > 
> > Yeah, the logic there is confusing.
> 
> I had missed the return 0 just before the error label. Sorry for the noise.

I believe the matter has been addressed by this patch:

commit 580db6ca62c168733c6fd338cd2f0ebf39135283
Author: Colin Ian King <colin.king@canonical.com>
Date:   Fri Nov 3 02:58:27 2017 -0400

    media: v4l: async: fix return of unitialized variable ret
    
    A shadow declaration of variable ret is being assigned a return error
    status and this value is being lost when the error exit goto's jump
    out of the local scope. This leads to an uninitalized error return value
    in the outer scope being returned. Fix this by removing the inner scoped
    declaration of variable ret.
    
    Detected by CoverityScan, CID#1460380 ("Uninitialized scalar variable")
    
    Fixes: fb45f436b818 ("media: v4l: async: Fix notifier complete callback error handling")
    
    Signed-off-by: Colin Ian King <colin.king@canonical.com>
    Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
