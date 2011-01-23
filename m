Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:43216 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751037Ab1AWQdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 11:33:21 -0500
Cc: rglowery@exemail.com.au, linux-media@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Sun, 23 Jan 2011 17:33:18 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <4D3C3750.8060301@redhat.com>
Message-ID: <20110123163318.25910@gmx.net>
MIME-Version: 1.0
References: <20110123001615.86290@gmx.net> <4D3C3750.8060301@redhat.com>
Subject: Re: [RFC PATCH] Getting Hauppauge WinTV HVR-1400 (XC3028L) to work
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro!

> This is problematic, as it seems to be country-specific and/or
> demod-specific. 
> We'll need to work on a different solution for it. On what Country do you
> live?
> By looking at HVR1400 entry, it uses a dibcom 7000p demod.
> We need to know what are country/demod for the users for whose the old
> code
> were broken.

I live in Germany. In which country, with which hardware does the old code work, and the new not?

Old code:

if (priv->cur_fw.type & DTV7)
	offset += 500000;


New code:

if (priv->firm_version < 0x0302) {
	if (priv->cur_fw.type & DTV7)
		offset += 500000;
} else {
	if (priv->cur_fw.type & DTV7)
		offset -= 300000;
	else if (type != ATSC) /* DVB @6MHz, DTV 8 and DTV 7/8 */
		offset += 200000;
}

Cheers,
Alina
