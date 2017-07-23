Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:41933 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751395AbdGWPXA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 11:23:00 -0400
Subject: Re: [PATCH 0/7] stv0910/stv6111 updates
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz
References: <20170723101315.12523-1-d.scheller.oss@gmail.com>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <c7db7be4-02c6-3bf8-72ba-c6e99aa1872d@anw.at>
Date: Sun, 23 Jul 2017 17:22:44 +0200
MIME-Version: 1.0
In-Reply-To: <20170723101315.12523-1-d.scheller.oss@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I tested this patch series with:
  DD Cine S2 V6
  DD Duoflex CI (single)
  DD Duoflex S2 V4 (stv0910/stv6111)
  VDR 2.3.8, ddci2 Plugin 1.5.0

The SAT cables were connected to the DD DuoFlex S2 V4 card and VDR was
instructed to use this device only.
I checked the signal values with VDR and dvb-fe-tool and both showed the
same values than before (without the patches).
I did a recording of ORF I (Austrian TV) and was also watching ZDF (German TV)
simultaneously. All worked as expected!

With this eMail I add my
  Tested-by: Jasmin Jessich <jasmin@anw.at>
for this series.

BR,
   Jasmin
