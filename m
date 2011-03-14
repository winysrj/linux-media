Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57065 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1CNEKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 00:10:54 -0400
Received: by iwn34 with SMTP id 34so4551017iwn.19
        for <linux-media@vger.kernel.org>; Sun, 13 Mar 2011 21:10:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201103131331.16338.hverkuil@xs4all.nl>
References: <201103131331.16338.hverkuil@xs4all.nl>
Date: Mon, 14 Mar 2011 15:10:53 +1100
Message-ID: <AANLkTikJDt-sDaPNPipGRo7kLjLysSw4z-Yq4LOOnibg@mail.gmail.com>
Subject: Re: [ANN] Agenda for the Warsaw meeting.
From: Jason Hecker <jhecker@wireless.org.au>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> B) Use of V4L2 as a frontend for SW/DSP codecs
>   (Laurent)

This would be good.   Realtek's RT2832U chip can tune to and possibly
demodulate DAB/DAB+ and FM along with the usual DVB-T.  Realtek does
support DAB and FM in Windows with this part but not in Linux and in
spite of promises from one of their developers I haven't seen anything
from them.  I think it'd be good to get this part talking to the DAB
processing routines in OpenDAB or OpenMoko as I strongly suspect the
part can tune to and provide a digital version of the bandband signal
for demodulation of DAB or FM in user space.

It might be a good opportunity to get a signal processing framework
into the driver but I suspect an API to allow a user space demodulator
to read ADC baseband data from such a device would be best and safest.
