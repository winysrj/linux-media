Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:63433 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbaCQRBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 13:01:51 -0400
Received: by mail-qc0-f171.google.com with SMTP id c9so413007qcz.16
        for <linux-media@vger.kernel.org>; Mon, 17 Mar 2014 10:01:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2300906.aKyjnYIEg7@radagast>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
	<CAKv9HNav3DYRcX8B_N5db012-ShoGVc7rbLW1oWV-rgcwDaGmg@mail.gmail.com>
	<2300906.aKyjnYIEg7@radagast>
Date: Mon, 17 Mar 2014 19:01:51 +0200
Message-ID: <CAKv9HNbwftG5-mz6uLKH68AuHOK-PgDB4AZa0qHEWCXKL_+q+A@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] rc: Add IR encode based wakeup filtering
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On 17 March 2014 00:41, James Hogan <james@albanarts.com> wrote:
>
> Yeh I'm in two minds about this now. It's actually a little awkward since some
> of the protocols have multiple variants (i.e. "rc-5" = RC5+RC5X), but an
> encoded message is only ever a single variant, so technically if you're going
> to draw the line for wakeup protocols it should probably be at one enabled
> variant, which isn't always convenient or necessary.

I'd very much prefer to have the selector as it currently is -
protocol groups instead of variants which would keep it consistent
with decoding protocol selection.

>
> Note, ATM even disallowing "+proto" and "-proto" we would already have to
> guess which variant is desired from the scancode data, which in the case of
> NEC scancodes is a bit horrid since NEC scancodes are ambiguous. This actually
> means it's driver specific whether a filter mask of 0x0000ffff filters out
> NEC32/NEC-X messages (scancode/encode driver probably will since it needs to
> pick a variant, but software fallback won't).
>

How common is it that NEC codes are really ambiguous? Or that a wrong
variant is selected for encoding? A quick look suggests that the
length of the scancode will be good enough way to determine which
variant is used for NEC, RC-5(X) and RC-6(A).

If the variant is really needed selecting it might be done in some
other sysfs file. But I'd not implement it yet if we can manage
without such logic.

-Antti
