Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36815 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbbGTMiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 08:38:23 -0400
Received: by qkdv3 with SMTP id v3so110703891qkd.3
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 05:38:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1454427BAA91444C85615ABB9382A2DE@wincomm.com.tw>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
	<1454427BAA91444C85615ABB9382A2DE@wincomm.com.tw>
Date: Mon, 20 Jul 2015 08:38:22 -0400
Message-ID: <CALzAhNX-NYGnhBMVwohZcir0oZ1a3BW9zP7xNdcYaSfpQPZRmA@mail.gmail.com>
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants -
 testers reqd.
From: Steven Toth <stoth@kernellabs.com>
To: tonyc@wincomm.com.tw
Cc: Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>,
	Jerry Chen <jerry_chen@hauppauge.com.tw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 20, 2015 at 2:00 AM, Tony Chang(Wincomm)
<tonyc@wincomm.com.tw> wrote:
> Dear : Steven
>
> Sorry for my poor english !! I don’t know how to install it
>
> According your feedback..
>
> diff --git a/drivers/media/pci/cx23885/Kconfig
> b/drivers/media/pci/cx23885/Kconfigindex 2e1b88c..3e6398f 100644
>
> I don't how to use diff -- because can't see any drivers/media/....
>
> Please reference attached picture
>
> Is kernel not support ?
>
> Best Regards

Tony / Jerry,

You need to download the entire tree, based on branch hvr-1275, commit
#91bd0a5bbbc3759bb3fd6516d8c322b030620b46, compile and install the
entire kernel (which is a 4.2 rc).

Its available for download from here: >
http://git.linuxtv.org/cgit.cgi/stoth/hvr1275.git/log/?h=hvr-1275

After that it should be fine.

The pictures you have show we're using the same hardware, but you're
not running the newer kernel (including the new patches).

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
