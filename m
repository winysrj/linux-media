Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53551 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab0G2OmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 10:42:14 -0400
Subject: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	mchehab@redhat.com
In-Reply-To: <BTlMsWzZjFB@christoph>
References: <BTlMsWzZjFB@christoph>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 17:41:59 +0300
Message-ID: <1280414519.29938.53.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-07-29 at 09:23 +0200, Christoph Bartelmus wrote: 
> Hi Maxim,
> 
> on 29 Jul 10 at 02:40, Maxim Levitsky wrote:
> [...]
> > In addition to comments, I changed helper function that processes samples
> > so it sends last space as soon as timeout is reached.
> > This breaks somewhat lirc, because now it gets 2 spaces in row.
> > However, if it uses timeout reports (which are now fully supported)
> > it will get such report in middle.
> >
> > Note that I send timeout report with zero value.
> > I don't think that this value is importaint.
> 
> This does not sound good. Of course the value is important to userspace  
> and 2 spaces in a row will break decoding.
> 
> Christoph

Could you explain exactly how timeout reports work?

Lirc interface isn't set to stone, so how about a reasonable compromise.
After reasonable long period of inactivity (200 ms for example), space
is sent, and then next report starts with a pulse.
So gaps between keypresses will be maximum of 200 ms, and as a bonus I
could rip of the logic that deals with remembering the time?

Best regards,
Maxim Levitsky

