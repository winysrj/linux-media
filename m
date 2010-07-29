Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60823 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0G2P1Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 11:27:16 -0400
Subject: Re: [PATCH 5/9] IR: extend interfaces to support more device
 settings
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, mchehab@redhat.com,
	Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <BTlMvkhXqgB@lirc>
References: <1280360452-8852-6-git-send-email-maximlevitsky@gmail.com>
	 <BTlMvkhXqgB@lirc>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 18:27:07 +0300
Message-ID: <1280417227.29938.60.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-07-29 at 09:25 +0200, Christoph Bartelmus wrote: 
> Hi!
> 
> Maxim Levitsky "maximlevitsky@gmail.com" wrote:
> 
> > Also reuse LIRC_SET_MEASURE_CARRIER_MODE as LIRC_SET_LEARN_MODE
> > (LIRC_SET_LEARN_MODE will start carrier reports if possible, and
> > tune receiver to wide band mode)
> 
> I don't like the rename of the ioctl. The ioctl should enable carrier
> reports. Anything else is hardware specific. Learn mode gives a somewhat
> wrong association to me. irrecord always has been using "learn mode"
> without ever using this ioctl.

Why?

Carrier measure (if supported by hardware I think should always be
enabled, because it can help in-kernel decoders).
(Which raises seperate question on how to do so. I guess I will need to
make ir_raw_event 64 bit after all...)


Another thing is reporting these results to lirc.
By default lirc shouldn't get carrier reports, but as soon as irrecord
starts, it can place device in special mode that allows it to capture
input better, and optionally do carrier reports.

Do you think carrier reports are needed by lircd?

Best regards,
Maxim Levitsky

