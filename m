Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:51505 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025AbaGWUKk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 16:10:40 -0400
Date: Wed, 23 Jul 2014 22:10:12 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Antti Palosaari <crope@iki.fi>, m.chehab@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] get_dvb_firmware: Add firmware extractor for si2165
Message-Id: <20140723221012.3c9e8f26aa1ddac47b48cb9e@ao2.it>
In-Reply-To: <53D006F2.10300@gentoo.org>
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
	<1406059938-21141-2-git-send-email-zzam@gentoo.org>
	<53CF7E6D.20406@iki.fi>
	<53D006F2.10300@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 23 Jul 2014 21:03:14 +0200
Matthias Schwarzott <zzam@gentoo.org> wrote:

[...]
> The crc value:
> It protects the content of the file until it is in the demod - so
> calculating it on my own would only check if the data is correctly
> transferred from the driver into the chip.
> But for this I needed to know the algorithm and which data is
> checksummed exactly.
> 
> Are the different algorithms for CRC values that give 16 bit of output?
>

You could try jacksum[1] and see if any algorithm it supports
gives you the expected result, there is a handful of 16 bits ones:

  jacksum -a all -F "#ALGONAME{i} = #CHECKSUM{i}" payload.bin

Ciao,
   Antonio

[1] http://www.jonelo.de/java/jacksum/

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
