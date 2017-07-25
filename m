Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34216 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752444AbdGYPmb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 11:42:31 -0400
Received: by mail-wm0-f65.google.com with SMTP id c184so4220005wmd.1
        for <linux-media@vger.kernel.org>; Tue, 25 Jul 2017 08:42:30 -0700 (PDT)
Date: Tue, 25 Jul 2017 17:42:27 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Philipp Hahn <pmhahn+video@pmhahn.de>, linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: Re: [PATCH RESEND 00/14] ddbridge: bump to ddbridge-0.9.29
Message-ID: <20170725174227.325ecfb7@audiostation.wuest.de>
In-Reply-To: <57b893dc-d54f-0293-1874-b3606bb811c1@pmhahn.de>
References: <20170723181630.19526-1-d.scheller.oss@gmail.com>
        <57b893dc-d54f-0293-1874-b3606bb811c1@pmhahn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Tue, 25 Jul 2017 07:36:12 +0200
schrieb Philipp Hahn <pmhahn+video@pmhahn.de>:

> > Stripped functionality compared to dddvb:
> > 
> >  - DVB-C modulator card support removed (requires DVB core API)  
> 
> Since I'm in DVB-C land, what is required to get that working as well?
> I only know myself around in general Linux Kernel land and I'm not a
> DVB expert, but if there is anything I can help with, please send me
> a note. (I only have one ddbridge system, which is running my
> "production" MythTV system, so testing is limited to the times were
> my house does not need it).

When speaking of MythTV and "regular" tuner cards, there's nothing you
need to do in this regard, DVB-C/C2/T/T2 tunercard support for all
currently available DD hardware is done already and merged into
linux-media. With modulator cards, these ([1]) are meant, used to set
up private cable networks, fed by ie. streams received via DVB-S.

[1] https://digitaldevices.de/produkte/modulatoren/

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
