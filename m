Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39205 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1F3Qum (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 12:50:42 -0400
Date: Thu, 30 Jun 2011 19:50:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2] V4L: add media bus configuration subdev operations
Message-ID: <20110630165037.GL12671@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1106222314570.3535@axis700.grange>
 <20110623220129.GA10918@valkosipuli.localdomain>
 <Pine.LNX.4.64.1106240021540.5348@axis700.grange>
 <20110627081912.GC12671@valkosipuli.localdomain>
 <Pine.LNX.4.64.1106271029240.9394@axis700.grange>
 <Pine.LNX.4.64.1106291806260.12577@axis700.grange>
 <4E0B7AAE.7010900@iki.fi>
 <Pine.LNX.4.64.1106292122220.17571@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106292122220.17571@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 29, 2011 at 09:28:06PM +0200, Guennadi Liakhovetski wrote:
> On Wed, 29 Jun 2011, Sakari Ailus wrote:
> 
> > Guennadi Liakhovetski wrote:
> > > On Mon, 27 Jun 2011, Guennadi Liakhovetski wrote:
> > > 
> > > [snip]
> > > 
> > >>> If the structures are expected to be generic I somehow feel that a field of
> > >>> flags isn't the best way to describe the configuration of CSI-2 or other
> > >>> busses. Why not to just use a structure with bus type and an union for
> > >>> bus-specific configuration parameters? It'd be easier to access and also to
> > >>> change as needed than flags in an unsigned long field.
> > >>
> > >> Well, yes, a union can be a good idea, thanks.
> > > 
> > > ...on a second thought, we currently only have one field: flags, and it is 
> > > common for all 3 bus types: parallel, reduced parallel (bt.656, etc.), and 
> > > CSI-2. In the future, when we need more parameters for any of these busses 
> > > we'll just add such a union, shouldn't be a problem.
> > 
> > What I meant above was that I would prefer to describe the capabilities
> > in a structure which would contain appropriate data type for the field,
> > not as flags or sets of flags in a bit field.
> > 
> > This would allow e.g. just testing for
> > v4l2_mbus_config.u.parallel.hsync_active_low instead of
> > v4l2_mbus_config.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW. This way the flags
> > used for the bus also express the bus explicitly rather than implicitly.
> 
> I don't think, using flags is any less explicit, than using struct 
> members. As I already explained, I'd like to use the same interface for 
> querying capabilities, the present configuration, and setting a 
> configuration. This is easily achieved with flags. See the 
> v4l2_mbus_config_compatible() function and try to rewrite all the bitwise 
> operations in it, using your struct.

I still don't like the use of flags this way. I do admit that
v4l2_mbus_config_compatible() might be more difficult to write. It's still a
tiny piece of code. Speaking of which, should it be part of the latest
patch?

As far as I understand, v4l2_mbus_config_compatible() is meant for SoC
camera compatibility only. I would like that the interface which is not SoC
camera dependent would not get compatibility burden right from the
beginning. That said, it's a nice property that e.g. sensor drivers written
for SoC camera would work without it as well --- is this what the patch
would achieve, or a part of it?

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
