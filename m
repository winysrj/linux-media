Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50890 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2ECL1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 07:27:53 -0400
Received: by were53 with SMTP id e53so1032163wer.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 04:27:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHAyoxxRQUecyVf-M52htoDYdF7b+xTJy27ctBm68Xgw20_XMw@mail.gmail.com>
References: <CAHAyoxxRQUecyVf-M52htoDYdF7b+xTJy27ctBm68Xgw20_XMw@mail.gmail.com>
Date: Thu, 3 May 2012 07:27:52 -0400
Message-ID: <CAHAyoxyPiJr5jpDrnDvVqZnpO-A6BD7bmmiLr0jh_OJuxEeujA@mail.gmail.com>
Subject: [RESEND GIT PULL] git://linuxtv.org/mkrufky/hauppauge.git windham-ids
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 22, 2012 at 1:00 PM, Michael Krufky <mkrufky@kernellabs.com> wrote:
> Mauro,
>
> Please merge this small patch for a USB ID addition


Mauro,

I do not believe this ever got merged.  :-(

At this point, since it got so old, can you add Cc to stable to the
patch before merge?

Thanks.


The following changes since commit f92c97c8bd77992ff8bd6ef29a23dc82dca799cb:

  [media] update CARDLIST.em28xx (2012-03-19 23:12:02 -0300)

are available in the git repository at:
  git://git.linuxtv.org/mkrufky/hauppauge.git windham-ids

Michael Krufky (1):
      smsusb: add autodetection support for USB ID 2040:c0a0

 drivers/media/dvb/siano/smsusb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Cheers,

Mike
