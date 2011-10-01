Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:57120 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1JAM1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2011 08:27:06 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by slow3-v.mail.gandi.net (Postfix) with ESMTP id B939438B94
	for <linux-media@vger.kernel.org>; Sat,  1 Oct 2011 14:18:37 +0200 (CEST)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: <o.endriss@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: [DVB] CXD2099 - Question about the CAM clock
Date: Sat, 1 Oct 2011 14:18:36 +0200
Message-ID: <000901cc8034$3fcb13f0$bf613bd0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Oliver,

I’ve done some tests with the CAM reader from Digital Devices based on Sony
CXD2099 chip and I noticed some issues with some CAM:
* SMIT CAM    : working fine
* ASTON CAM   : working fine, except that it's crashing quite regularly
* NEOTION CAM : no stream going out but access to the CAM menu is ok

When looking at the CXD2099 driver code, I noticed the CAM clock (fMCLKI) is
fixed at 9MHz using the 27MHz onboard oscillator and using the integer
divider set to 3 (as MCLKI_FREQ=2).

I was wondering if some CAM were not able to work correctly at such high
clock frequency.

So, I've tried to enable the NCO (numeric controlled oscillator) in order to
setup a lower frequency for the CAM clock, but I wasn't successful, it's
looking like the frequency must be around the 9MHz or I can't get any
stream.

Do you know a way to decrease this CAM clock frequency to do some testing?

Best regards,
Sebastien.



