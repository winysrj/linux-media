Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:46477 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711AbcB0UUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 15:20:16 -0500
Date: Sat, 27 Feb 2016 21:14:10 +0100
From: Antonio Ospite <ao2@ao2.it>
To: Jannik Becher <becher.jannik@gmail.com>
Cc: crope@iki.fi, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jannik Becher <Becher.Jannik@gmail.com>
Subject: Re: [PATCH] Media: usb: hackrf: fixed a style issue
Message-Id: <20160227211410.de7c8d21d1ab84c5870221cf@ao2.it>
In-Reply-To: <1456602156-25011-1-git-send-email-Becher.Jannik@gmail.com>
References: <1456602156-25011-1-git-send-email-Becher.Jannik@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 27 Feb 2016 20:42:36 +0100
Jannik Becher <becher.jannik@gmail.com> wrote:

> Fixed a coding style issue.
>

You should be more specific: which style issue?
See also my comment below.

> Signed-off-by: Jannik Becher <Becher.Jannik@gmail.com>
> ---
>  drivers/media/usb/hackrf/hackrf.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
> index 9e700ca..186ef2d 100644
> --- a/drivers/media/usb/hackrf/hackrf.c
> +++ b/drivers/media/usb/hackrf/hackrf.c
> @@ -249,6 +249,7 @@ static int hackrf_set_params(struct hackrf_dev *dev)
>  	unsigned int uitmp, uitmp1, uitmp2;
>  	const bool rx = test_bit(RX_ON, &dev->flags);
>  	const bool tx = test_bit(TX_ON, &dev->flags);
> +
>  	static const struct {
>  		u32 freq;
>  	} bandwidth_lut[] = {

If this has been found by scripts/checkpatch.pl as:

WARNING: Missing a blank line after declarations
#252: FILE: drivers/media/usb/hackrf/hackrf.c:252:
+       const bool tx = test_bit(TX_ON, &dev->flags);
+       static const struct {

it is a false positive, as the code which follows the blank line is a
declaration too.

Ciao ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
