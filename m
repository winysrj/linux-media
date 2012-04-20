Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53649 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2DTMg2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 08:36:28 -0400
Received: by vcqp1 with SMTP id p1so6318973vcq.19
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2012 05:36:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAMvbhFWno9ibo4Db9Xpdzwsv7+70evR8-ZydYc4RNQtPAD3-Q@mail.gmail.com>
References: <CAAMvbhFWno9ibo4Db9Xpdzwsv7+70evR8-ZydYc4RNQtPAD3-Q@mail.gmail.com>
Date: Fri, 20 Apr 2012 08:36:27 -0400
Message-ID: <CAGoCfiwrOaTRZCRXD7d3cSRVCEnBS7aHQE4O53ynf6MsZ=cf7g@mail.gmail.com>
Subject: Re: CX23885 MSI
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2012 at 7:34 AM, James Courtier-Dutton
<james.dutton@gmail.com> wrote:
> Hi,
>
> I noticed that the CX23885 driver does not set it up to use MSI.
> I don't have the datasheets. Is there any know reason not to use MSI
> with this PCI Express card?
> I just want to know before I spend time enabling MSI for this device.
> It is my understanding that MSI is generally preferred over previous
> IRQ methods.

It was disabled intentionally by Andy due to a compatibility problem.
Search the ML archives for the following subject for more details:

"HVR-1250/CX23885 IR Rx"

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
