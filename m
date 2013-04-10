Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:38127 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936177Ab3DJKiq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 06:38:46 -0400
MIME-Version: 1.0
In-Reply-To: <1348754853-28619-8-git-send-email-g.liakhovetski@gmx.de>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <1348754853-28619-8-git-send-email-g.liakhovetski@gmx.de>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 10 Apr 2013 18:38:26 +0800
Message-ID: <CAGsJ_4yUY6PE0NWZ9yaOLFmRb3O-HL55=w7Y6muwL0YbkJtP0Q@mail.gmail.com>
Subject: Re: [PATCH 07/14] media: soc-camera: support deferred probing of clients
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"renwei.wu" <renwei.wu@csr.com>,
	DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
	xiaomeng.hou@csr.com, zilong.wu@csr.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadia,

2012/9/27 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> Currently soc-camera doesn't work with independently registered I2C client
> devices, it has to register them itself. This patch adds support for such
> configurations, in which case client drivers have to request deferred
> probing until their host becomes available and enables the data interface.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---

it seems deferred probing for i2c camera sensors is a more workaround
than a solution.
currently,  soc-camera-pdrv is the manager of the whole initilization
flow. it all requires the host/client registerred and initilized
synchronously. so that results in strange things like that we fill a
i2c_board_info structure in arch/arm/mach-xxx but we never call
anything like i2c_new_device() to add the i2c client in mach. because
we need to do that in the soc-camera-pdrv driver to make all things
happen orderly.

but now after we move to DT, all i2c device will be registerred
automatically by of_i2c_register_devices() in i2c_host 's probe, that
makes the problem much worse and very urgent to get fixed.

returning DEFERRED_PROBE error until getting the private data filled
by the manager, indirectly, makes the things seem to be asynchronous,
but essentially it is still synchronous because the overall timing
line is still controller by soc-camera-pdrv.

what about another possible way:
we let all host and i2c client driver probed in any order, but let the
final soc-camera-pdrv is the connection of all things. the situation
of soc_camera is very similar with ALSA SoC. it turns out ASoC has
done that very well.

-barry
