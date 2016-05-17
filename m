Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46824 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755564AbcEQPQZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 11:16:25 -0400
Date: Tue, 17 May 2016 18:15:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Q] Asynchronous controls vs. events
Message-ID: <20160517151549.GC26360@valkosipuli.retiisi.org.uk>
References: <Pine.LNX.4.64.1605171540010.14153@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1605171540010.14153@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tue, May 17, 2016 at 04:51:07PM +0200, Guennadi Liakhovetski wrote:
> Hi,
> 
> I need to add asynchronous control support to the UVC driver. Some UVC 
> cameras support some controls in asynchronous mode. For those controls a 
> USB status is returned to the host, but the control will only be 
> completed, when an Interrupt packet is sent by the device. I can see two 
> ways to support this:
> 
> (1) synchronously: the driver waits in S_CTRL until the interrupt packet 
> arrives
> 
> (2) asynchronously: the driver returns immediately and sends an event 
> after the Interrupt packet is received.
> 
> Question: which method would be preferred, if (2) - what error code should 
> the driver use to indicate, that the result of the control isn't known 
> yet? Or should success be returned, since a success anyway doesn't 
> guarantee that the specified value has already taken effect.

I'd go with the second option and return success.

The reasoning is that making the operation synchronous requires the user to
wait inconveniently long time. Setting several controls would require at
least as many frames as there are controls. For sensors, the controls will
take effect only later on in any case, often a few frames later depending on
the sensor and what's being changed.

Probably in that case the driver has a reasonable chance of being
successful; the driver can validate the value of the control, can't it, and
if the link went down, there would be other issues as well.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
