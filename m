Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36650 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1KFR6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 12:58:07 -0500
Received: by mail-wy0-f174.google.com with SMTP id 15so3779416wyh.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 09:58:07 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: FX2 FW: conversion from Intel HEX to DVB USB "hexline"
Date: Sun, 6 Nov 2011 18:58:00 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <4EB6990C.8000904@iki.fi>
In-Reply-To: <4EB6990C.8000904@iki.fi>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_oqstO7LoV3K4a26"
Message-Id: <201111061858.00709.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_oqstO7LoV3K4a26
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Antti,

On Sunday, November 06, 2011 03:26:20 PM Antti Palosaari wrote:
> Is there any simple tool (or one liner script :) to convert normal Intel
> HEX firmware to format used by DVB USB Cypress firmware loader?
> 
> Or is there some other way those are created?
> 
> Loader is here:
> dvb-usb-firmware.c
> int usb_cypress_load_firmware()

I'm sure that you have found something yourself in the meantime, but I used 
the attached script to convert .hex to binaries.

HTH,

--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/

--Boundary-00=_oqstO7LoV3K4a26
Content-Type: application/x-perl;
  name="hex2bin.pl"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="hex2bin.pl"

#!/usr/bin/perl -w

use strict;

print STDERR "hex-file2binary converter.\n";


while (<>) {
	last if $_ =~ /:00000001FF/;
	my @line = $_ =~ /([0-9A-Fa-f]{2})/g;

	# intel address 16Bit address
	my $t = $line[1];
	$line[1] = $line[2];
	$line[2] = $t;

	foreach (@line) {
		printf "%c", eval "0x$_";
	}
}

--Boundary-00=_oqstO7LoV3K4a26--
