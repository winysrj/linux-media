Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:57670 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab3LPUUL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 15:20:11 -0500
Message-ID: <52AF6075.7030202@gentoo.org>
Date: Mon, 16 Dec 2013 21:20:05 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: =?UTF-8?B?U3ZlbiBNw7xsbGVy?= <xpert-reactos@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: Aw: Re: Card with si2165
References: <trinity-3c856476-f7bf-4d9b-b00d-707bcf956c5b-1387066356197@3capp-gmx-bs46>, <52AE1020.9020908@gentoo.org> <trinity-3abf9a2f-d1ae-4948-b124-7d2aa566b28c-1387182406449@3capp-gmx-bs08>
In-Reply-To: <trinity-3abf9a2f-d1ae-4948-b124-7d2aa566b28c-1387182406449@3capp-gmx-bs08>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16.12.2013 09:26, "Sven Müller" wrote:
> 
> I have a Hauppauge WINTV HVR 5500-HD.
> 

Hi

I think first you should check if this is exactly the same card as you
have: http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-5500

Then either update this page or create a new one for your card.
Please also add pictures from front/back of your card.

As far as I understand the HVR 5500-HD is not yet supported in any way.
Best you follow this page in the wiki:
http://linuxtv.org/wiki/index.php/Development:_How_to_add_support_for_a_device

Maybe it is enough to use the cx2388x driver and do an i2c scan to find
out about the addresses of the components combined with chip names.

But most likely at least some values need to be compared to windows.
I have not yet tried sniffing PCI-traffic, but there is some work to
pass pci traffic between qemu and real pci cards.

Regards
Matthias

