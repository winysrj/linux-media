Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:33069 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1FHGkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 02:40:07 -0400
Date: Wed, 8 Jun 2011 09:40:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	sakari.ailus@maxwell.research.nokia.com,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC] V4L: add media bus configuration subdev operations
Message-ID: <20110608064001.GC7830@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1106061358310.11169@axis700.grange>
 <201106071725.32948.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106071725.32948.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jun 07, 2011 at 05:25:32PM +0200, Laurent Pinchart wrote:
> Hi Guennadi,
> 
> Thanks for the patch.
> 
> On Monday 06 June 2011 14:31:57 Guennadi Liakhovetski wrote:
> > Add media bus configuration types and two subdev operations to get
> > supported mediabus configurations and to set a specific configuration.
> > Subdevs can support several configurations, e.g., they can send video data
> > on 1 or several lanes, can be configured to use a specific CSI-2 channel,
> > in such cases subdevice drivers return bitmasks with all respective bits
> > set. When a set-configuration operation is called, it has to specify a
> > non-ambiguous configuration.
> > 
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > This change would allow a re-use of soc-camera and "standard" subdev
> > drivers. It is a modified and extended version of
> > 
> > http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/294
> > 08
> > 
> > therefore the original Sob. After this we only would have to switch to the
> > control framework:) Please, comment.
> 
> I still believe we shouldn't use any set operation :-) The host/bridge driver 
> should just use the get operation before starting the stream to configure it's 
> sensor interface. 

I agree with Laurent.

What about implementing just get first?

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
