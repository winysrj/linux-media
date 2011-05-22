Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44381 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab1EVCZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 22:25:29 -0400
Received: by gwaa18 with SMTP id a18so1718911gwa.19
        for <linux-media@vger.kernel.org>; Sat, 21 May 2011 19:25:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=poXh2q+4N6Q9iMJxoW=9txLjt4w@mail.gmail.com>
References: <BANLkTin=Fs-ugm13yT89PtT4bds4WobszA@mail.gmail.com> <BANLkTi=poXh2q+4N6Q9iMJxoW=9txLjt4w@mail.gmail.com>
From: Roman Gaufman <hackeron@gmail.com>
Date: Sun, 22 May 2011 03:25:08 +0100
Message-ID: <BANLkTimQGYqS=PRNJSEtL5Wu0rP3YdEOVg@mail.gmail.com>
Subject: Re: Connexant cx25821 help
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I figured as much, but what can I do now?

Should I take some high resolution pictures of the board?
Any other details I can provide to help developers add support for this board?
Is there anyone in particularly I should contact?
Anywhere I can post any information I collect on this board?

I'm happy to donate this board if someone wants to help add support for it.

On 22 May 2011 02:37, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
>
> Just because there is a driver for whatever chipset your board happens
> to have, doesn't mean that your board is actually supported.  The
> definition of a product is more than just the chips that are on it.
>
>> # modprobe cx25821
>
> You should *never* have to manually modprobe.  If you ran modprobe,
> then that means the driver does not know about the PCI ID for your
> board.
>
>> The module looks like to be loaded successfully.
> <snip>
>> And now I can not see any /dev/video0-7 devices to get input from the card.
>> I'l greatly appreciate if someone could tell me about additional actions to
>> make this work.
>
> The /dev/video devices will not be created if the driver did not
> associate with the card.  Basically what you did is the equivalent of
> modprobing any driver in the system regardless of whether or not it
> has anything to do with the actual hardware you happen to have.
>
> Somebody would likely have to do work to modify the driver to support
> your board.  This would mean a driver developer who actually cared
> enough to do the work would have to have one of the boards, which
> doesn't appear to be the case at this point.
>
> Hope that helps (or at least it makes clear that this board will not
> just start to magically work just because you have a card which
> contains the chips involved).
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
