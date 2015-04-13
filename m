Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35333 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbbDMGcS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 02:32:18 -0400
Received: by widdi4 with SMTP id di4so59435426wid.0
        for <linux-media@vger.kernel.org>; Sun, 12 Apr 2015 23:32:16 -0700 (PDT)
Received: from jemma-pc.denson.org.uk ([2001:470:6ad2:1:beae:c5ff:fe8c:e4a7])
        by mx.google.com with ESMTPSA id it5sm11270233wid.3.2015.04.12.23.32.15
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Apr 2015 23:32:16 -0700 (PDT)
Message-ID: <552B62EF.8050705@gmail.com>
Date: Mon, 13 Apr 2015 07:32:15 +0100
From: Jemma Denson <jdenson@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for TechniSat Skystar S2
References: <201504122132.t3CLW6fQ018555@jemma-pc.denson.org.uk>
In-Reply-To: <201504122132.t3CLW6fQ018555@jemma-pc.denson.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oh, I was doing this the wrong way then. I did have some preamble to
this but it seems to have been stripped.

Anyway, this patch adds support for the Technisat Skystar S2 - this
has been tried before but the cx24120 driver was a bit out of shape
and it didn't got any further:
https://patchwork.linuxtv.org/patch/10575/

It is an old card, but currently being sold off for next to nothing,
so it's proving quite popular of late.
Noticing it's quite similar to the cx24116 and cx24117 I've rewritten
the driver in a similar way. There were a few registers and commands
from those drivers missing from this one I've tested out and found
they do something so they've been added in to speed up tuning and to
make get_frontend return something useful.

I've only got access to 28.2E, but everything I've tried seems to work
OK, on both the v3 and v5 APIs. Assuming I've read the APIs and some
of the modern drivers OK it should be doing things in the reasonably
modern way, but if anything else needs doing let me know.
