Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:40470 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1165219AbdEAMir (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 08:38:47 -0400
Date: Mon, 1 May 2017 14:38:44 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] rc-core: export the hardware type to sysfs
Message-ID: <20170501123844.bmrstofc7q3ryoas@hardeman.nu>
References: <149346020957.4157.4374621534433639100.stgit@zeus.hardeman.nu>
 <20170501103613.GA10867@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170501103613.GA10867@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 01, 2017 at 11:36:13AM +0100, Sean Young wrote:
>On Sat, Apr 29, 2017 at 12:03:29PM +0200, David Härdeman wrote:
>> Exporting the hardware type makes it possible for userspace applications
>> to know what to expect from the hardware.
>> 
>> This makes it possible to write more user-friendly userspace apps.
>
>This duplicates lirc features (LIRC_GET_FEATURES ioctl); the one exception
>is that the scancode-only devices which have no lirc device, but there
>are patches which change that.

The intention was to let userspace have a way of knowing whether to
expect any lirc device to show up at all. If some class of devices can't
have lirc devices (looking at the patch you linked to that'd still be
CEC?) then I think it's still useful?

-- 
David Härdeman
