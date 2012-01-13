Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42173 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab2AMLEU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 06:04:20 -0500
Received: by werb13 with SMTP id b13so277723wer.19
        for <linux-media@vger.kernel.org>; Fri, 13 Jan 2012 03:04:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANbcZdNK5v5i=a13sEE216-HjEnXXciWCe_jc139N3MVnKP5oA@mail.gmail.com>
References: <CANbcZdNK5v5i=a13sEE216-HjEnXXciWCe_jc139N3MVnKP5oA@mail.gmail.com>
From: "Elestedt, Fredrik" <fredrik@elestedt.com>
Date: Fri, 13 Jan 2012 12:03:58 +0100
Message-ID: <CACG8oOqdkk-ymzW6Uk1ypHEzPvHZBM_wiUjw53P4+Q5S7F=+bw@mail.gmail.com>
Subject: Re: Problem with WinTV HVR-930C
To: Daniel Rindt <daniel.rindt@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel,

Didn't work for me either - had to use repository. Same kernel base
version, but on gentoo though.

// Fredrik

On Thu, Jan 12, 2012 at 19:02, Daniel Rindt <daniel.rindt@googlemail.com> wrote:
> Hello,
>
> i am running Fedora 16 64bit and have no luck to get working the WinTV
> HVR-930C. Invoked command lsusb told me: Bus 001 Device 002: ID
> 2040:1605 Hauppauge. Installed from update-testing-repository is the
> most recent kernel version kernel-3.1.8-2.fc16.x86_64.
>
> Loaded the em28xx by hand and shows up this in dmesg:
> [  482.220534] IR NEC protocol handler initialized
> [  482.228352] IR RC5(x) protocol handler initialized
> [  482.229710] Linux media interface: v0.10
> [  482.235907] Linux video capture interface: v2.00
> [  482.240601] IR RC6 protocol handler initialized
> [  482.257921] IR JVC protocol handler initialized
> [  482.263175] IR Sony protocol handler initialized
> [  482.268460] IR MCE Keyboard/mouse protocol handler initialized
> [  482.273807] usbcore: registered new interface driver em28xx
> [  482.273816] em28xx driver loaded
> [  482.275215] lirc_dev: IR Remote Control driver registered, major 249
> [  482.285327] IR LIRC bridge handler initialized
>
> I am in doubt that the newest development is included in this kernel
> release. Or maybe i have do something wrong. Your help is much
> appreciated.
>
> Thanks
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
