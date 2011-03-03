Return-path: <mchehab@pedra>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:49615 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1CCQL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 11:11:28 -0500
Received: from mfilter8-d.gandi.net (mfilter8-d.gandi.net [217.70.178.34])
	by relay1-d.mail.gandi.net (Postfix) with ESMTP id F18812552F9
	for <linux-media@vger.kernel.org>; Thu,  3 Mar 2011 17:11:26 +0100 (CET)
Received: from relay1-d.mail.gandi.net ([217.70.183.193])
	by mfilter8-d.gandi.net (mfilter8-d.gandi.net [217.70.178.34]) (amavisd-new, port 10024)
	with ESMTP id bJK37jOQMCHA for <linux-media@vger.kernel.org>;
	Thu,  3 Mar 2011 17:11:25 +0100 (CET)
Received: from WIN7PC (ALyon-157-1-213-100.w109-213.abo.wanadoo.fr [109.213.188.100])
	(Authenticated sender: sr@coexsi.fr)
	by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 794942552FD
	for <linux-media@vger.kernel.org>; Thu,  3 Mar 2011 17:11:25 +0100 (CET)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
References: <009f01cbd770$50208a90$f0619fb0$@coexsi.fr>
In-Reply-To: <009f01cbd770$50208a90$f0619fb0$@coexsi.fr>
Subject: RE: [PATCH] DVB : add option to dump PDU exchanged with CAM in dvb_core
Date: Thu, 3 Mar 2011 17:11:29 +0100
Message-ID: <008101cbd9bd$a8380100$f8a80300$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sébastien RAILLARD (COEXSI)
> Sent: lundi 28 février 2011 18:53
> To: Linux Media Mailing List
> Subject: [PATCH] DVB : add option to dump PDU exchanged with CAM in
> dvb_core
> 
> Dear all,
> 
> Here is a patch for the dvb_core module, you'll find it attached to this
> message.
> 
> It's adding a new module integer parameter called "cam_dump_pdu" that
> can have the following values:
> - 0 (by default): don't dump PDU (do nothing)
> - 1: Dump all PDU written and read on device through the syscall
> functions.
> The PDU are dumped in segments of 16 bytes maximum written in
> hexadecimal.
> - 2: like value 1 but remove the commonly used PDU for polling
> (generating a lot of "noise" in the logs)
> 
> The goal of dumping PDU exchanged with CAM is to help debugging userland
> applications and libraries.

I have to add that the PDU dumped are the "TPDU" (Transport Protocol Data
Units), the 2nd level of the stack.
The first level of PDU, the "LPDU" (Link Protocol Data Unit) fragments, are
reassembled by the dvb_core module and are not exposed to the applications.

Anyone interested by this option?

> 
> This is my first patch submission, so I may have made some errors
> regarding the submission rules.
> 
> Best regards,
> Sebastien.

