Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63263 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab2AJNyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 08:54:09 -0500
Received: by werm1 with SMTP id m1so3482998wer.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 05:54:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0C3D1B.2010904@gmail.com>
References: <4F0C3D1B.2010904@gmail.com>
Date: Tue, 10 Jan 2012 08:54:08 -0500
Message-ID: <CALzAhNVo4Aar7YbF1f6BU7Fp9Uceb5Nq5-JSb2tP0aNYiEra6A@mail.gmail.com>
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
From: Steven Toth <stoth@kernellabs.com>
To: Jim Darby <uberscubajim@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The Nanostick works fine for between 5 and 25 minutes and then without any
> error messages cuts out. The TS drops to a tiny stream of non-TS data. It
> seems to contain a lot of 0x00s and 0xffs.

What does femon show for demodulator statistics?

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
