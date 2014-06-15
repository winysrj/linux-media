Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:51202 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaFOTUv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 15:20:51 -0400
Date: Sun, 15 Jun 2014 21:20:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Ben Dooks <ben.dooks@codethink.co.uk>, linux-media@vger.kernel.org
Subject: Re: soc_camera and device-tree
In-Reply-To: <87ioo2tgnb.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.1406152117080.28029@axis700.grange>
References: <87ppibtes8.fsf@free.fr> <Pine.LNX.4.64.1406142256010.23099@axis700.grange>
 <87ioo2tgnb.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Sun, 15 Jun 2014, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Hi Robert,
> >
> > On Sat, 14 Jun 2014, Robert Jarzmik wrote:
> >
> >> Hi Guennadi,
> >> 
> >> I'm slowly converting all of my drivers to device-tree.
> >> In the process, I met ... soc_camera.
> >> 
> >> I converted mt9m111.c and pxa_camera.c, but now I need the linking
> >> soc_camera. And I don't have a clear idea on how it should be done.
> >
> > Have a look at this thread
> >
> > http://thread.gmane.org/gmane.linux.ports.sh.devel/34412/focus=36244
> 
> Ah excellent, job's done before working, just as I like it :)

Sorry to disappoint you, but it's not quite done yet. Have a look at the 
thread, at the last mails, we're still waiting for an updated version. 
Feel free to propose one yourself, I don't think Ben will have anything 
against this. Or maybe he'll prefer to submit an update himself, doesn't 
matter that much for me.

Thanks
Guennadi

> Just a couple of remarks :
>  - in Ben's serie, there is/are call(s) to v4l2_of_get_next_endpoint().
>    This was recently replaced with of_graph_get_next_endpoint().
>    Same story for v4l2_of_get_remote_port() replaced by
>    of_graph_get_remote_port().
> 
>    See commit "[media] of: move graph helpers from drivers/media/v4l2-core to
>    drivers/of", commit id fd9fdb7.
> 
>  - the clock "mclk" topic
>    There will be cases where this SoC clock won't be available in the common
>    clock framework, ie. not in drivers/clk. For example the PXA architecture is
>    not yet ported to the commmon clk framework (it's in the staging).
>    So we should be carefull to not assume common clock framework is available.
> 
>  - the testing coverage
>    For the next spin I'd like to be joined to the list of reviewers/testers. As
>    I'm testing it for another couple of host/icd, that will grow up the test
>    base.
> 
> Cheers.
> 
> --
> Robert
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
