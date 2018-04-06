Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39589 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbeDFPz5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 11:55:57 -0400
Message-ID: <1523030155.32493.3.camel@pengutronix.de>
Subject: Re: [PATCH] media: coda: do not try to propagate format if capture
 queue busy
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ian Arkver <ian.arkver.dev@gmail.com>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Date: Fri, 06 Apr 2018 17:55:55 +0200
In-Reply-To: <47c0d3df-1632-c4fd-f9c0-699e89cd0d99@gmail.com>
References: <20180328171243.28599-1-p.zabel@pengutronix.de>
         <47c0d3df-1632-c4fd-f9c0-699e89cd0d99@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ian,

On Fri, 2018-04-06 at 09:40 +0100, Ian Arkver wrote: 
> > -	ret = coda_try_fmt_vid_cap(file, priv, &f_cap);
> > -	if (ret)
> > -		return ret;
> > -
> > -	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > -	r.left = 0;
> > -	r.top = 0;
> > -	r.width = q_data_src->width;
> > -	r.height = q_data_src->height;
> > -
> > -	return coda_s_fmt(ctx, &f_cap, &r);
> > +	return coda_s_fmt_vid_cap(file, priv, &f_cap);
> 
> Is this chunk (and removal of q_data_src above) part of the same patch? 
> It doesn't seem covered by the subject line.

You are right, I'll move this into a separate patch.

thanks
Philipp
