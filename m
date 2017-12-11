Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43600 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbdLKWN5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 17:13:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH v2 08/26] media: v4l2-async: shut up an unitialized symbol warning
Date: Tue, 12 Dec 2017 00:13:59 +0200
Message-ID: <2408989.XGnSUWAzJY@avalon>
In-Reply-To: <20171211161058.6cdedb7a@vento.lan>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com> <1844403.anYkCZaVIn@avalon> <20171211161058.6cdedb7a@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday, 11 December 2017 20:10:58 EET Mauro Carvalho Chehab wrote:
> Em Thu, 02 Nov 2017 04:51:40 +0200 Laurent Pinchart escreveu:
> > On Wednesday, 1 November 2017 23:05:45 EET Mauro Carvalho Chehab wrote:
> >> Smatch reports this warning:
> >> 	drivers/media/v4l2-core/v4l2-async.c:597 v4l2_async_register_subdev()
> >> 
> >> error: uninitialized symbol 'ret'.
> >> 
> >> However, there's nothing wrong there. So, just shut up the
> >> warning.
> > 
> > Nothing wrong, really ? ret does seem to be used uninitialized when the
> > function returns at the very last line.
> 
> There's nothing wrong. If you follow the logic, you'll see that
> the line:
> 
> 	return ret;
> 
> is called only at "err_unbind" label, with is called only on
> two places:
> 
>                 ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
>                 if (ret)
>                         goto err_unbind;
> 
>                 ret = v4l2_async_notifier_try_complete(notifier);
>                 if (ret)
>                         goto err_unbind;
> 
> There, ret is defined.
> 
> Yeah, the logic there is confusing.

I had missed the return 0 just before the error label. Sorry for the noise.

-- 
Regards,

Laurent Pinchart
