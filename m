Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64964 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab3AQJZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 04:25:08 -0500
Received: by mail-ee0-f53.google.com with SMTP id e53so1121737eek.40
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 01:25:07 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 17 Jan 2013 11:19:20 +0200
Message-ID: <CAEK=PesFD3X61dG9ZeQ-oMs_amr4moTz=0pPbpX3sHESfTWDWw@mail.gmail.com>
Subject: Baseband I/Q raw data from a dvb-s/dvb-s2 card. Is it possible ?
From: Stelios Koroneos <stelios.koroneos@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings to all !
First of all apologies, as this might not an "on-topic " question for the list.

I am looking for a way to access the raw baseband I/Q data either for
dvb-s or dvb-s2 but i am kind of confused if this is possible and with
which card.
I had a look at some of the driver(s) code, but still could not figure it out.
As far as i can tell a demodulator like the STB0899 for example
provides this info but i am not sure if this is available by the
driver, or if there are any other alternatives.

The reason i want to access the raw I/Q stream is because i am in the
process of building a high speed random number generator that will use
the thermal noise
 produced by the LNB

I know its possible to tap to the I/Q stream by adding some external
fast ADC/comperator but i am looking to see if there is a way to do
that without modifications to the card etc

Any help,info,pointers would be highly appreciated

Best regards

Stelios


PGP Key fingerprint = DC66 109A 6C3A 2D65 BA52  806E 6122 DAF4 32E7 076A
