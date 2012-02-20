Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49413 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2BTAS2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Feb 2012 19:18:28 -0500
Received: by eekc14 with SMTP id c14so2067553eek.19
        for <linux-media@vger.kernel.org>; Sun, 19 Feb 2012 16:18:27 -0800 (PST)
Message-ID: <4F419151.40907@gmail.com>
Date: Mon, 20 Feb 2012 01:18:25 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: pre-allocate DVB isoc transfer buffers
References: <1329155962-22896-1-git-send-email-gennarone@gmail.com> <4F4189EB.6020202@yahoo.com>
In-Reply-To: <4F4189EB.6020202@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 20/02/2012 00:46, Chris Rankin ha scritto:
> Gianluca,
> 
> One quick comment about your patch; I've noticed that you've declared
> two new "GPL only" symbols:
> 
> EXPORT_SYMBOL_GPL(em28xx_capture_start);
> EXPORT_SYMBOL_GPL(em28xx_alloc_isoc);
> 
> I'm not sure what the exact policy is with GPL symbols, but I do know
> what Al Viro posted recently on the subject:
> 
> http://thread.gmane.org/gmane.linux.file-systems/61372
> 
> Do we really need EXPORT_SYMBOL_GPL() here?
> 
> Cheers,
> Chris
> 

Hi Chris,
thanks for the comment.
The two new symbols are used in place of the old em28xx_init_isoc and
em28xx_uninit_isoc in two different modules (em28xx and em28xx-dvb).
Since the old symbols are exported through EXPORT_SYMBOL_GPL(), I did
the same with the new ones.
This choice should not break any non-GPL module, as this symbols are
meant to be used only in the em28xx* modules, just like the old ones.

Regards,
Gianluca
