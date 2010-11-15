Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61714 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab0KOPJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 10:09:32 -0500
Received: by fxm6 with SMTP id 6so1806285fxm.19
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 07:09:30 -0800 (PST)
Date: Mon, 15 Nov 2010 16:09:03 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	stefano.pompa@gmail.com
Subject: Re: Hauppauge WinTV MiniStick IR in 2.6.36 - [PATCH]
Message-ID: <20101115150903.GB10718@linux-m68k.org>
References: <20101115112746.GB6607@linux-m68k.org> <1289824506.2057.9.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289824506.2057.9.camel@morgan.silverblock.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Nov 15, 2010 at 07:35:06AM -0500, Andy Walls wrote:
> On Mon, 2010-11-15 at 12:27 +0100, Richard Zidlicky wrote:

> http://git.linuxtv.org/v4l-utils.git?a=tree;f=utils/keytable;h=e599a8b5288517fc7fe58d96f44f28030b04afbc;hb=HEAD

thanks, that should do the trick. 

In addition I am wondering if the maps of the two remotes that apparently get 
bundled with the MiniStick should not be merged into one map in the kernel sources 
so the most common cases are covered?

Richard
