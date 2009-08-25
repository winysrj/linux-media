Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45999 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbZHYWYy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 18:24:54 -0400
Received: by fxm17 with SMTP id 17so2503824fxm.37
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2009 15:24:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A94612A.2070705@iki.fi>
References: <8527bc070908040016x5d5ad15bk8c2ef6e99678f9e9@mail.gmail.com>
	 <200908041312.52878.jareguero@telefonica.net>
	 <8527bc070908041423p439f2d35y2e31014a10433c80@mail.gmail.com>
	 <200908042348.58148.jareguero@telefonica.net>
	 <4A945CA4.6010402@iki.fi>
	 <829197380908251501l7731536bg79dd8595cd7ce50d@mail.gmail.com>
	 <4A94612A.2070705@iki.fi>
Date: Tue, 25 Aug 2009 18:24:55 -0400
Message-ID: <829197380908251524m66bc9a46i5428bdc28ecab153@mail.gmail.com>
Subject: Re: Noisy video with Avermedia AVerTV Digi Volar X HD (AF9015) and
	mythbuntu 9.04
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 25, 2009 at 6:09 PM, Antti Palosaari<crope@iki.fi> wrote:
> If demod (and tuner) is powered off by bridge (.power_ctrl) that's not
> possible. Is there way to call bridge .power_ctrl to wake up demod and
> tuner? I added param for demdod state to track sleep/wake state and return 0
> in sleep case. But that does not sounds good solution...

Michael Krufky actually put together some patches to allow the bridge
to intercept frontend calls, which would allow for things like power
management.  I don't know if they've been merged yet.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
