Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44736 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2JMOZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Oct 2012 10:25:26 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so6039329iea.19
        for <linux-media@vger.kernel.org>; Sat, 13 Oct 2012 07:25:26 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 14 Oct 2012 00:25:26 +1000
Message-ID: <CAG5Tc=Wk5GV0dSNtFAuD1ffjmCZ02rfM_fk9iuhJUhN1QTXpkw@mail.gmail.com>
Subject: Sony PlayTV: tuning on second tuner causing reception issues on first tuner
From: Torgeir Veimo <torgeir.veimo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When background EIT scanning is enabled on my VDR setup, I am getting signal
disruption about every 20-21 seconds, with my sony playtv USB dual DVB-T tuner.

This seems to be caused by the second tuner retuning in the
background. I've heard that the nova-t 500 cards can have issues with
disruption when the second tuner on a card is tuning. Is this the same
type of problem?

Are there any other dual USB tuners that doesn't have problems with
tuning on second tuner causing reception issues on the first tuner?

-- 
-Tor
