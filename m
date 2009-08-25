Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:59655 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbZHYJsC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 05:48:02 -0400
Message-ID: <4A93B32A.5060102@gmail.com>
Date: Tue, 25 Aug 2009 12:47:22 +0300
From: Anssi Hannula <anssi.hannula@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Greg KH <greg@kroah.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: How to handle devices sitting on multiple busses ?
References: <200908241357.44562.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200908241357.44562.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
[...]
> As the bridge and I2C master live their own life in the Linux device tree, 
> they are initialized, suspended, resumed and destroyed independently. The 
> sensor being an I2C slave device, Linux initializes it after the I2C master 
> device is initialized, but doesn't ensure that the bridge is initialized first 
> as well. A similar problem occurs during suspend/resume, as the I2C slave 
> needs to be suspended before and resumed after the video bridge.
> 
> Have you ever encountered such a situation before ? Is there a clean way for a 
> device to have multiple parents, or do you have plans for such a possibility 
> in the future ? I would be willing to give an implementation a try if you can 
> provide me with some guidelines.
> 

It looks to me like this patch is related to your problem:
http://article.gmane.org/gmane.linux.power-management.general/15651

With a quick glance it doesn't seem to involve changes in device
initialization or destroying, though, but this is not really my area of
expertise.

-- 
Anssi Hannula
