Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36935 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab0J1TOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 15:14:36 -0400
Received: by gxk23 with SMTP id 23so1516370gxk.19
        for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 12:14:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101028130806.66bd5b91@bike.lwn.net>
References: <20101027190228.3C87D9D401B@zog.reactivated.net>
	<20101028130806.66bd5b91@bike.lwn.net>
Date: Thu, 28 Oct 2010 20:14:35 +0100
Message-ID: <AANLkTim25tO-WSXeu8UN408+794qe5=3XqJc+5hy3aiM@mail.gmail.com>
Subject: Re: [PATCH] via-camera: fix OLPC serial port check
From: Daniel Drake <dsd@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 28 October 2010 20:08, Jonathan Corbet <corbet@lwn.net> wrote:
> This makes every user carry a bit of OLPC-specific code.  But there are
> no non-OLPC users currently, the code is small, and we get rid of some
> #ifdefs, which is always a good thing.  Seems good to me.

I think the compiler might be smart enough to optimize it out.
When CONFIG_OLPC=n, machine_is_olpc() compiles down to a simple "no".
Hopefully that then makes all of that code candidate for dead code
elimination by the compiler.

Daniel
