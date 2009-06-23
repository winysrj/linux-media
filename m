Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:48231 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZFWCCM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 22:02:12 -0400
Received: by ewy6 with SMTP id 6so5193401ewy.37
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 19:02:13 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Jun 2009 03:02:13 +0100
Message-ID: <a413d4880906221902u6ea088abk6cecfabd0f814051@mail.gmail.com>
Subject: SAA7133 failure under Kernel 2.6.29
From: Another Sillyname <anothersname@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I noted from a discussion in the list back in April there were
problems with SAA7133 devices under 2.6.29 Kernel.

I have such a device and just upgraded to Fed 11 yesterday, device now
fails.  Under Fed 10 no problems.

I'm happy to provide dmesg and lspci and whatever else you need,
however don't want to clutter the list with data that may not be
needed.

The device in question is a 5168:3307 Lifeview Hybrid and I'm getting
the "IRQF_Disabled" error previously described.

Any ideas chaps?

Thanks in Advance
