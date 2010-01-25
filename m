Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50934 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0AYUWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 15:22:03 -0500
Received: by fxm20 with SMTP id 20so3988145fxm.21
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 12:22:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B588FDE.3090203@googlemail.com>
References: <4B578073.4030103@googlemail.com> <4B588FDE.3090203@googlemail.com>
Date: Mon, 25 Jan 2010 21:22:00 +0100
Message-ID: <bcb3ef431001251222x364c5d6fvd8d07498353ed518@mail.gmail.com>
Subject: Re: Remote for Terratec Cinergy C PCI HD (DVB-C)
From: MartinG <gronslet@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 21, 2010 at 6:33 PM, Hans-Peter Wolf
<hapewolf@googlemail.com> wrote:
> Hi,
>
> I got it finally running! I just took the last s2-liplianin source and it
> was detected automatically:
>
> I: Bus=0001 Vendor=0000 Product=0000 Version=0001
> N: Name="Mantis VP-2040 IR Receiver"
> P: Phys=pci-0000:01:06.0/ir0
> S: Sysfs=/devices/virtual/input/input5
> U: Uniq=
> H: Handlers=kbd event5
> B: EV=100003
> B: KEY=108fc330 284204100000000 0 2000000018000 218040000801 9e96c000000000
> ffc
>
> Strange, that it didn't work with v4l-dvb sources.
>
> Thank you very much. I really appreciate your work!


Hi, I've got the exact same device as you, use the s2-liplianin
driver, and after reading your post I tried the remote as well.
But how do I configure it? Some of the keys are working (arrow keys,
numeric keys, Home, volume, mute), but not all.
Is the remote handled as an input device by X itself? So what file(s)
do I need to change/update?

If you have some working config files, or a nice link, I'd appreciate it :)

Best,
MartinG
