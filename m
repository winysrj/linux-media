Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41006 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbbFCHzi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 03:55:38 -0400
Message-ID: <556EB2F7.506@iki.fi>
Date: Wed, 03 Jun 2015 10:55:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Stephen Allan <stephena@intellectit.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
References: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>
In-Reply-To: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 06:55 AM, Stephen Allan wrote:
> I am aware that there is some development going on for the saa7164 driver to support the Hauppauge WinTV-HVR2205.  I thought I would post some feedback.  I have recently compiled the driver as at 2015-05-31 using "media build tree".  I am unable to tune a channel.  When running the following w_scan command:
>
> w_scan -a4 -ft -cAU -t 3 -X > /tmp/tzap/channels.conf
>
> I get the following error after scanning the frequency range for Australia.
>
> ERROR: Sorry - i couldn't get any working frequency/transponder
>   Nothing to scan!!
>
> At the same time I get the following messages being logged to the Linux console.
>
> dmesg
> [165512.436662] si2168 22-0066: unknown chip version Si2168-
> [165512.450315] si2157 21-0060: found a 'Silicon Labs Si2157-A30'
> [165512.480559] si2157 21-0060: firmware version: 3.0.5
> [165517.981155] si2168 22-0064: unknown chip version Si2168-
> [165517.994620] si2157 20-0060: found a 'Silicon Labs Si2157-A30'
> [165518.024867] si2157 20-0060: firmware version: 3.0.5
> [165682.334171] si2168 22-0064: unknown chip version Si2168-
> [165730.579085] si2168 22-0064: unknown chip version Si2168-
> [165838.420693] si2168 22-0064: unknown chip version Si2168-
> [166337.342437] si2168 22-0064: unknown chip version Si2168-
> [167305.393572] si2168 22-0064: unknown chip version Si2168-
>
>
> Many thanks to the developers for all of your hard work.

Let me guess they have changed Si2168 chip to latest "C" version. Driver 
supports only A and B (A20, A30 and B40). I have never seen C version.

regards
Antti

-- 
http://palosaari.fi/
