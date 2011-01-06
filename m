Return-path: <mchehab@gaivota>
Received: from bear.ext.ti.com ([192.94.94.41]:40592 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab1AFKRq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 05:17:46 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "mchehab@redhat.com" <mchehab@redhat.com>
CC: "'Hans Verkuil'" <hverkuil@xs4all.nl>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 6 Jan 2011 15:47:31 +0530
Subject: RE: [RFC PATCH 0/2] davinci: convert to core-assisted locking
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930248201846@dbde02.ent.ti.com>
References: <1294245760-2803-1-git-send-email-hverkuil@xs4all.nl>
 <B85A65D85D7EB246BE421B3FB0FBB5930247F9A81E@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB5930247F9A81E@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

On Thu, Jan 06, 2011 at 12:10:07, Hadli, Manjunath wrote:
> Tested for SD loopback and other IOCTLS. Reviewed the patches.
> 
> Patch series Acked by: Manjunath Hadli <Manjunath.hadli@ti.com> 	

Shall I add these two patches as well to the pull request I sent
yesterday[1]? These changes are localized to the DaVinci VPIF driver
and should be safe to take in.

I can also send a separate pull request.

Let me know and I will do that way.

Thanks,
Sekhar

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg26594.html

> -Manju
> 
> On Wed, Jan 05, 2011 at 22:12:38, Hans Verkuil wrote:
> > 
> > These two patches convert vpif_capture and vpif_display to core-assisted locking and now use .unlocked_ioctl instead of .ioctl.
> > 
> > These patches assume that the 'DaVinci VPIF: Support for DV preset and DV timings' patch series was applied first. See:
> > 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg26594.html
> > 
> > These patches are targeted for 2.6.38.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> 
> 

