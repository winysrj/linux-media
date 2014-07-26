Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:8569 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaGZSMg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 14:12:36 -0400
Date: Sat, 26 Jul 2014 15:12:26 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	Linux-Media <linux-media@vger.kernel.org>,
	linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/5] saa7164: convert to seq_hex_dump()
Message-id: <20140726151226.44cbb027.m.chehab@samsung.com>
In-reply-to: <CALzAhNUUqJNm=o0YoLqoLEnARJ6L34WpcCYScEx5aDeef4B1nQ@mail.gmail.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1404919470-26668-3-git-send-email-andriy.shevchenko@linux.intel.com>
 <CALzAhNUUqJNm=o0YoLqoLEnARJ6L34WpcCYScEx5aDeef4B1nQ@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Jul 2014 14:24:29 -0400
Steven Toth <stoth@kernellabs.com> escreveu:

> On Wed, Jul 9, 2014 at 11:24 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Instead of custom approach let's use recently added seq_hex_dump() helper.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> ack
> 
> Reviewed-by: Steven Toth <stoth@kernellabs.com>
> 
Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Regards,
Mauro
