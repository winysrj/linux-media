Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:52588 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab1CVMgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 08:36:41 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LMML <linux-media@vger.kernel.org>
Date: Tue, 22 Mar 2011 18:06:22 +0530
Subject: RE: [PATCH v17 00/13] davinci vpbe: dm6446 v4l2 driver
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C47D7D5@dbde02.ent.ti.com>
References: <1300197388-3704-1-git-send-email-manjunath.hadli@ti.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024BCEF72A@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF72A@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Manju,

On Tue, Mar 22, 2011 at 12:23:14, Hadli, Manjunath wrote:
> Sekhar, Kevin, 
>  These patches have gone through considerable reviews. 
> Could you please ACK from your end?

I have some minor comments which I have already posted and
once you fix those you can add:

Acked-by: Sekhar Nori <nsekhar@ti.com>

to the platform patches.

> 
> On Tue, Mar 15, 2011 at 19:26:28, Hadli, Manjunath wrote:
> > version17:
> > The more important among the patch history from previous comments 1. Replacing _raw_readl() with readl().

This is not valid.

Thanks,
Sekhar

