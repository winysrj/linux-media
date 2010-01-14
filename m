Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:43460 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0ANKGE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 05:06:04 -0500
Received: by fxm25 with SMTP id 25so300532fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 02:06:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1a297b361001140144s3518ed59o14b0784de9fd828@mail.gmail.com>
References: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
	 <1a297b361001140115l3dc56802r985b0fd9f8f83c16@mail.gmail.com>
	 <3a11f97d6e44a5cd64c4378c51706ff4.squirrel@webmail.xs4all.nl>
	 <1a297b361001140144s3518ed59o14b0784de9fd828@mail.gmail.com>
Date: Thu, 14 Jan 2010 11:06:02 +0100
Message-ID: <846899811001140206h6c903418rfdd80f23d26a3bee@mail.gmail.com>
Subject: Re: About driver architecture
From: HoP <jpetrous@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manu,

2010/1/14 Manu Abraham <abraham.manu@gmail.com>:
> Well, the SAA716x is only the PCI Express interface. There is no video
> capture involved in there with the STi7109. It is a full fledged DVB
> STB SOC.
>
> OSD is handled by the STi7109 on that STB.
> http://www.st.com/stonline/products/literature/bd/11660/sti7109.pdf
>
> Though it is not complete, that driver, it still does handle it,
> through the firmware interface. These are the kind of devices that you
> find on a DVB STB, i must say.
>
> On a DVB STB, what happens is that you load a vendor specific firmware
> on the SOC. The SOC is just issued the firmware commands, that's how a
> STB works in principle. A DVB STB can be considered to have 2 outputs,
> ie if you use it as a PC card, you can output the whole thing to your
> PC monitor, or output it to a TV set. But in the case of the STB, you
> have a TV output alone.
>

I never know about use of stb7109 in any PCI card. It is surprise
to me. Interesting what firmware is loaded to stb7109. Is it STM's
proprietary os21 or even linux?

/Honza
