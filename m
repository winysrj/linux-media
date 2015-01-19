Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53913 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbbASLME (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 06:12:04 -0500
Date: Mon, 19 Jan 2015 12:11:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ben Hutchings <ben.hutchings@codethink.co.uk>
cc: linux-media@vger.kernel.org, linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 5/5] media: rcar_vin: move buffer management to
 .stop_streaming handler
In-Reply-To: <1421664620.1222.207.camel@xylophone.i.decadent.org.uk>
Message-ID: <Pine.LNX.4.64.1501191208490.27578@axis700.grange>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
 <1418914215.22813.18.camel@xylophone.i.decadent.org.uk>
 <Pine.LNX.4.64.1501182141400.23540@axis700.grange>
 <1421664620.1222.207.camel@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Jan 2015, Ben Hutchings wrote:

> On Sun, 2015-01-18 at 22:23 +0100, Guennadi Liakhovetski wrote:
> > On Thu, 18 Dec 2014, Ben Hutchings wrote:
> > 
> > > From: William Towle <william.towle@codethink.co.uk>
> > > 
> > > Move the buffer state test in the .buf_cleanup handler into
> > > .stop_streaming so that a) the vb2_queue API is not subverted, and
> > > b) tracking of active-state buffers via priv->queue_buf[] is handled
> > > as early as is possible
> > 
> > Huh... Sorry, patches 1, 2, 3, and 5 of this series look like a strange 
> > way to get from the present state to the destination. They all have to be 
> > merged IMHO. 
> [...]
> 
> Well, I thought that too.  Will's submission from last week has that
> change:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/87009

Hm... interesting, why I didn't get those mails in my INBOX, although I do 
see myself in CC... Only got them from the list, and no, I don't have 
"avoid copies" enabled.

Anyway, yes, that looks better! But I would still consider keeping buffers 
on the list in .buf_clean(), in which case you can remove it. And walk the 
list instead of the VB2 internal buffer array, as others have pointed out.

Thanks
Guennadi
