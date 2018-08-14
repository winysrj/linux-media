Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49500 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730488AbeHNLp0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:45:26 -0400
Date: Tue, 14 Aug 2018 05:59:09 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 14/34] v4l2-ctrls: add core request support
Message-ID: <20180814055909.358c19f9@coco.lan>
In-Reply-To: <18a32cb5-0cb8-164b-2112-8b76760a01fa@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-15-hverkuil@xs4all.nl>
        <20180813075530.1b3c7fe7@coco.lan>
        <18a32cb5-0cb8-164b-2112-8b76760a01fa@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Aug 2018 10:34:47 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> >> +void v4l2_ctrl_request_setup(struct media_request *req,
> >> +			     struct v4l2_ctrl_handler *main_hdl)
> >> +{
> >> +	struct media_request_object *obj;
> >> +	struct v4l2_ctrl_handler *hdl;
> >> +	struct v4l2_ctrl_ref *ref;
> >> +
> >> +	if (!req || !main_hdl)
> >> +		return;
> >> +
> >> +	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED))
> >> +		return;
> >> +
> >> +	obj = media_request_object_find(req, &req_ops, main_hdl);
> >> +	if (!obj)
> >> +		return;  
> > 
> > Shouldn't the above checks produce an error or print something at
> > the logs?  
> 
> Good question.
> 
> I think not. This situation would occur if the applications makes a request
> with only a buffer but no controls, thus making no changes to the controls in
> this request.
> 
> This is perfectly legal, so nothing needs to be logged here.

Ok, makes sense.

Please add a note at the source code explaining that, as this is
not obvious for a casual code reviewer.


Thanks,
Mauro
