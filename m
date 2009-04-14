Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:36141 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZDNMwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 08:52:40 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2642491yxl.1
        for <linux-media@vger.kernel.org>; Tue, 14 Apr 2009 05:52:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E40322.5040600@orthfamily.net>
References: <49E40322.5040600@orthfamily.net>
Date: Tue, 14 Apr 2009 08:52:38 -0400
Message-ID: <412bdbff0904140552m52c0106q960f7c0ee40757c@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle HD Stick (801e SE) and i2c issues
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 13, 2009 at 11:29 PM, John Orth <john@orthfamily.net> wrote:
> First, thanks to all for the wonderful v4l project.  I am able to get
> this card going in Ubuntu 9.04 on my laptop (Dell Vostro 1700) with no
> changes apart from copying the correct firmware.  What fantastic
> progress. :)
>
> I have been trying very hard to get this USB tuner to work on my Asus
> M3A78-EM board in Ubuntu 9.04 with no success.  I have tried the stock
> Jaunty kernel, the mainline (vanilla?) kernel, the included kernel
> modules, and modules compiled from v4l Mercurial with no success.
> Generally speaking, after a cold boot, the stick will work for a while.
> It will scan channels, lock one or two, and then I will receive a filter
> timeout.  Once the filter has timed out, not even a cold boot will
> revive the stick.  I have to power down the system, remove the stick,
> and place it in a different USB port.  Once I have done this, I am able
> to filter/lock with varying degrees of success.  Sometimes it will allow
> me to generate a full channels.conf, sometimes not.  However, once
> hitting the "filter timeout" error, dmesg gets flooded with:
>
> ---
> s5h1411_writereg: writereg error 0x19 0xf5 0x0000, ret == 0)
> dib0700: i2c write error (status = -108)
> ---
>
> The filter timeout occurs after running "scan tuning.dat > channels.conf"
> The file tuning.dat is generated via "w_scan -fa -x > tuning.dat"
>
> The firmware dvb-fe-xc5000-1.1.fw was copied to /lib/firmware per the
> v4l Wiki instructions.
>
> lspci of working system:  http://pastebin.com/f31efd30a
> lspci of non-working system:  http://pastebin.com/fa80c2f7
>
> Is there something major I'm overlooking?  Are there any known issues
> with this hardware combination?  I am willing to test any changes to the
> xc5000 driver if needed.
>
> Thanks!
> John

Hello John,

I added support for that device.  A couple of questions:

1.  Are you sure the port on the PC supports USB 2.0?

2.  Which application are you using to test with?

3.  Are you doing anything with suspend/resume on the PC?

4.  Are you plugged directly into the USB port, or are you using any
sort of USB extension cable?

Once I know the answers to the above questions, I will see what I can
figure out.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
