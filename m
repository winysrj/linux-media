Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:57629 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936834Ab3DJOa0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 10:30:26 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1304101601160.13557@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-8-git-send-email-g.liakhovetski@gmx.de> <CAGsJ_4yUY6PE0NWZ9yaOLFmRb3O-HL55=w7Y6muwL0YbkJtP0Q@mail.gmail.com>
 <Pine.LNX.4.64.1304101358490.13557@axis700.grange> <CAGsJ_4xn_R7D7Uh0dJB7WuDQG3K_mZkMwYNtMDuHMhX+4oTk=Q@mail.gmail.com>
 <Pine.LNX.4.64.1304101601160.13557@axis700.grange>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 10 Apr 2013 22:30:05 +0800
Message-ID: <CAGsJ_4z-FnbHtmbi16YD5LmYfpL+=ngke8EgkPHWy_PJ8QBPNg@mail.gmail.com>
Subject: Re: [PATCH 07/14] media: soc-camera: support deferred probing of clients
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
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

2013/4/10 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Wed, 10 Apr 2013, Barry Song wrote:
>
>> Hi Guennadi,
>
> There's a typo above.

sorry for the typo.

>
>> Thanks!
>>
>> 2013/4/10 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>> > Hi Barry
>> >
>> > On Wed, 10 Apr 2013, Barry Song wrote:
>> >
>> >> Hi Guennadia,
>> >>
>> >> 2012/9/27 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>> >> > Currently soc-camera doesn't work with independently registered I2C client
>> >> > devices, it has to register them itself. This patch adds support for such
>> >> > configurations, in which case client drivers have to request deferred
>> >> > probing until their host becomes available and enables the data interface.
>> >> >
>> >> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> >> > ---
>> >>
>> >> it seems deferred probing for i2c camera sensors is a more workaround
>> >> than a solution.
>> >> currently,  soc-camera-pdrv is the manager of the whole initilization
>> >> flow. it all requires the host/client registerred and initilized
>> >> synchronously. so that results in strange things like that we fill a
>> >> i2c_board_info structure in arch/arm/mach-xxx but we never call
>> >> anything like i2c_new_device() to add the i2c client in mach. because
>> >> we need to do that in the soc-camera-pdrv driver to make all things
>> >> happen orderly.
>> >>
>> >> but now after we move to DT, all i2c device will be registerred
>> >> automatically by of_i2c_register_devices() in i2c_host 's probe, that
>> >> makes the problem much worse and very urgent to get fixed.
>> >>
>> >> returning DEFERRED_PROBE error until getting the private data filled
>> >> by the manager,
>> >
>> > This hasn't been the case since several versions of these patches. We no
>> > longer use private data to decide whether subdevices can probe
>> > successfully or have to defer probing.
>>
>> sorry for missing.  i will refer to your newer versions.
>>
>> >
>> >> indirectly, makes the things seem to be asynchronous,
>> >> but essentially it is still synchronous because the overall timing
>> >> line is still controller by soc-camera-pdrv.
>> >
>> > It isn't. If your subdevice driver doesn't have any dependencies, like
>> > e.g. sh_mobile_csi2.c, it will probe asynchronously whenever it's loaded.
>> > It is the task of a bridge driver, in our case of the soc-camera core, to
>> > register notifiers and a list of expected subdevices with the v4l2-async
>> > subsystem. As subdevices complete their probing they signal that to the
>> > v4l2-async too, which then calls bridge's notifiers, which then can build
>> > the pipeline.
>>
>> it seems we didn't describle my idea clearly in the last mail. i
>> actually mean we don't need that if we put the pipeline building to
>> the last stage after all things have been placed there.
>>
>> >
>> >> what about another possible way:
>> >> we let all host and i2c client driver probed in any order,
>> >
>> > This cannot work, because some I2C devices, e.g. sensors, need a clock
>> > signal from the camera interface to probe. Before the bridge driver has
>> > completed its probing and registered a suitable clock source with the
>> > v4l2-clk framework, sensors cannot be probed. And no, we don't want to
>> > fake successful probing without actually being able to talk to the
>> > hardware.
>>
>> i'd say same dependency also exists on ASoC.  a "fake" successful
>> probing doesn't mean it should really begin to work if there is no
>> external trigger source.  ASoC has successfully done that by a machine
>> driver to connect all DAI.
>> a way is we put all things ready in their places, finally we connect
>> them together and launch the whole hardware flow.
>>
>> anyway, if you have maken the things work by some simple hacking and
>> that means minimial changes to current soc-camera, i think we can
>> follow.
>
> If you want to volunteer to step up as a new soc-camera maintainer to
> replace my simple hacking with your comprehencive and advanced designs -
> feel free, I'll ack straight away.

i am not sure whether you agree the new way or not. if you also agree
this is a better way, i think we can do something to move ahead. i
need sync and get input from you expert :-)

>
> Thanks
> Guennadi

-barry
