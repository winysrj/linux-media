Return-path: <linux-media-owner@vger.kernel.org>
Received: from hypatia.vm.bytemark.co.uk ([212.110.187.115]:41112 "EHLO
	technomancy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab1KLP6A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:58:00 -0500
Message-ID: <4EBE9785.2010808@technomancy.org>
Date: Sat, 12 Nov 2011 15:57:57 +0000
From: Rory McCann <rory@technomancy.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Patrick Dickey <pdickeybeta@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: Any update on the Hauppauge WinTV-HVR-900H?
References: <4EBE73F4.4080002@technomancy.org> <4EBE8018.6010005@gmail.com> <CAGoCfiz6nfS4ADRmaZxq-qFFbKqcxH980g=LptYZGvZ+zcbX5Q@mail.gmail.com>
In-Reply-To: <CAGoCfiz6nfS4ADRmaZxq-qFFbKqcxH980g=LptYZGvZ+zcbX5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/11/11 14:39, Devin Heitmueller wrote:
> If it's B138 then it's the newer revision of the 900H and it's actually
> never been supported.  The issue is the device has a demod for which no
> driver currently exists (si216x)

Yes I have the 2040:b138

When I plug it in, dmesg just shows:

[325765.514364] usb 2-1.2: new high speed USB device number 12 using 
ehci_hcd

However after talking to Mikachu on #linuxtv on IRC today, it occured to 
me that I only want this for analog, not digital. I only want to 
digitize some old VHSs, so I don't need digital.

Upon Mikachu's suggestion, I'm going to try this patch¹ and see if 
analog works.

¹ http://www.mail-archive.com/linux-media@vger.kernel.org/msg30116.html
