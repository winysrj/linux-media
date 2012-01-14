Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56275 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756564Ab2ANUWB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 15:22:01 -0500
Subject: Re: cx25840: improve audio for cx2388x drivers
From: Andy Walls <awalls@md.metrocast.net>
To: Miroslav =?UTF-8?Q?Sluge=C5=88?= <thunder.mmm@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Sat, 14 Jan 2012 15:21:56 -0500
In-Reply-To: <CAEN_-SDUfyu34YSV6Lr4yADkNmr6=+TALN0xvrCODFPeRedkFA@mail.gmail.com>
References: <CAEN_-SDUfyu34YSV6Lr4yADkNmr6=+TALN0xvrCODFPeRedkFA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <1326572518.1243.43.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2012-01-14 at 19:44 +0100, Miroslav Slugeň wrote:
> Searching for testers, this patch is big one, it was more then week of
> work and testing, so i appriciate any comments and recommendations.

Hi Miroslav,

I have not exhaustively revied this patch, but some general comments:

1. This patch manipulates some video signal tracking behavior (chroma
lock speed), that is not mentioned in the commit message, and is likely
not related to audio detection.  Why?


2. I myself, have multiple types of cards supported by the cx25840
module in my machine: PVR-150, PVR-500, HVR-1850, etc.  Having a module
parameter, "audio_standard_force", that applies globally, instead of per
card model, is not the right thing to do.


3. You have to be very careful when changing anything in the cx25840
module.  It is very easy to introduce a regression for other boards.

The A/V core and microcontroller firmware in the CX2584[0123] and
CX23418 chips are similar to each other.

The A/V core and microcontroller firmware in the CX2388[578] and
CX2310[012] chips are similar to each other.

However, the differences between these two groups of chips are
noticable.  When in doubt, you cannot rely on information in the
CX25840/1/2/3 data sheet to apply to the CX2388[578] and CX2310[012]
chips.

(To ease code maintence and regression testing, I have wanted to split
the support for the CX2310[012] and CX2388[578] chips out to another
module.  Such a split eased code maintenance and testing for the cx18
driver and CX23418 boards.  However, I haven't had any time. :( )


4. The CX2584x chips have differences in audio decoding capability:

	CX25843 Worldwide Audio Decoding
	CX25842 A2, NICAM, FM, AM Audio Decoding
	CX25841 BTSC (with DBX), EIA-J Audio Decoding
	CX25840 BTSC (without DBX), EIA-J Audio Decoding

(I have seen all but the CX25840 used in actual board designs.)

Does your patch consider the chips with limited broadcast audio
decoding?


5. Even though the CX2583[67] chips do not have audio, some board
designs still use the AUX_PLL clock normally used for the audio clock in
the other chips.  Make sure it AUX_PLL setup is not affected for the
CX2483[67] chips.  (I don't think you did, but I only skimmed the
patch).

Regards,
Andy

