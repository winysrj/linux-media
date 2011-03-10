Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58479 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab1CJTqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 14:46:37 -0500
Received: by bwz15 with SMTP id 15so2123503bwz.19
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 11:46:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110310092457.2e748f72@bike.lwn.net>
References: <20110303190331.E8ED79D401D@zog.reactivated.net>
	<20110310092457.2e748f72@bike.lwn.net>
Date: Thu, 10 Mar 2011 19:46:36 +0000
Message-ID: <AANLkTi=Gg95OevAmufD=-pANVhffaaLLd7BCC-c+ksdi@mail.gmail.com>
Subject: Re: [PATCH] via-camera: Fix OLPC serial check
From: Daniel Drake <dsd@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: dilinger@queued.net, mchehab@infradead.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10 March 2011 16:24, Jonathan Corbet <corbet@lwn.net> wrote:
> Did the check need to move for some reason?  If so, a one-of-these-days
> nice feature might be to allow changing override_serial at run time.

Yes. Otherwise the check would execute if that driver is loaded on
XO-1. The check either had to be modified or moved into a place where
we know we're on the right hardware. I chose the latter. You can still
unload the module and reload with a different setting if needed.

I haven't heard of anyone using the module param now that the firmware
sets the bit correctly and new serial adapters have been widely
distributed, making the selection between camera and serial fully
automatic.

Thanks for the review. Mauro, please merge.

Daniel
