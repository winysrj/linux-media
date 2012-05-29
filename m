Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65535 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2E2V2q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 17:28:46 -0400
Received: by bkcji2 with SMTP id ji2so3509837bkc.19
        for <linux-media@vger.kernel.org>; Tue, 29 May 2012 14:28:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFBinCBeO7Y+HPoWSnv643idxkUW-TU28sosPn_dcgVQHYXxjg@mail.gmail.com>
References: <1338154013-5124-3-git-send-email-martin.blumenstingl@googlemail.com>
	<1338325692-19684-1-git-send-email-martin.blumenstingl@googlemail.com>
	<CAOMZO5Bmc3cesaJ_y_NgSaAPYQpcwOUtn_6TX=khg7k=4da-Bg@mail.gmail.com>
	<CAFBinCCy4f84F-G8pup5sesc+GNr13pWakKkfzYxxChnrpQx2Q@mail.gmail.com>
	<CAFBinCBeO7Y+HPoWSnv643idxkUW-TU28sosPn_dcgVQHYXxjg@mail.gmail.com>
Date: Tue, 29 May 2012 18:28:44 -0300
Message-ID: <CAOMZO5AFVfXgWX=DwqALDLdLz-ZYRMipAegXeyxhDfCX2HN+RA@mail.gmail.com>
Subject: Re: [PATCH] [media] em28xx: Show a warning if the board does not
 support remote controls
From: Fabio Estevam <festevam@gmail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 29, 2012 at 6:26 PM, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> Hello Fabio,
>
> I can use dev_err if you want.

Or maybe dev_warn is better since this is a warning.
