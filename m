Return-path: <mchehab@gaivota>
Received: from devils.ext.ti.com ([198.47.26.153]:55796 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab1AFGkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 01:40:12 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Hans Verkuil'" <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Nori, Sekhar" <nsekhar@ti.com>
Date: Thu, 6 Jan 2011 12:10:07 +0530
Subject: RE: [RFC PATCH 0/2] davinci: convert to core-assisted locking
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930247F9A81E@dbde02.ent.ti.com>
In-Reply-To: <1294245760-2803-1-git-send-email-hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Tested for SD loopback and other IOCTLS. Reviewed the patches.

Patch series Acked by: Manjunath Hadli <Manjunath.hadli@ti.com> 
-Manju

On Wed, Jan 05, 2011 at 22:12:38, Hans Verkuil wrote:
> 
> These two patches convert vpif_capture and vpif_display to core-assisted locking and now use .unlocked_ioctl instead of .ioctl.
> 
> These patches assume that the 'DaVinci VPIF: Support for DV preset and DV timings' patch series was applied first. See:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg26594.html
> 
> These patches are targeted for 2.6.38.
> 
> Regards,
> 
> 	Hans
> 

