Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:43418 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbbBSNWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 08:22:44 -0500
Received: by yhab6 with SMTP id b6so14510yha.10
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2015 05:22:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54E560C3.20308@dharty.com>
References: <14641294.293916.1422889477503.JavaMail.defaultUser@defaultHost>
	<1842309.294410.1422891194529.JavaMail.defaultUser@defaultHost>
	<CALzAhNXPne4_0vs80Y26Yia8=jYh8EqA0phJm31UzATdAvPvDg@mail.gmail.com>
	<8039614.312436.1422971964080.JavaMail.defaultUser@defaultHost>
	<54DD3986.3010707@dharty.com>
	<54E2BC31.7000809@dharty.com>
	<004501d04aaf$e9fe6540$bdfb2fc0$@net>
	<54E560C3.20308@dharty.com>
Date: Thu, 19 Feb 2015 08:22:43 -0500
Message-ID: <CALzAhNWC1LV6+yNyasNZ0FJCDmyE3w-YRA9VwtXGCwVaPp7HDg@mail.gmail.com>
Subject: Re: [BUG, workaround] HVR-2200/saa7164 problem with C7 power state
From: Steven Toth <stoth@kernellabs.com>
To: v4l@dharty.com
Cc: dCrypt <dcrypt@telefonica.net>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 18, 2015 at 11:04 PM, David Harty <dwh@dharty.com> wrote:
> On 02/17/2015 04:47 AM, dCrypt wrote:
>>
>> So the PCI Express change hasn't seemed to help either. Any other ideas?
>> David --
>
>
> My system stops working at least once a day.  Does anyone have any
> suggestions to try? latest module builds? other firmwares?  I notice there
> are several up on the http://www.steventoth.net/linux/hvr22xx/ site, would
> any of those work better?
>
> Is there a better card to use?  the HVR-2200 and saa7164 are effectively
> unusable at this point.

I'm planning to release an updated saa7164 driver shortly, with
support for the HVR2205 and the HVR2255. Additionally, it contains a
fix (which for some people) has significantly reduced the I2C Timeout
related errors. (Technically the risc processor crashes on the card,
leading to all firmware commands timing out).

I'll post a notice to this list once the driver is ready for download.
Shortly, I hope.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
