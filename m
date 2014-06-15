Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:29938 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaFOOCe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 10:02:34 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-media@vger.kernel.org
Subject: Re: soc_camera and device-tree
References: <87ppibtes8.fsf@free.fr>
	<Pine.LNX.4.64.1406142256010.23099@axis700.grange>
Date: Sun, 15 Jun 2014 16:02:32 +0200
In-Reply-To: <Pine.LNX.4.64.1406142256010.23099@axis700.grange> (Guennadi
	Liakhovetski's message of "Sat, 14 Jun 2014 22:58:27 +0200 (CEST)")
Message-ID: <87ioo2tgnb.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi Robert,
>
> On Sat, 14 Jun 2014, Robert Jarzmik wrote:
>
>> Hi Guennadi,
>> 
>> I'm slowly converting all of my drivers to device-tree.
>> In the process, I met ... soc_camera.
>> 
>> I converted mt9m111.c and pxa_camera.c, but now I need the linking
>> soc_camera. And I don't have a clear idea on how it should be done.
>
> Have a look at this thread
>
> http://thread.gmane.org/gmane.linux.ports.sh.devel/34412/focus=36244

Ah excellent, job's done before working, just as I like it :)

Just a couple of remarks :
 - in Ben's serie, there is/are call(s) to v4l2_of_get_next_endpoint().
   This was recently replaced with of_graph_get_next_endpoint().
   Same story for v4l2_of_get_remote_port() replaced by
   of_graph_get_remote_port().

   See commit "[media] of: move graph helpers from drivers/media/v4l2-core to
   drivers/of", commit id fd9fdb7.

 - the clock "mclk" topic
   There will be cases where this SoC clock won't be available in the common
   clock framework, ie. not in drivers/clk. For example the PXA architecture is
   not yet ported to the commmon clk framework (it's in the staging).
   So we should be carefull to not assume common clock framework is available.

 - the testing coverage
   For the next spin I'd like to be joined to the list of reviewers/testers. As
   I'm testing it for another couple of host/icd, that will grow up the test
   base.

Cheers.

--
Robert
