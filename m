Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:47108 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3ACARD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 19:17:03 -0500
Date: Thu, 3 Jan 2013 01:16:57 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] [media] winbond-cir: increase IR receiver resolution
Message-ID: <20130103001657.GB13132@hardeman.nu>
References: <1351113762-5530-1-git-send-email-sean@mess.org>
 <1351113762-5530-2-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351113762-5530-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 24, 2012 at 10:22:41PM +0100, Sean Young wrote:
>This is needed for carrier reporting.
>
>Signed-off-by: Sean Young <sean@mess.org>
>---
> drivers/media/rc/winbond-cir.c | 14 +++++++++-----
> 1 file changed, 9 insertions(+), 5 deletions(-)

Using a resolution of 2us rather than 10us means that the resolution
(and amount of work necessary for decoding a given signal) is about 25x
higher than in the windows driver (which uses a 50us resolution IIRC)...

Most of it is mitigated by using RLE (which I don't think the windows
driver uses....again...IIRC), but it still seems unnecessary for the
general case.

Wouldn't it be possible to only use the high-res mode when carrier
reports are actually enabled?

(Yes, I know this patch was sent a long time ago)


//David
