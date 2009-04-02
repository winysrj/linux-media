Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:1801 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbZDBKJd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 06:09:33 -0400
Received: by rv-out-0506.google.com with SMTP id f9so548892rvb.1
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 03:09:31 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 18:09:31 +0800
Message-ID: <15ed362e0904020309k4b286690u6d4d421e321cd91e@mail.gmail.com>
Subject: API for China DTV standard
From: David Wong <davidtlwong@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I would like to initiate a discussion of v4l-dvb API proposal for China DTV.

Some of you may heard about China DTV standard as DMB-T/H, it is not
totally correctly.
China standard GB20600-2006 is indeed a union of DMB-TH(multi-carrier)
and ADTB-T(single carrier).

For API inclusion, I just read the standard document for GB20600. I am
not very good in that electronics area,
but I gather the following information of parameters, hope I don't
miss anything:

Number of Carriers:  C=1, C=3780
Constellations: 4QAM, 4QAM-NR, 16QAM, 32QAM, 64QAM
FEC(LDPC): rate = 0.4,  rate = 0.6, rate = 0.8
Frame body size: always 3780 symbols
Frame header size:  420 symbols (1/10 guard interval), 595 symbols
(0.136 guard interval), 945 symbols (1/5 guard interval)
Time domain symbol interleave: M=240(B=52), M=720(B=52)

Despite "C=1" and "interleave", I don't know if DVB has such
interleave, I see a chance to extend the current FE_OFDM structure (in
dvb_frontend_parameters).
Or should we create a new structure, like the separation of FE_ATSC
and FE_OFDM?

Cheers,
David
