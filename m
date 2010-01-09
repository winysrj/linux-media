Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53914 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0AITmx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 14:42:53 -0500
Message-ID: <4B48DC34.1080500@infradead.org>
Date: Sat, 09 Jan 2010 17:42:44 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: building v4l-dvb - compilation error
References: <A69FA2915331DC488A831521EAE36FE40162D43370@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40162D43370@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Karicheri, Muralidharan wrote:
> Hi,
> 
> I have installed mercurial and cloned the v4l-dvb tree. I tried doing a build as per instructions and I get the following error. Since I am in the process of validating my build environment, I am not sure if the following is a genuine build error or due to my environment...
> 
> Other questions I have are:-
> 
> 1) I am just doing make. So does this build all v4l2 drivers?

Yes.

> 2) Which target this build for?

The one found on your running. You may force a different target with
	make ARCH=<some_arch>

> 3) What output this build create?

The *.ko modules.

> make[2]: Leaving directory `/usr/src/kernels/2.6.9-55.0.12.EL-smp-i686'

The minimum supported version by the backport is 2.6.16.


Cheers,
Mauro.
