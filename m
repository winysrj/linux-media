Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:45645 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755161Ab0JRS53 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 14:57:29 -0400
Date: Mon, 18 Oct 2010 20:57:29 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: =?iso-8859-1?Q?Herv=E9?= Cauwelier <herve.cauwelier@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: support for AF9035 (not tuner)
Message-ID: <20101018185729.GA8210@minime.bse>
References: <4CBBFCBA.2010707@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CBBFCBA.2010707@free.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 18, 2010 at 09:52:26AM +0200, Hervé Cauwelier wrote:
> I got a USB video grabber, which is a dumb analog video converter.
> 
> Installing it under Windows with the given drivers reveals it as
> "AF9035 Analog Capture Filter", when capturing from VLC for example.

There is no open source driver making use of the I2S and ITU656
interfaces of this chip. Both Antti's and Afatech/ITE's driver only
do DVB-T.

There must be one more chip in that grabber doing the actual
analog->digital conversion. Do you know which one?
Or can you provide a link to the Windows driver?

  Daniel
