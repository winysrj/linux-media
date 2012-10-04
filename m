Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46936 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2JDSiG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 14:38:06 -0400
Received: by mail-vc0-f174.google.com with SMTP id fo13so958943vcb.19
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2012 11:38:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349374975-5934-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1349374975-5934-1-git-send-email-martin.blumenstingl@googlemail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 4 Oct 2012 20:37:45 +0200
Message-ID: <CAFBinCBpr_cL1ofQp09e6DTDnNvOh_1eXErHpNniMf1creZk0A@mail.gmail.com>
Subject: Re: [PATCH 1/2] em28xx: Better support for the Terratec Cinergy HTC
 USB XS. This intializes the card just like the windows driver does.
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I forgot to add some clarification:
- the "HTC USB XS HD" uses the same firmware as the "HTC Stick HD".
- both have different GPIO and reg init sequences
- I tested my changes only with DVB-C, but I guess DVB-T will work
fine (unfortunately
  I can't test that, but it was working fine on the "HTC Stick HD"
back when I tested it).
  I tested with and without firmware - it was working fine in both cases.
- the remote control should work fine now (also untested)

Regards,
Martin
