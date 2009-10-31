Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48280 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311AbZJaWr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 18:47:59 -0400
Received: by bwz27 with SMTP id 27so4922238bwz.21
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 15:48:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
Date: Sat, 31 Oct 2009 23:48:03 +0100
Message-ID: <d2f9b55e0910311548oe6e297frf618f6c8a3dd947a@mail.gmail.com>
Subject: Re: em28xx DVB modeswitching change: call for testers
From: Alain Perrot <alain.perrot@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 14, 2009 at 4:52 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> Hello all,
>
> I have setup a tree that removes the mode switching code when
> starting/stopping streaming.  If you have one of the em28xx dvb
> devices mentioned in the previous thread and volunteered to test,
> please try out the following tree:
>
> http://kernellabs.com/hg/~dheitmueller/em28xx-modeswitch
>
> In particular, this should work for those of you who reported problems
> with zl10353 based devices like the Pinnacle 320e (or Dazzle) and were
> using that one line change I sent this week.  It should also work with
> Antti's Reddo board without needing his patch to move the demod reset
> into the tuner_gpio.
>
> This also brings us one more step forward to setting up the locking
> properly so that applications cannot simultaneously open the analog
> and dvb side of the device.
>
> Thanks for your help,
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

Hi,

I finally give your tree a try with my Dazzle Hybrid Stick on a laptop running
Kubuntu 9.10 "Karmic" (Linux 2.6.31).

With the drivers from your tree, the device is properly detected as a Pinnacle
Hybrid Pro, but a scan using Kaffeine find DVB-T channels on one or two
frequencies only and tuning to one of these channels almost always fail.

I reverted back to the drivers from the stock Linux 2.6.31 kernel from Kubuntu
9.10. The scan does not really work better, but using an older list of channels,
I can tune channels with significantly less failures.

Regards,
Alain
