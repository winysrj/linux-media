Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp9.rug.nl ([129.125.60.9]:35109 "EHLO smtp9.rug.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZKQLGp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 06:06:45 -0500
Received: from [129.125.21.104] (f5selfip-4-60.service.rug.nl [129.125.60.248])
	by smtp9.rug.nl (8.14.3/8.14.3) with ESMTP id nAHB6oXq019338
	for <linux-media@vger.kernel.org>; Tue, 17 Nov 2009 12:06:50 +0100
Message-ID: <4B0283CA.5060408@rug.nl>
Date: Tue, 17 Nov 2009 12:06:50 +0100
From: Sietse Achterop <s.achterop@rug.nl>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: xawtv and v4lctl with usbvision kernel driver
References: <4B016937.7010906@rug.nl> <829197380911160752lcbfd202gcdbed97b85238bd2@mail.gmail.com>
In-Reply-To: <829197380911160752lcbfd202gcdbed97b85238bd2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Mon, Nov 16, 2009 at 10:01 AM, Sietse Achterop <s.achterop@rug.nl> wrote:

>> Context:
>>  debian/lenny with usb frame grabber:
>>     Zoran Co. Personal Media Division (Nogatech) Hauppauge WinTV Pro (PAL/SECAM)
>>  This uses the usbvision driver.
>>
>> The problem is that while xawtv works OK with color, v4lctl ONLY shows the frames
>> in black-and-white.

> I don't know about that board in particular, but on some boards the
> composite and s-video are actually wired together (sharing the luma
> line), so if you have the device configured in "composite" mode but
> have the s-video plugged in, then you will get a black/white image
> (since it expects to see both luma/chroma on the one pin that provides
> luma).
  Hi Devin,
     Thanks for your reponse, but xawtv happely shows color, so I don't think
thats the issue,
 Thanks again,
    Sietse
