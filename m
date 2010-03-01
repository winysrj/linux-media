Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:47658 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab0CAA5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 19:57:30 -0500
Received: by fxm19 with SMTP id 19so266832fxm.21
        for <linux-media@vger.kernel.org>; Sun, 28 Feb 2010 16:57:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8AF722.8000105@helmutauer.de>
References: <4B8AF722.8000105@helmutauer.de>
Date: Mon, 1 Mar 2010 04:57:29 +0400
Message-ID: <1a297b361002281657t5727e11vb7d121744d81da22@mail.gmail.com>
Subject: Re: Mantis not in modules.pcimap
From: Manu Abraham <abraham.manu@gmail.com>
To: Helmut Auer <vdr@helmutauer.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 1, 2010 at 3:07 AM, Helmut Auer <vdr@helmutauer.de> wrote:
> Hello,
>
> The mantis module is build and working fine with the Skystar2 HD, but it I cannot autodetect it,
> because modules.pcimap is not filled with the vendor id of the card using this module.
> What's to do  to get these ID's ?
> In my case its a:
>
> 01:08.0 0480: 1822:4e35 (rev 01)
>        Subsystem: 1ae4:0003
>        Flags: bus master, medium devsel, latency 32, IRQ 16
>        Memory at fddff000 (32-bit, prefetchable) [size=4K]
>


You can use this fix. http://jusst.de/hg/mantis-v4l-dvb/rev/6f3e1db2432a

Regards,
Manu
