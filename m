Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:34308 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbZDQKbn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 06:31:43 -0400
Received: by yw-out-2324.google.com with SMTP id 5so570620ywb.1
        for <linux-media@vger.kernel.org>; Fri, 17 Apr 2009 03:31:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904170950320.5119@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	 <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
	 <Pine.LNX.4.64.0904170950320.5119@axis700.grange>
Date: Fri, 17 Apr 2009 19:31:41 +0900
Message-ID: <aec7e5c30904170331n6da85695gdd6da8d6a42eacf1@mail.gmail.com>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 17, 2009 at 4:51 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 17 Apr 2009, Magnus Damm wrote:
>> On Wed, Apr 15, 2009 at 9:17 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > This patch series is a preparation for the v4l2-subdev conversion. Please,
>> > review and test. My current patch-stack in the form of a
>> > (manually-created) quilt-series is at
>> > http://www.open-technology.de/download/20090415/ based on linux-next
>> > history branch, commit ID in 0000-base file. Don't be surprised, that
>> > patch-set also contains a few not directly related patches.
>>
>> Testing on Migo-R board with 2.6.30-rc2-git-something and the
>> following cherry-picked patches:
>>
>> 0007-driver-core-fix-driver_match_device.patch
>> 0033-soc-camera-host-driver-cleanup.patch
>> 0034-soc-camera-remove-an-extra-device-generation-from-s.patch
>> 0035-soc-camera-simplify-register-access-routines-in-mul.patch
>> and part of 0036 (avoiding rejects, ap325 seems broken btw)
>
> Have I broken it or is it unrelated?

2.6.30-rc seems broken on Migo-R. A quick check suggests the following:

V4L/DVB (10141): OK
V4L/DVB (10672): BAD
V4L/DVB (11024): BAD

OK means mplayer capture works as excepted with CEU and ov772x.
BAD means failure to open() /dev/video0 in the case of CEU. vivi works fine.

Morimoto-san and/or Guennadi, do you see the same thing?

Cheers,

/ magnus
