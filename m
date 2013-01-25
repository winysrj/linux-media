Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:49123 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3AYIxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 03:53:15 -0500
Received: by mail-ia0-f171.google.com with SMTP id z13so218147iaz.30
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 00:53:15 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 25 Jan 2013 09:53:14 +0100
Message-ID: <CAJvg3VH6twjoFc6MkULTZoESCYnTz=s9cFDSNrLiR_7ea45o1A@mail.gmail.com>
Subject: ACM/VCM, PLS
From: Thierry Perdichizzi <thierry@perdichizzi.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'd like to make a request for the support of the PLS and ACM/VCM for
DVB-S2. Currently some channels use these options.

PLS
Physical Layer Scrambling or PLS is used in DVB-S2 as a way to improve
data integrity. A number called the "scrambling sequence index" is
used by the modulator as a master key to generate the uplink signal.
This same number must be known by the receiver so that demodulation is
possible.

ACM/VCM
Variable Coding and Modulation (VCM) and Adaptive Coding and
Modulation (ACM) are techniques that are strongly associated with the
DVB-S2 standard. VCM can be used to provide different levels of error
protection to different components within the service. It does this by
allowing different combinations of modulation and FEC rate to be
applied to different parts of the data stream. ACM extends VCM by
providing a feedback path from the receiver to the transmitter to
allow the level of error protection to be varied dynamically in
accordance with varying propagation conditions. Claims of performance
improvements exceeding 100% have been made for ACM in terms of
satellite capacity gain.

Sample
Eutelsat 5 West A 	11179.00	V	KC6	Super	DVB-S2  PLS: Root+16416	 8PSK
ACM/VCM Stream 4

is that the next version next version will support ? if yes, is that
you could give me a date for each modules ?

Thanks,
T
