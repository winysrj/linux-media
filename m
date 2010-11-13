Return-path: <mchehab@pedra>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34278 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab0KMEDs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 23:03:48 -0500
Subject: Re: Failed build on randconfig for DVB_DIB modules
From: Steven Rostedt <rostedt@goodmis.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	Michal Marek <mmarek@suse.cz>
In-Reply-To: <1289620466.12418.583.camel@gandalf.stny.rr.com>
References: <1288066536.18238.78.camel@gandalf.stny.rr.com>
	 <4CC6BD78.5040200@infradead.org>
	 <1289620466.12418.583.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Nov 2010 23:03:45 -0500
Message-ID: <1289621025.12418.586.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 2010-11-12 at 22:54 -0500, Steven Rostedt wrote:

> Or we just don't test for define(MODULE). If either CONFIG_DVB_DIB3000MC
> or CONFIG_DVB_DIB3000MC_MODULE are defined, the code must be there,
> because, if this code is built as both a module and builtin, only the
> builtin will be created.

Ah, I just tried it, and I see that the code in that #if statement calls
back into the dib3000mc module, so now the core kernel has missing
functions. This is a bit of a nasty web.

I guess it would require one of your proposed solutions, or I just
simply add the dvb configs to my broken-config file and prevent
randconfig from testing it.

-- Steve


