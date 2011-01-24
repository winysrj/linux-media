Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41596 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1AXPpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:45:18 -0500
Received: by vws16 with SMTP id 16so1810154vws.19
        for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 07:45:16 -0800 (PST)
References: <cover.1295882104.git.mchehab@redhat.com> <20110124131839.766969d3@pedra>
In-Reply-To: <20110124131839.766969d3@pedra>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <364852AD-6BC8-40FD-97D0-0BF8AD0DC6C2@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 04/13] [media] rc/keymaps: Use KEY_LEFTMETA were pertinent
Date: Mon, 24 Jan 2011 10:45:30 -0500
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 24, 2011, at 10:18 AM, Mauro Carvalho Chehab wrote:

> Using xev and testing the "Windows" key on a normal keyboard, it
> is mapped as KEY_LEFTMETA. So, as this is the standard code for
> it, use it, instead of a generic, meaningless KEY_PROG1.

Not sure I agree with this change, or at least, not with using
KEY_LEFTMETA. The Window MCE key isn't quite analogous to the Windows
key on a keyboard. Under Windows, I'm pretty sure its a program
launcher key, that launches (or switches you to) the Windows Media
Center UI.

-- 
Jarod Wilson
jarod@wilsonet.com



