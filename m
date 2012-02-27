Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:56771 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752381Ab2B0AdY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 19:33:24 -0500
Date: Mon, 27 Feb 2012 01:33:21 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Hans-Frieder Vogt <hfvogt@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] Firmware for AF9035/AF9033 driver
Message-ID: <20120227003321.GA25060@minime.bse>
References: <201202222322.02424.hfvogt@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202222322.02424.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 22, 2012 at 11:22:02PM +0100, Hans-Frieder Vogt wrote:
> 00000040: Firmware_CODELENGTH bytes

Some time ago I analyzed the firmware of the AF9035.
The firmware download command inside the on-chip ROM expects chunks
with a 7 byte header:

Byte 0: MCS 51 core
	There are two inside the AF9035 (1=Link and 2=OFDM) with
	separate address spaces
Byte 1-2: Big endian destination address
Byte 3-4: Big endian number of data bytes following the header
Byte 5-6: Big endian header checksum, apparently ignored by the chip
	Calculated as ~(h[0]*256+h[1]+h[2]*256+h[3]+h[4]*256)

This might help locate the firmware inside the Windows drivers.
The Windows drivers often contain two copies of the same firmware.

  Daniel
