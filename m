Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm30-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.190]:42944 "HELO
	nm30-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751469Ab1HOIxf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 04:53:35 -0400
Message-ID: <1313398414.28425.YahooMailClassic@web121715.mail.ne1.yahoo.com>
Date: Mon, 15 Aug 2011 01:53:34 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: PCTV 290e - assorted problems
To: Steve Kerrison <steve@stevekerrison.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
In-Reply-To: <1313397881.2818.11.camel@ares>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Mon, 15/8/11, Steve Kerrison <steve@stevekerrison.com> wrote:
> It depends on whether the problem is a weak signal or a too strong
> signal.

I suspect that the HD signal is too weak where I am, because I am in the transmitter's "green area". So it's possible that I'll have to wait until April before getting a decent HD service.

Hmph! Well, at least I'll have time to look into that locking bug... The em28xx_dvb module's clean-up code might be a good place to start, if unloading this module "fixes" things.

Cheers,
Chris

