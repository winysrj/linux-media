Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:35554 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756985Ab0JRUjd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 16:39:33 -0400
Date: Mon, 18 Oct 2010 22:39:32 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: =?iso-8859-1?Q?Herv=E9?= Cauwelier <herve.cauwelier@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: support for AF9035 (not tuner)
Message-ID: <20101018203932.GB8210@minime.bse>
References: <4CBBFCBA.2010707@free.fr>
 <20101018185729.GA8210@minime.bse>
 <4CBCA407.9080101@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CBCA407.9080101@free.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 18, 2010 at 09:46:15PM +0200, Hervé Cauwelier wrote:
> I've uploaded the compressed installer at http://dl.free.fr/p2BTq9BNi

The driver mentiones two video decoders:
- TI TVP5150
- Trident AVF4900B/AVF4910B

If it is the first one, sniffed USB traffic might be enough to write a
driver as there already is one for the decoder.

The latter one is undocumented. Two months ago I was told by Trident
that the device is not supported as it has been phased out from
production.

  Daniel
