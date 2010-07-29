Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:54356 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab0G2H1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 03:27:00 -0400
Date: 29 Jul 2010 09:23:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: maximlevitsky@gmail.com
Cc: jarod@wilsonet.com
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net
Cc: mchehab@redhat.com
Message-ID: <BTlMsWzZjFB@christoph>
In-Reply-To: <1280360452-8852-1-git-send-email-maximlevitsky@gmail.com>
Subject: Re: <kein Betreff>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxim,

on 29 Jul 10 at 02:40, Maxim Levitsky wrote:
[...]
> In addition to comments, I changed helper function that processes samples
> so it sends last space as soon as timeout is reached.
> This breaks somewhat lirc, because now it gets 2 spaces in row.
> However, if it uses timeout reports (which are now fully supported)
> it will get such report in middle.
>
> Note that I send timeout report with zero value.
> I don't think that this value is importaint.

This does not sound good. Of course the value is important to userspace  
and 2 spaces in a row will break decoding.

Christoph
