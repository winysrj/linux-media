Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42054 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1I0Ddm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 23:33:42 -0400
Received: by qyk30 with SMTP id 30so475884qyk.19
        for <linux-media@vger.kernel.org>; Mon, 26 Sep 2011 20:33:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F63697F7-FEE5-439D-A014-3CC33A89C7CA@gigadevices.com>
References: <fe2a004a676834efbb488b985de0370b@www.tabletspain.net>
	<A731A584-CEE7-4F51-9483-9989E7495562@gigadevices.com>
	<CAHG8p1CK5-BbDSdX5qGsGxfsvCZPc6S76ehE-2O1YORF4wM31A@mail.gmail.com>
	<F63697F7-FEE5-439D-A014-3CC33A89C7CA@gigadevices.com>
Date: Tue, 27 Sep 2011 11:33:41 +0800
Message-ID: <CAHG8p1BuxD=yANOOQcWQvFZYDunFddt+vH4kKYyW8gU=ULb57g@mail.gmail.com>
Subject: Re: New SOC Camera hardware
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Gilles <gilles@gigadevices.com>
Cc: linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/9/27 Gilles <gilles@gigadevices.com>:
> Scott,
>
> A late echo. I am just now getting into the heart of this project and realize I missed your answer here from back in August. Just grabbed the trunk from the repo and trying to compile it.
>
> I'm not sure I understand why it would work with one sensor driver and not another. I thought the whole point of an adapter driver was to separate the camera sensor functions from the hardware. I guess the reason why I ask is because I currently need to get it to work with the Micron MT9V022 (which has a sensor driver).
>

If you prefer soc, you can convert my bridge driver to soc framework,
but you need add some patches to soc if you want soc support decoder
well. Guennadi Liakhovetski can give you more advice on this.
If not, my bridge driver already supports sensor driver, vs6624 is an
example. You just need care about the ops sensor driver must
implement.
