Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:47313 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3KONgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 08:36:38 -0500
Received: by mail-we0-f177.google.com with SMTP id t60so3519325wes.36
        for <linux-media@vger.kernel.org>; Fri, 15 Nov 2013 05:36:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19084.1384522337@warthog.procyon.org.uk>
References: <20271.1384472102@warthog.procyon.org.uk>
	<28089.1384515232@warthog.procyon.org.uk>
	<52861C55.6050307@iki.fi>
	<19084.1384522337@warthog.procyon.org.uk>
Date: Fri, 15 Nov 2013 08:36:37 -0500
Message-ID: <CAGoCfix6pLboc8VCt+j_FZeDa8GWaGiR0tgXA-ffsXKbVXAqdw@mail.gmail.com>
Subject: Re: I2C transfer logs for Antti's DS3103 driver and DVBSky's DS3103 driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: David Howells <dhowells@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarkko Korpi <jarkko_korpi@hotmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 15, 2013 at 8:32 AM, David Howells <dhowells@redhat.com> wrote:
> Whilst that may be so, something clears it between one call to
> m88ds3103_set_frontend() and the next, so you probably need to unconditionally
> reload the program init table.

Check your GPIO config for the specific board in the cx23885 driver.
Registers unexpectedly resetting to their default value between tunes
could very well be because your GPIO setup is incorrect and the
demodulator chip's reset line is being strobed between tuning
requests.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
