Return-path: <mchehab@localhost>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43700 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807Ab1GERjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jul 2011 13:39:12 -0400
Date: Tue, 5 Jul 2011 10:21:19 -0700
From: Greg KH <greg@kroah.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] [staging] lirc_serial: allocate irq at init time
Message-ID: <20110705172119.GA19358@kroah.com>
References: <1308252706-13879-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308252706-13879-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jun 16, 2011 at 03:31:46PM -0400, Jarod Wilson wrote:
> There's really no good reason not to just grab the desired IRQ at driver
> init time, instead of every time the lirc device node is accessed. This
> also improves the speed and reliability with which a serial transmitter
> can operate, as back-to-back transmission attempts (i.e., channel change
> to a multi-digit channel) don't have to spend time acquiring and then
> releasing the IRQ for every digit, sometimes multiple times, if lircd
> has been told to use the min_repeat parameter.
> 
> CC: devel@driverdev.osuosl.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  drivers/staging/lirc/lirc_serial.c |   44 +++++++++++++++++------------------
>  1 files changed, 21 insertions(+), 23 deletions(-)

This patch doesn't apply to the staging-next branch, care to respin it
and resend it so I can apply it?

thanks,

greg k-h
