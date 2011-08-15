Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60184 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1HOJ4p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 05:56:45 -0400
Received: by vxi9 with SMTP id 9so3706266vxi.19
        for <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 02:56:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E486AA2.30905@iki.fi>
References: <4E486AA2.30905@iki.fi>
Date: Mon, 15 Aug 2011 11:56:43 +0200
Message-ID: <CAPEGoTBhSkud+QLACn3i=AFpx8wYDk1O=mSJHF8iPjGCxibEfA@mail.gmail.com>
Subject: Re: dvb-apps: update DVB-T intial tuning files for Finland (fi-*)
From: Hein Rigolo <rigolo@gmail.com>
To: Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Christoph Pfister <christophpfister@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 15, 2011 at 2:38 AM, Antti Palosaari <crope@iki.fi> wrote:
> Updates all Finnish channels as today.
>
> Antti

Do we still need to have separate initial tuning files per region in finland?

For France it was decided that the auto-With167kHzOffsets file would
be enough to find all possible DVB-T transponders in France. It was
suggested to create a fr-All that would be symlinked to the
auto-With167kHzOffsets file, but that was not implemented yet (as far
as I can see from the dvb-apps repository)

Can this approach also work for Finland?

Hein
