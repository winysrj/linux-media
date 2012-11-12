Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58856 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2KLNEs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 08:04:48 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so3334170eek.19
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2012 05:04:47 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 12 Nov 2012 13:04:45 +0000
Message-ID: <CAE-UT2ug=U4AJghXfXZBuBoa18JsPSjNsvHUEu9FHZvAm1qi1Q@mail.gmail.com>
Subject: DVB V5 API: Event Model
From: Martin Rudge <martin.rudge@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello All,

When using the V5 API (DVB-S/S2) for the DVB frontend device (with the
now merged SEC functionality), setting properties DTV_VOLTAGE and/or
DTV_TONE generates extra (unwanted?) events.  This is due to utilising
the legacy FE_SET_FRONTEND IOCTL in their respective implementations.

Depending on their placement in one "atomic" FE_SET_PROPERTY call,
they can cause an "incorrect" (premature) SYNC/LOCK event to be
generated.  For example, when looping issuing tune requests in
succession during a scan operation. This was with a fairly recent
media build (pulled Saturday).

Conversly using DTV_CLEAR clears the cached values, but doesn't affect
the frontend (LNB).  This is probably desirable behaviour.

Any thoughts, working as designed/intended?

Thanks
Martin
