Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57136 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755283AbcJQSoY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 14:44:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 54/57] [media] platform: don't break long lines
Date: Mon, 17 Oct 2016 21:44:19 +0300
Message-ID: <1555833.ll1z87MvFR@avalon>
In-Reply-To: <20161017193945.GA21569@stationary.pb.com>
References: <cover.1476475770.git.mchehab@s-opensource.com> <3227277.L9jDJkdF0E@avalon> <20161017193945.GA21569@stationary.pb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

On Monday 17 Oct 2016 20:39:45 Andrey Utkin wrote:
> On Mon, Oct 17, 2016 at 04:45:06PM +0300, Laurent Pinchart wrote:
> > If you really want to perform such a change, let's not make lines
> > unnecessarily long either. You should add a line break after the first and
> > 
> > second argument:
> > 		dprintk(ctx->dev,
> > 		
> > 			"%s data will not fit into plane(%lu < %lu)\n",
> > 			__func__, vb2_plane_size(vb, 0),
> > 			(long)q_data->sizeimage);
> > 
> > And everything will fit in 80 columns.
> 
> Same happens in other places, e.g. the hunk for
> cx8802_unregister_driver() in another patch in this series, and not just
> one time (looked just patches where I was a direct recipient).
> There is a printing function call with previously split string literal,
> followed by several arguments. This unnecessarily long function call is
> now a single line.
> Maybe the remaining manual work may be outsourced to seekers of janitor
> tasks?

I'm fine with that, but we should rework the original patches, not merge fixes 
on top of them.

-- 
Regards,

Laurent Pinchart

