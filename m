Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:53652 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbZF3Lmc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 07:42:32 -0400
Received: by qyk31 with SMTP id 31so72603qyk.33
        for <linux-media@vger.kernel.org>; Tue, 30 Jun 2009 04:42:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c21478f30906291908y2f601577sfc94e7abc378d9e5@mail.gmail.com>
References: <c21478f30906291719r41ba5accu75c5bfd3dcb81276@mail.gmail.com>
	 <829197380906291759q7ded8117tee12214073d85e67@mail.gmail.com>
	 <c21478f30906291908y2f601577sfc94e7abc378d9e5@mail.gmail.com>
Date: Tue, 30 Jun 2009 07:42:34 -0400
Message-ID: <829197380906300442q3f3d0ed6w8c0d8bdeee3de6f9@mail.gmail.com>
Subject: Re: XC2028 Tuner - firmware issues
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andrej Falout <andrej@falout.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 29, 2009 at 10:08 PM, Andrej Falout<andrej@falout.org> wrote:
>> The dvb-usb framework doesn't have any analog support.  Therefore none
>> of the dib0700 based devices will support analog either (the problem
>> is not specific to your device and has nothing to do with the xc3028
>> firmware).
>
> Thanks for this, Devin. Are there no plans to support analog in
> dvb-usb in the future, or is someone maybe working on this?

It's been in this state for years now, and nobody is working on it.

I've been thinking about doing it myself for a while since I have a
couple of dib0700 boards, but it's a big project and I'm not sure I
have the motivation since I just completed work on analog support for
a different bridge (I'm also working on other drivers right now so
it's a question of priorities).

It's a non-trivial project - easily a couple thousand lines of code.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
