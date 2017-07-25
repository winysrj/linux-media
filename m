Return-path: <linux-media-owner@vger.kernel.org>
Received: from parrot.pmhahn.de ([88.198.50.102]:60842 "EHLO parrot.pmhahn.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbdGYGRe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 02:17:34 -0400
Subject: Re: [PATCH RESEND 00/14] ddbridge: bump to ddbridge-0.9.29
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org
References: <20170723181630.19526-1-d.scheller.oss@gmail.com>
Cc: rjkm@metzlerbros.de
From: Philipp Hahn <pmhahn+video@pmhahn.de>
Message-ID: <57b893dc-d54f-0293-1874-b3606bb811c1@pmhahn.de>
Date: Tue, 25 Jul 2017 07:36:12 +0200
MIME-Version: 1.0
In-Reply-To: <20170723181630.19526-1-d.scheller.oss@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

first of all "thank you" for doing this - I have a ddbridge myself
currently using the driver from Ralf, which luckily works for me, but
having them "in tree" is very much appreciated.

Am 23.07.2017 um 20:16 schrieb Daniel Scheller:
> While the driver code bump looks massive, judging from the diff, there's
> mostly a whole lot of refactoring and restructuring of variables, port/
> link management and all such stuff in it. Feature-wise, this is most
> notable:
> 
>  - Support for all (PCIe) CI (single/duo) cards and Flex addons
>  - Support for MSI (Message Signaled Interrupts), though disabled by
>    default since there were still reports of problems with this
>  - TS Loopback support (set up ports to behave as if a CI is connected,
>    without decryption of course)
>  - As mentioned: Heavy code reordering, and split up into multiple files
> 
> Stripped functionality compared to dddvb:
> 
>  - DVB-C modulator card support removed (requires DVB core API)

Since I'm in DVB-C land, what is required to get that working as well?
I only know myself around in general Linux Kernel land and I'm not a DVB
expert, but if there is anything I can help with, please send me a note.
(I only have one ddbridge system, which is running my "production"
MythTV system, so testing is limited to the times were my house does not
need it).

Philipp
