Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41307 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab2AKBFG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 20:05:06 -0500
Message-ID: <4F0CE040.7020904@iki.fi>
Date: Wed, 11 Jan 2012 03:05:04 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jim Darby <uberscubajim@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
References: <4F0C3D1B.2010904@gmail.com>
In-Reply-To: <4F0C3D1B.2010904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/2012 03:28 PM, Jim Darby wrote:
> I've been using a PCTV Nanostick T2 USB DVB-T2 receiver (one of the few
> that supports DVB-T2) for over six months with a 3.0 kernel with no
> problems.
>
> The key drivers in use are em28xx, cxd2820r and tda18271.
>
> Seeing the 3.2 kernel I thought I'd upgrade and now I seem to have hit a
> problem.

Do you have possibility to test Kernel 3.1?
Also latest LinuxTV.org devel could be interesting to see. There is one 
patch that changes em28xx driver endpoint configuration. But as that 
patch is going for 3.3 it should not be cause of issue, but I wonder if 
it could fix... Use media_build.git if possible.

> The Nanostick works fine for between 5 and 25 minutes and then without
> any error messages cuts out. The TS drops to a tiny stream of non-TS
> data. It seems to contain a lot of 0x00s and 0xffs.
>
> It looks like the problem of many years ago when the frontends would be
> shut down if they were closed for more than a few minutes. However, it
> would appear that the frontend fds are still open (according to fuser).
>
> Some more system details:
>
> This is running on a 32-bit system.
>
> Everything works fine if I boot with the 3.0.0 kernel.
>
> The user-land application is kaffeine.
>
> There is a PCI DVB-T card in the system which operates fine even when
> the Nanostick stops producing the correct output.

Which is that card? I wonder if there is same drivers used like tda18271...

> I'm more than happy to build kernels and add debugging. I'm basically
> just trying to find the maintainer for these modules so we can figure
> out what's going wrong and fix it before 3.2 escapes into several
> distros and we have this problem on a larger scale.

I am maintainer of the cxd2820r. Mike knows tda18271 and maybe Mauro 
em28xx...

> Many thanks for your help,
>
> Jim.


Antti
-- 
http://palosaari.fi/
