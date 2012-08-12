Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62672 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab2HLAWz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 20:22:55 -0400
Received: by lbbgj3 with SMTP id gj3so796017lbb.19
        for <linux-media@vger.kernel.org>; Sat, 11 Aug 2012 17:22:54 -0700 (PDT)
Message-ID: <5026F74F.5060606@iki.fi>
Date: Sun, 12 Aug 2012 03:22:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Q: c->bandwidth_hz = (c->symbol_rate * rolloff) / 100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hellou

I saw there is nowadays logic in dvb-frontend which calculates 
bandwidth_hz value in cache. Calculation formula seems to be correct. 
But that makes me wonder if that is wise as it gives occupied bandwidth 
instead of nominal. For example I have typical DVB-C annex A, 8 MHz 
bandwidth, symbol rate 6875000 and roll-off factor 0.15. That gives 
calculation result is 7 906 250 Hz for nominal 8 000 000 Hz channel.

This value is used only by tuner. Only visible effect is thus every 
tuner driver should use if statement to compare to find out nominal 
value as tuner chips usually configures low-pass filter steps of 8/7/6/5 
MHz.

For me it sounds better if tuner just gets nominal bandwidth - maybe 
calculating real used bw could be nice too as it is possible to return 
userspace.

Shortly: I see it better to give nominal RF channel value for tuner.

regards
Antti

-- 
http://palosaari.fi/
