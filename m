Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:53858 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3AaO1d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 09:27:33 -0500
Received: by mail-oa0-f51.google.com with SMTP id h2so882373oag.24
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 06:27:33 -0800 (PST)
MIME-Version: 1.0
From: Michael Stilmant-Rovi <stilmant.michael.rovi@gmail.com>
Date: Thu, 31 Jan 2013 15:27:09 +0100
Message-ID: <CABXgeUHzMhk7rCtpoVuEz1zUYuGwUMEmxrFMKripnO8qvNX+Sg@mail.gmail.com>
Subject: DVB_T2 Multistream support (PLP)
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I would like to know the support status of Multiple PLPs in DVB-T2.
Is someone know if tests were performed in a broadcast with an
effective Multistream? (PLP Id: 0 and 1 for example)

I'm out of range of such multiplex but I'm trying some tunes on London
DVB-T2 (CrystalPalace tower)
"unfortunately" that mux seems Single PLP and everything work well :-(
  ( yes tune always succeed :-D )

I'm using DVB API 5.6.
If I tune with FE_SET_PROPERTY without or with DTV_DVBT2_PLP_ID set to
0, 1 or 15. the tune succeed.

I'm not sure of the expected behavior, I was expecting if I tune with
plp_id 1 that the tuner would fail somewhere finding that stream.

So in short I don't understand what is the requirements to be able to
use the DVB_T2 Multistream support proposed in APIs:
 o I see that the DVB API 5.8(?) had some patch at that level and so
it is maybe requested?
 o How can I know if my driver support that feature on DVB API 5.6?
(PCTV nanoStick T2 290e)?

Thank you for all indications.

-Michael
