Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:49277 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXVDd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 17:03:33 -0400
Date: Thu, 24 Jul 2014 23:03:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] media: soc_camera: pxa_camera device-tree support
In-Reply-To: <8761invo7p.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.1407242301030.11084@axis700.grange>
References: <1404051600-20838-1-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.1407231126210.30243@axis700.grange>
 <Pine.LNX.4.64.1407231915310.1526@axis700.grange> <8761invo7p.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(re-adding Cc)

On Wed, 23 Jul 2014, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Add device-tree support to pxa_camera host driver.
> >
> > Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> > [g.liakhovetski@gmx.de: added of_node_put()]
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >
> > Robert, could you review and test this version, please?
> Review +1.
> Tested and works fine, so good to go.

Thanks for a quick test! One question: to test this you also needed a 
version of Ben's "soc_camera: add support for dt binding soc_camera 
drivers" patch, right? Did you use the last version from Ben or my amended 
version, that I sent yesterday? If you didn't use my version, would it be 
possible for you to test it and reply with your tested-by if all looks ok?

Thanks
Guennadi
