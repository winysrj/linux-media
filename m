Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:48245 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbbGFGQb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jul 2015 02:16:31 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: Subjective maturity of tw6869, cx25821, bluecherry/softlogic drivers
References: <1435871672466752997@telcodata.us> <m3vbe1plhk.fsf@t19.piap.pl>
	<CAM_ZknXDnXdh-UVjnxdui0DJyo8PJgj9Bsh_yZ7Z-BRzj8__qA@mail.gmail.com>
Date: Mon, 06 Jul 2015 08:16:30 +0200
In-Reply-To: <CAM_ZknXDnXdh-UVjnxdui0DJyo8PJgj9Bsh_yZ7Z-BRzj8__qA@mail.gmail.com>
	(Andrey Utkin's message of "Sun, 5 Jul 2015 19:54:30 +0300")
Message-ID: <m3y4itoloh.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey Utkin <andrey.utkin@corp.bluecherry.net> writes:

>> Also, TW686x are (mini) PCIe while SOLO6110 (and earlier SOLO6010 which
>> produces MPEG4 part 2 instead of H.264) are (mini) PCI.
>
> solo6110 is PCI-E, not PCI.

No, it's not, both SOLO6010 and SOLO6110 are 32-bit PCI.

SOLO6110 Data Sheet
1.2.5. PCI/HOST Interface
     - PCI Local Bus Specification, Rev. 2.2. 32bit/33MHz(66MHz)
     - PCI Master/Target Mode.
     - 32bit CPU Host Interface

There are probably PCIe cards using SOLO6110, but they have to use
a PCIe-PCI bridge.

One can also use a SOLO6x10 card with a separate converter board.
We're using converters with PLX PEX8112 bridge chip for this.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
