Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f191.google.com ([209.85.210.191]:42023 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbZFZOwe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 10:52:34 -0400
Received: by yxe29 with SMTP id 29so264830yxe.33
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 07:52:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <709812.47005.qm@web63406.mail.re1.yahoo.com>
References: <709812.47005.qm@web63406.mail.re1.yahoo.com>
Date: Fri, 26 Jun 2009 10:52:36 -0400
Message-ID: <829197380906260752q54f60ce9x293842e5cbe74d93@mail.gmail.com>
Subject: Re: LGDT3304 help (AverMedia Duet A188)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: oblib <oblib5@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 26, 2009 at 10:42 AM, oblib<oblib5@yahoo.com> wrote:
>
> I'm trying to put together a driver for the AverMedia A188, which is currently unsupported. Manu Abraham is working on the SAA716x driver which it needs, but the frontends seem to be two LGDT3304's.
>
> My google-fu is failing me and I can't find any documentation on the chip. Support for the chip was committed last year, but I don't see any drivers actually using it.
>
> Does anyone have any documentation for the chip, or even better, some examples of how to set it up for a driver. Also I don't know how to find their I2C addresses.
>
> Thanks for any help in advance.

Work was recently done for lgdt3304 support for the K-World 330u by
Jarod Wilson and Michael Krufky.  That work should be making its way
into the mainline driver soon.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
