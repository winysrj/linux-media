Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:33150 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab1AJNJ5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 08:09:57 -0500
Message-ID: <4D2B0521.1020404@linuxtv.org>
Date: Mon, 10 Jan 2011 14:09:53 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Schl=F6ter?= <thomas.schloeter@gmx.net>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DVB Satellite Channel Routing support for DVB-S
References: <BDD0B014-3AD5-4693-82D9-026F47A7F8A4@gmx.net>
In-Reply-To: <BDD0B014-3AD5-4693-82D9-026F47A7F8A4@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hallo Thomas,

thank you for your contribution. However, I'm against applying it.

On 01/10/2011 05:19 AM, Thomas Schlöter wrote:
> I have developed some modifications to the 2.6.37 DVB frontend code to support DVB satellite channel routing (aka "SCR", "Unicable", "EN50494"). Following this standard, all satellite tuners share the same cable and each of them has a fixed intermediate frequency it is supposed to tune to. Zapping is done by sending a special DiSEqC message while SEC voltage is temporarily pulled from 14 to 18 volts. This message includes the tuner's ID from 0 to 7, the frequency, band and polarisation to tune to as well as one out of two satellite positions.
> 
> I decided this should be supported by the kernel frontend code as it is impossible to send that special DiSEqC / voltage sequence from userspace.

Why do you think that's impossible? There's a userspace implementation
in Enigma2.

> Additionally, it adds fully transparent support for SCR to arbitrary applications that use the DVB API, such as MythTV, VDR, xine etc.

That statement is not true, because you have to configure Unicable LNBs,
which you do using dvb-scr-setup.c.

Regards,
Andreas
