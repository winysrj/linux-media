Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:26935 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZDQHlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 03:41:00 -0400
Received: by yx-out-2324.google.com with SMTP id 3so18763yxj.1
        for <linux-media@vger.kernel.org>; Fri, 17 Apr 2009 00:40:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
Date: Fri, 17 Apr 2009 16:40:58 +0900
Message-ID: <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wed, Apr 15, 2009 at 9:17 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> This patch series is a preparation for the v4l2-subdev conversion. Please,
> review and test. My current patch-stack in the form of a
> (manually-created) quilt-series is at
> http://www.open-technology.de/download/20090415/ based on linux-next
> history branch, commit ID in 0000-base file. Don't be surprised, that
> patch-set also contains a few not directly related patches.

Testing on Migo-R board with 2.6.30-rc2-git-something and the
following cherry-picked patches:

0007-driver-core-fix-driver_match_device.patch
0033-soc-camera-host-driver-cleanup.patch
0034-soc-camera-remove-an-extra-device-generation-from-s.patch
0035-soc-camera-simplify-register-access-routines-in-mul.patch
and part of 0036 (avoiding rejects, ap325 seems broken btw)

It compiles just fine, boots up allright, but I can't open /dev/video0 anymore.

It's still supposed to work with all drivers compiled-in, right?

I'll investigate a bit more and update to latest linux-2.6 git.

/ magnus
