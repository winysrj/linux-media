Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:37362 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab0JKNOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 09:14:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
Date: Mon, 11 Oct 2010 15:14:36 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com> <Pine.LNX.4.64.1010072012280.15141@axis700.grange> <AANLkTinJhywDoZg5F2tvqdW44to-6P4hgNd9Fav9qTv8@mail.gmail.com>
In-Reply-To: <AANLkTinJhywDoZg5F2tvqdW44to-6P4hgNd9Fav9qTv8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010111514.37592.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Monday 11 October 2010 14:59:15 Bastian Hecht wrote:
> So... let's see if i got some things right, please let me now if you
> disagree:
> 
> - I do want to use the omap34xxcam.c driver as it is for the newest
> framework and I get most support for it

That's a bad start. With the latest driver, omap34xxcam.c doesn't exist 
anymore :-)

> - The camera sensor driver must implement the v4l2-subdev and the new
> pad-level api. As the register list of mt9t031 and mt9p031 sensors are
> identical, I could copy the subdev-part. But the existing mt9t031
> driver stacks on top of soc_camera. soc_camera creates a v4l2 device.
> omap34xxcam also creates a v4l2 dev. Obviously they are competing
> architectures.
> 
> Guennadi wrote:
> > There is already an mt9t031 v4l2-subdev / soc-camera driver, so, if
> > mt9t031 and mt9p031 are indeed similar enough, I think, the right way is
> > to join efforts to port soc-camera over to the new "pad-level" API and
> > re-use the driver.
> 
> This confuses me a bit now. Guennadi, is your idea to update the
> soc_camera interface for pad-level support and port omap34xxcam to a
> soc_camera_omap34xxcam?
> I don't think I am capable of writing a new host bridge driver, so I
> would prefer touching only the sensor driver part. Or do you think it
> is better to remove the soc_camera dependency and fit the camera
> sensor driver to omap34xxcam directly?

You can either

- Take the mt9t031 driver, add support for the mt9p031 chip, make the soc-
camera dependency optional and add the pad-level operations. Adding support 
for the mt9p031 and adding pad-level operations (in addition to the existing 
subdev format operations) should be quite straightforward. Remove the soc-
camera dependency might be more difficult, I'm less experienced on that 
subject.

- Take the mt9t001 driver and add support for the mt9p031 chip. Register lists 
are quite similar, so that shouldn't be overly difficult. You would have to 
remove the hardcoded image sizes and make them configurable. Use the 
driver_data field in struct i2c_device_id mt9t001_id[] to store model-specific 
parameters. Different field sizes in some registers might make this approach a 
bit difficult.

> - If I do the later, I take Laurent's approach and look at his MT9T001
> sensor driver for Sakari's omap34xxcam host driver and adapt it for my
> needs. I can look for more subdev pad-level examples in Vaibhav's
> repository.

In the long term drivers should support both soc-camera and non soc-camera use 
cases, but we're not there yet.

-- 
Regards,

Laurent Pinchart
