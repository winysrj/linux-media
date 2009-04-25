Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:48347 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZDYOwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2009 10:52:19 -0400
Received: by bwz7 with SMTP id 7so1539312bwz.37
        for <linux-media@vger.kernel.org>; Sat, 25 Apr 2009 07:52:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0904250621m7f43735eu730fac87bd121b57@mail.gmail.com>
References: <49F2DCBD.20105@freenet.de>
	 <412bdbff0904250621m7f43735eu730fac87bd121b57@mail.gmail.com>
Date: Sat, 25 Apr 2009 22:52:17 +0800
Message-ID: <d9def9db0904250752yb16170w680e8cd78354cc76@mail.gmail.com>
Subject: Re: Installation of Cinergy HTC USB Driver in Ubuntu Jaunty
From: Markus Rechberger <mrechberger@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Peter Hoyland <Peter.Hoyland@t-online.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 25, 2009 at 9:21 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Sat, Apr 25, 2009 at 5:49 AM, Peter Hoyland
> <Peter.Hoyland@t-online.de> wrote:
>> Hallo
>>
>> I have a Terratec Cinergy HTC USB XS Stick and want to use this with
>> Me-TV in order to record and view TV via Cable (Germany).
>>
>> My research shows that a driver is in development under this link
>> http://mcentral.de/wiki/index.php5?title=Terratec_HTC_XS&oldid=2804.
>>
>> This link offers no instructions to installation, I was hoping that it
>> would be included In Ubuntu Jaunty, alas to no avail. I am hoping that
>> you can help me further or at least tell me in which Kernel release this
>> driver will be integrated.
>>
>> Thanks in advance
>> Peter Hoyland
>
> This device is supported in Markus's closed source driver only.  It
> will not be merged into the mainline kernel, and there are no plans at
> this time for anyone else to reverse engineer the Micronas demod and
> write an open source driver.
>
> My advice: return it and buy something supported.
>
> Micronas actively screwed the Linux community when they had me do all
> the integration work for their device and then refused to let me
> release it.  I wouldn't buy any of their products if you care about
> open source.
>

There is no code to merge for the mainline kernel this is why it will
not be merged actually. The driver is userland based and works with
LD_PRELOAD right infront of the existing em28xx driver, the patched
one is just required in order to support VBI. It can be seen as
firmware from userland.
This is a new framework providing the v4l and dvb configuration
framework from userland and provides support from tested 2.6.10+
(possibly earlier ones already)

There's no need for Micronas nor Trident to provide such kerneldrivers
as long as the userland driver is available. It's also much easier to
install than the earlier versions.

regards,
Markus
