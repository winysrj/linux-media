Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:63618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab1F2QIx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 12:08:53 -0400
Date: Wed, 29 Jun 2011 18:08:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2] V4L: add media bus configuration subdev operations
In-Reply-To: <Pine.LNX.4.64.1106271029240.9394@axis700.grange>
Message-ID: <Pine.LNX.4.64.1106291806260.12577@axis700.grange>
References: <Pine.LNX.4.64.1106222314570.3535@axis700.grange>
 <20110623220129.GA10918@valkosipuli.localdomain> <Pine.LNX.4.64.1106240021540.5348@axis700.grange>
 <20110627081912.GC12671@valkosipuli.localdomain> <Pine.LNX.4.64.1106271029240.9394@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 27 Jun 2011, Guennadi Liakhovetski wrote:

[snip]

> > If the structures are expected to be generic I somehow feel that a field of
> > flags isn't the best way to describe the configuration of CSI-2 or other
> > busses. Why not to just use a structure with bus type and an union for
> > bus-specific configuration parameters? It'd be easier to access and also to
> > change as needed than flags in an unsigned long field.
> 
> Well, yes, a union can be a good idea, thanks.

...on a second thought, we currently only have one field: flags, and it is 
common for all 3 bus types: parallel, reduced parallel (bt.656, etc.), and 
CSI-2. In the future, when we need more parameters for any of these busses 
we'll just add such a union, shouldn't be a problem.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
