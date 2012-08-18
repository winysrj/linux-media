Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:37339 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2HRWwF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 18:52:05 -0400
Date: Sun, 19 Aug 2012 00:46:21 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
	linux-serial@vger.kernel.org, lirc-list@lists.sourceforge.net,
	greg@kroah.com
Subject: Re: [PATCH] [media] winbond-cir: Fix initialization
Message-ID: <20120818224621.GD11774@hardeman.nu>
References: <1343731023-9822-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343731023-9822-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 31, 2012 at 11:37:03AM +0100, Sean Young wrote:
>The serial driver will detect the winbond cir device as a serial port,
>since it looks exactly like a serial port unless you know what it is
>from the PNP ID.
>
>Winbond CIR 00:04: Region 0x2f8-0x2ff already in use!
>Winbond CIR 00:04: disabled
>Winbond CIR: probe of 00:04 failed with error -16

The proposed solution means that a serial port will show up and then
automagically disappear (potentially) during boot, which isn't very
elegant.

When I discussed this a long time ago with Alan Cox (while he was still
the serial maintainer) I got the feeling that he was advocating
implementing a PNP ID based blacklist in the serial driver (apologies to
Alan if I misrepresented him now).

That seems to be a better solution (one that I never got around to
implementing myself).

>
>Signed-off-by: Sean Young <sean@mess.org>
>---
> drivers/media/rc/winbond-cir.c | 21 ++++++++++++++++++++-
> drivers/tty/serial/8250/8250.c |  1 +
> 2 files changed, 21 insertions(+), 1 deletion(-)

(BTW, I'm on vacation with sporadic Internet access for two more weeks,
and when I return I'll be spending most of my spare time moving in to a
new apartment, expect slow turnaround times for replying to emails).


