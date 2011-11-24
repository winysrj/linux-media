Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55875 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1KXSWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 13:22:17 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	LMML <linux-media@vger.kernel.org>
Subject: RE: [PATCH RESEND] davinci: dm646x: move vpif related code to
 driver	core header from platform
Date: Thu, 24 Nov 2011 18:22:05 +0000
Message-ID: <DF0F476B391FA8409C78302C7BA518B602DDD6@DBDE01.ent.ti.com>
References: <1321110362-6699-1-git-send-email-manjunath.hadli@ti.com>
 <4ECE8764.60800@redhat.com>
In-Reply-To: <4ECE8764.60800@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, Nov 24, 2011 at 23:35:24, Mauro Carvalho Chehab wrote:
> Em 12-11-2011 13:06, Manjunath Hadli escreveu:
> > move vpif related code for capture and display drivers
> > from dm646x platform header file to vpif_types.h as these definitions
> > are related to driver code more than the platform or board.
> > 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> 
> Manju,
> 
> Why are you re-sending a patch?
> 
> My understanding is that you're maintaining the davinci patches, so it is
> up to you to put those patches on your tree and send me a pull request when
> they're done. So, please, don't pollute the ML re-sending emails that
> are for yourself to handle.

Since this particular patch touches arch/arm/mach-davinci
as well as drivers/media/video, the plan was to queue the
patch through ARM tree with your Ack. We did not get your
ack the last time around[1] so it was resent.

Do let me know if your ack is not needed.

Thanks,
Sekhar

[1] http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg21840.html

