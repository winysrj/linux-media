Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43215 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0IIIUc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 04:20:32 -0400
Received: by fxm16 with SMTP id 16so709176fxm.19
        for <linux-media@vger.kernel.org>; Thu, 09 Sep 2010 01:20:30 -0700 (PDT)
Subject: Re: [PATCH 1/5] rc-code: merge and rename ir-core
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <20100908211217.GA13938@hardeman.nu>
References: <dciu6r836199wbxqd3ppo8xr.1283957431820@email.android.com>
	 <20100908211217.GA13938@hardeman.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 11:20:23 +0300
Message-ID: <1284020423.8362.2.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, 2010-09-08 at 23:12 +0200, David Härdeman wrote: 
> On Wed, Sep 08, 2010 at 11:10:40AM -0400, Andy Walls wrote:
> > Tag files and a decent editor are all one needs for full code 
> > navigation.  The kernel makefile already has a tags target to make the 
> > tags file.  
> 
> If you like to use tags, it won't be affected by many or few files so 
> it's not an argument for either approach. 
> 
> > Smaller files make for better logical isolation of functions,limiting 
> > visibilty/scope, 
> 
> Limiting visibility so that you'll have to add explicit declarations to 
> ir-core-priv.h for inter-file function calls and functions that would 
> otherwise be unnecessary (ir_raw_get_allowed_protocols() for example) 
> doesn't sound like an advantage to me.
> 
> > and faster compilation of a file (but maybe at the expense of link 
> > time).  
> 
> *sigh* compile times on my laptop:
> 
> rc-core.o		0.558s
> 
> ir-functions.o		0.321s
> ir-sysfs.o		0.251s
> ir-raw-event.o		0.397s
> rc-map.o		0.265s

I personally don't care much about this.
I use Kscope all the time :-)

However I do care and like very much this patchset because I also would
like to have a per remote input device, and this is first step towards
it.

Best regards,
Maxim Levitsky

