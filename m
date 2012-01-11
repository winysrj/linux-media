Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61914 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2AKAB0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 19:01:26 -0500
Received: by werm1 with SMTP id m1so120991wer.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 16:01:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0CC81A.6010301@gmail.com>
References: <4F0C3D1B.2010904@gmail.com>
	<CALzAhNVo4Aar7YbF1f6BU7Fp9Uceb5Nq5-JSb2tP0aNYiEra6A@mail.gmail.com>
	<4F0CC81A.6010301@gmail.com>
Date: Tue, 10 Jan 2012 19:01:25 -0500
Message-ID: <CALzAhNWG9VM=QtEXzm_qJXdKnbP+5Q=ZPm+8jLtJObfV4+vfJg@mail.gmail.com>
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
From: Steven Toth <stoth@kernellabs.com>
To: Jim Darby <uberscubajim@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> status SCVYL | signal ffff | snr 00ee | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal ffff | snr 00f0 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
>
> and when it stopped working, this time an hour later, nothing had changed.
> In fact, it looks like the driver keeps lock even when it's not recording at
> all.
>
> Any ideas anyone? Looks like the tuner is OK....

It sounds signal, hardware or heat/environmental related, unlikely to
be driver related.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
