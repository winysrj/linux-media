Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:20410 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab1F2TT4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 15:19:56 -0400
Message-ID: <4E0B7AAE.7010900@iki.fi>
Date: Wed, 29 Jun 2011 22:19:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2] V4L: add media bus configuration subdev operations
References: <Pine.LNX.4.64.1106222314570.3535@axis700.grange> <20110623220129.GA10918@valkosipuli.localdomain> <Pine.LNX.4.64.1106240021540.5348@axis700.grange> <20110627081912.GC12671@valkosipuli.localdomain> <Pine.LNX.4.64.1106271029240.9394@axis700.grange> <Pine.LNX.4.64.1106291806260.12577@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1106291806260.12577@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Guennadi Liakhovetski wrote:
> On Mon, 27 Jun 2011, Guennadi Liakhovetski wrote:
> 
> [snip]
> 
>>> If the structures are expected to be generic I somehow feel that a field of
>>> flags isn't the best way to describe the configuration of CSI-2 or other
>>> busses. Why not to just use a structure with bus type and an union for
>>> bus-specific configuration parameters? It'd be easier to access and also to
>>> change as needed than flags in an unsigned long field.
>>
>> Well, yes, a union can be a good idea, thanks.
> 
> ...on a second thought, we currently only have one field: flags, and it is 
> common for all 3 bus types: parallel, reduced parallel (bt.656, etc.), and 
> CSI-2. In the future, when we need more parameters for any of these busses 
> we'll just add such a union, shouldn't be a problem.

What I meant above was that I would prefer to describe the capabilities
in a structure which would contain appropriate data type for the field,
not as flags or sets of flags in a bit field.

This would allow e.g. just testing for
v4l2_mbus_config.u.parallel.hsync_active_low instead of
v4l2_mbus_config.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW. This way the flags
used for the bus also express the bus explicitly rather than implicitly.

Do you see downsides with this compared to using an integer field as
flags? The other benefits of this are described in my earlier comment.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
