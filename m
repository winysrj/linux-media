Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:59769 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966555Ab3HHVPX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 17:15:23 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1308082225150.29611@axis700.grange>
References: <CAK5ve-J7Sn5wuJ_z6Lqr=_qMQRqF12Aa6GfTv4xBhh=n_28Yjg@mail.gmail.com>
 <Pine.LNX.4.64.1308082225150.29611@axis700.grange>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 8 Aug 2013 14:15:01 -0700
Message-ID: <CAK5ve-KU7Kem91oN=6h5pJ7K8=PXfrBOq2njYzGxubugiLMZJA@mail.gmail.com>
Subject: Re: Can I put a V4L2 soc camera driver under other subsystem directory?
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Thierry Reding <thierry.reding@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	linux-tegra <linux-tegra@vger.kernel.org>,
	=?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 8, 2013 at 1:52 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Bryan,
>
> On Wed, 7 Aug 2013, Bryan Wu wrote:
>
>> Hi Guennadi and LMML,
>>
>> I'm working on a camera controller driver for Tegra, which is using
>> soc_camera. But we also need to use Tegra specific host1x interface
>> like syncpt APIs.
>>
>> Since host1x is quite Tegra specific framework which is in
>> drivers/gpu/host1x and has several host1x's client driver like graphic
>> 2D driver, my v4l2 soc_camera driver is also a host1x client driver.
>> Right now host1x does not expose any global include header files like
>> API in the kernel, because no other users. So we plan to put all
>> host1x related driver together, is that OK for us to put our Tegra
>> soc_camera driver into drivers/gpu/host1x/camera or similar?
>>
>> I guess besides it will introduce some extra maintenance it should be OK, right?
>
> Exactly, there's already been a precedent:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg56213.html
>
> It hasn't been finalised yet though.
>

OK, cool. I will try to provide the first version soon.

Thanks a lot,
-Bryan
