Return-path: <linux-media-owner@vger.kernel.org>
Received: from joan.kewl.org ([212.161.35.248]:51613 "EHLO joan.kewl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZCZA47 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 20:56:59 -0400
From: Darron Broad <darron@kewl.org>
To: "Udo A. Steinberg" <udo@hypervisor.org>
cc: darron@kewl.org, v4l-dvb-maintainer@linuxtv.org,
	linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: Hauppauge/IR breakage with 2.6.28/2.6.29 
In-reply-to: <20090326000932.6aa1a456@laptop.hypervisor.org> 
References: <20090326000932.6aa1a456@laptop.hypervisor.org>
Date: Thu, 26 Mar 2009 00:26:47 +0000
Message-ID: <29212.1238027207@kewl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In message <20090326000932.6aa1a456@laptop.hypervisor.org>, "Udo A. Steinberg" wrote:
>
>Hi,
>
>The following patch
>http://kerneltrap.org/mailarchive/git-commits-head/2008/10/13/3643574
>that was added between 2.6.27 and 2.6.28 has resulted in my Hauppauge
>WinTV IR remote not working anymore. I've tracked down the breakage to:
>
>if (dev!=3D0x1e && dev!=3D0x1f)=20
>  return 0;
>
>in drivers/media/video/ir-kbd-i2c.c
>
>My remote sends with dev=3D0x0 and is the following model:
>http://www.phphuoc.com/reviews/tvtuner_hauppauge_wintv_theater/index_files/=
>image001.jpg
>
>Removing the check results in the remote working again. Is there a way to
>convince the remote to send a different dev? Otherwise I guess the check
>should be relaxed.

You are correct. I happen to have one of those ancient remote
controls myself and it does use device address 0.

Please refer to http://www.sbprojects.com/knowledge/ir/rc5.htm
for an overview of device addresses.

It's something I forget to deal with in that patch. A solution
would be to allow a device address to be a module param to
override the more modern addresses of 0x1e and 0x1f.

I can't remember addresses off the top of my head but I believe
the modern silver remotes use 0x1f and the older black ones
use 0x1e. I think the black one I have came with a now dead
DEC2000.

The problem with reverting the patch is that it makes modern
systems unusable as HTPCs when the television uses RC5. This
is a more important IMHO than supporting what in reality is
an obsolete remote control.

cya!

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 

