Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35655 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbcDIBwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2016 21:52:33 -0400
Received: by mail-lf0-f54.google.com with SMTP id c126so96762986lfb.2
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2016 18:52:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57085943.5010805@iki.fi>
References: <57083b12.ec3ec20a.eed91.1ea1SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAO8Cc0qC79u_BBV3xaat3Cy6E2XB+GtJfJSf3aCJX==Q++BaXg@mail.gmail.com>
	<570851E4.30801@iki.fi>
	<57085943.5010805@iki.fi>
Date: Sat, 9 Apr 2016 03:52:31 +0200
Message-ID: <CAO8Cc0p2vw6g_qEVAL8BowU9394gpOJXYVcEbgbQo-e3mN3q0Q@mail.gmail.com>
Subject: Re: AVerMedia HD Volar (A867) AF9035 + MXL5007T driver issues
From: Alessandro Radicati <alessandro@radicati.net>
To: Antti Palosaari <crope@iki.fi>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 9, 2016 at 3:22 AM, Antti Palosaari <crope@iki.fi> wrote:
> Here is patches to test:
> http://git.linuxtv.org/anttip/media_tree.git/log/?h=af9035
>

I've done this already in my testing, and it works for getting a
correct chip_id response, but only because it's avoiding the issue
with the write/read case in the af9035 driver.  Don't have an
af9015... perhaps there's a similar issue with that code or we are
dealing with two separate issues since af9035 never does a repeated
start?

> After that both af9015+mxl5007t and af9035+mxl5007t started working. Earlier
> both were returning bogus values for chip id read.
>
> Also I am interested to known which kind of communication there is actually
> seen on I2C bus?

With this or the patch I proposed, you see exactly what you expect on
the I2C bus with repeated stops, as detailed in my previous mails.

>
> If it starts working then have to find out way to fix it properly so that
> any earlier device didn't broke.
>

I hope that by now I've made abundantly clear that my mxl5007t locks
up after *any* read.  It doesn't matter if we are reading the correct
register after any of the proposed patches.

Thanks,
Alessandro
