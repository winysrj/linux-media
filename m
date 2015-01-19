Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:44997 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbASKuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 05:50:24 -0500
Message-ID: <1421664620.1222.207.camel@xylophone.i.decadent.org.uk>
Subject: Re: [RFC PATCH 5/5] media: rcar_vin: move buffer management to
 .stop_streaming handler
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 19 Jan 2015 10:50:20 +0000
In-Reply-To: <Pine.LNX.4.64.1501182141400.23540@axis700.grange>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
	 <1418914215.22813.18.camel@xylophone.i.decadent.org.uk>
	 <Pine.LNX.4.64.1501182141400.23540@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2015-01-18 at 22:23 +0100, Guennadi Liakhovetski wrote:
> On Thu, 18 Dec 2014, Ben Hutchings wrote:
> 
> > From: William Towle <william.towle@codethink.co.uk>
> > 
> > Move the buffer state test in the .buf_cleanup handler into
> > .stop_streaming so that a) the vb2_queue API is not subverted, and
> > b) tracking of active-state buffers via priv->queue_buf[] is handled
> > as early as is possible
> 
> Huh... Sorry, patches 1, 2, 3, and 5 of this series look like a strange 
> way to get from the present state to the destination. They all have to be 
> merged IMHO. 
[...]

Well, I thought that too.  Will's submission from last week has that
change:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/87009

Ben.


