Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55454 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab2BIPBP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Feb 2012 10:01:15 -0500
Received: from dyn3-82-128-189-227.psoas.suomi.net ([82.128.189.227] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1RvVUn-0002HR-6f
	for linux-media@vger.kernel.org; Thu, 09 Feb 2012 17:01:13 +0200
Message-ID: <4F33DFB8.4080702@iki.fi>
Date: Thu, 09 Feb 2012 17:01:12 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: SDR FM demodulation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have taken radio sniffs from FM capable Realtek DVB-T device. Looks 
like demodulator ADC samples IF frequency and pass all the sampled data 
to the application. Application is then responsible for decoding that. 
Device supports DVB-T, FM and DAB. I can guess  both FM and DAB are 
demodulated by software.

Here is 17 second, 83 MB, FM radio sniff:
http://palosaari.fi/linux/v4l-dvb/rtl2832u_fm/
Decode it and listen some Finnish speak ;)

Could someone help to decode it? I tried GNU Radio, but I failed likely 
because I didn't have enough knowledge... GNU Radio and Octave or Matlab 
are way to go.

I smell very cheap poor man's software radio here :)

regards
Antti
-- 
http://palosaari.fi/
