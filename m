Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:58031 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZDTIy5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 04:54:57 -0400
Received: by yx-out-2324.google.com with SMTP id 3so717713yxj.1
        for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 01:54:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904201010130.4403@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	 <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
	 <Pine.LNX.4.64.0904170950320.5119@axis700.grange>
	 <aec7e5c30904170331n6da85695gdd6da8d6a42eacf1@mail.gmail.com>
	 <Pine.LNX.4.64.0904171235010.5119@axis700.grange>
	 <aec7e5c30904200014n2d8cdcfeud23f2b6b221f9fad@mail.gmail.com>
	 <Pine.LNX.4.64.0904200921090.4403@axis700.grange>
	 <aec7e5c30904200100wb117328sb97ea0262d163547@mail.gmail.com>
	 <Pine.LNX.4.64.0904201010130.4403@axis700.grange>
Date: Mon, 20 Apr 2009 17:54:56 +0900
Message-ID: <aec7e5c30904200154w758e4ecl8174a4cb0bce11f9@mail.gmail.com>
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

On Mon, Apr 20, 2009 at 5:14 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 20 Apr 2009, Magnus Damm wrote:
>> Can you please test on your Migo-R board? I'd be happy to assist you
>> in setting up your environment.
>
> I did test it and it worked - exactly as you say - with the entire patch
> stack + v2 of "soc-camera: convert to platform device," the only
> difference that I can see so far, is that I used modules. So, you can
> either look in dmesg for driver initialisation whether ov772x and tw9910
> have found theit i2c chips, or just wait until I test a monolitic build
> myself. It can be problematic if the i2c-host driver initialises too
> late... If you want to test a modular build it would be enough to just
> have sh_mobile_ceu_camera.ko as a module, the rest can stay built in.

I prefer to wait then. Please consider the built-in case broken.

Usually I get some output similar to this during boot:

camera 0-0: SuperH Mobile CEU driver attached to camera 0
camera 0-0: ov7725 Product ID 77:21 Manufacturer ID 7f:a2
camera 0-0: SuperH Mobile CEU driver detached from camera 0

But with the "convert to platform device" patch appied I see nothing like that.

The migor_defconfig should give you the static non-module
configuration that is broken.

Cheers,

/ magnus
