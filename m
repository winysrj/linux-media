Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51816 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab2ENLyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 07:54:43 -0400
Message-ID: <4FB0F273.6000303@adsb.co.uk>
Date: Mon, 14 May 2012 12:54:27 +0100
From: Andrew Benham <adsb@adsb.co.uk>
MIME-Version: 1.0
To: Russel Winder <russel@winder.org.uk>
CC: Andy Furniss <andyqos@ukfsn.org>,
	Mark Purcell <mark@purcell.id.au>, linux-media@vger.kernel.org,
	Darren Salt <linux@youmustbejoking.demon.co.uk>,
	669715-forwarded@bugs.debian.org
Subject: Re: Fwd: Bug#669715: dvb-apps: Channel/frequency/etc. data needs
 updating for London transmitters
References: <201205132005.47858.mark@purcell.id.au>   <4FAF89DB.9020004@ukfsn.org>  <1336906328.19220.277.camel@launcelot.winder.org.uk>  <4FAFC3CA.7070008@ukfsn.org> <1336921909.9715.3.camel@anglides.winder.org.uk>
In-Reply-To: <1336921909.9715.3.camel@anglides.winder.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Of course it's not just the data for the London transmitters which needs
to be updated - most of GB has now switched to digital only with
different channel allocations.

I've been using the information from
http://stakeholders.ofcom.org.uk/broadcasting/guidance/tech-guidance/dsodetails/
to derive new data.

I don't know if it's just Crystal Palace, but one of the multiplexes
thinks it's using QPSK even though it's using QAM64 - this messes up
'scan' unless one reorders the frequency list.
Having done the scan, one then needs to replace 'QPSK' by 'QAM_64' in
the output.

See also:
http://www.adsb.co.uk/linuxtv/

-- 
Andrew Benham, Southgate, London N14, United Kingdom

The gates in my computer are AND OR and NOT, not "Bill"
