Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f47.google.com ([209.85.212.47]:48566 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3IKMtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 08:49:25 -0400
Received: by mail-vb0-f47.google.com with SMTP id h10so6025889vbh.34
        for <linux-media@vger.kernel.org>; Wed, 11 Sep 2013 05:49:24 -0700 (PDT)
MIME-Version: 1.0
From: Simon Liddicott <simon@liddicott.com>
Date: Wed, 11 Sep 2013 13:49:04 +0100
Message-ID: <CALuNSF4znGu+NdsZs3eb0A5vqgyHNC13f8qXunNE2tXVxC=UTg@mail.gmail.com>
Subject: Correct scan file format?
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What form should T2 multiplexes take in the DVB scan files?

In the uk-CrystalPalace scan file
<http://git.linuxtv.org/dtv-scan-tables.git/blob/HEAD:/dvb-t/uk-CrystalPalace>
the PLP_ID and System_ID are included before the frequency but in
ro-Krasnador scan file
<http://git.linuxtv.org/dtv-scan-tables.git/blob/HEAD:/dvb-t/ru-Krasnodar>
the PLP_ID is included at the end of the line and it has no System_ID.

I don't have a T2 tuner to test. Is a PLP_ID required in the scan file
as in the UK we only have one?

I presume the System_ID has been included in the Crystal Palace file
because it was known by w_scan, but is it required for T2?

Thanks,

Simon.
