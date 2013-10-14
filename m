Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:39637 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3JNOqR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 10:46:17 -0400
Date: Mon, 14 Oct 2013 15:39:25 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Tom Gundersen <teg@jklm.no>,
	"Juan J. Garcia de Soria" <skandalfo@gmail.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: WPC8769L (WEC1020) support in winbond-cir?
Message-ID: <20131014143925.GA29885@pequod.mess.org>
References: <CAG-2HqX-TO7h8zJ6F01r2LfRVjQtb0pK_1wKGsYVKzB0zC7TQA@mail.gmail.com>
 <20131014110748.366ea45e@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014110748.366ea45e@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 14, 2013 at 11:07:48AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 14 Oct 2013 15:16:20 +0200
> Tom Gundersen <teg@jklm.no> escreveu:
> Not sure about lirc_wpc8769l. David/Sean/Juan can have a better view.

I've just had a cursory look at lirc_wpc8769l. The device does look similar
to winbond-cir, but not exactly the same. I wouldn't mind doing the work but
I don't have the hardware.

> Btw, there are also a number of lirc staging drivers under
> drivers/staging/media/lirc/. We'd love some help trying to convert them
> to use the rc core, moving them out of staging.

Again I'd like to do some work here but I don't have the hardware. I ported
the ttusbir driver after getting the device on ebay for a small amount.


Sean
