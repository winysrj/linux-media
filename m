Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51776 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab0EKWfw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 18:35:52 -0400
Received: by fxm15 with SMTP id 15so173614fxm.19
        for <linux-media@vger.kernel.org>; Tue, 11 May 2010 15:35:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100508160628.GA6050@z60m>
References: <20100508160628.GA6050@z60m>
Date: Wed, 12 May 2010 00:35:51 +0200
Message-ID: <AANLkTinWb02B0KiJsP8ZEnQJqsWMhr6gCz73psjK3uob@mail.gmail.com>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
From: davor emard <davoremard@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI

I tried to fix unreliable IR remote keys (cca 10% lost key presses),
the similar problem has been reported on the same card with
windows driver too and I had other saa7134 analog tv card also
loosing IR keys

I have tried modifying saa7134-input.c to use gpio polling with interval
of 15ms and 5ms but it did not help - always some IR key presses are
lost.

Is it any workarond possible for lost keys, that's pretty annoying?
