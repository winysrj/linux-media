Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:46141 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab2EQUp5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 16:45:57 -0400
Message-ID: <4FB55DFD.5040704@deckpoint.ch>
Date: Thu, 17 May 2012 22:22:21 +0200
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: Andrew Benham <adsb@adsb.co.uk>
CC: Russel Winder <russel@winder.org.uk>,
	Andy Furniss <andyqos@ukfsn.org>,
	Mark Purcell <mark@purcell.id.au>, linux-media@vger.kernel.org,
	Darren Salt <linux@youmustbejoking.demon.co.uk>,
	669715-forwarded@bugs.debian.org
Subject: Re: Fwd: Bug#669715: dvb-apps: Channel/frequency/etc. data needs
 updating for London transmitters
References: <201205132005.47858.mark@purcell.id.au>   <4FAF89DB.9020004@ukfsn.org>  <1336906328.19220.277.camel@launcelot.winder.org.uk>  <4FAFC3CA.7070008@ukfsn.org> <1336921909.9715.3.camel@anglides.winder.org.uk> <4FB0F273.6000303@adsb.co.uk>
In-Reply-To: <4FB0F273.6000303@adsb.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5/14/12 1:54 PM, Andrew Benham wrote:

> I don't know if it's just Crystal Palace, but one of the multiplexes
> thinks it's using QPSK even though it's using QAM64 - this messes up
> 'scan' unless one reorders the frequency list.
> Having done the scan, one then needs to replace 'QPSK' by 'QAM_64' in
> the output.

I reported the issue through my channels and the issue was fixed earlier 
this evening. The DVB-SI tables have been updated so that now the 
constellation type has been changed from 0 (QPSK) to 2 (64-QAM).

Thomas
