Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36201 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbdFTACU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 20:02:20 -0400
Received: by mail-oi0-f41.google.com with SMTP id p187so5406998oif.3
        for <linux-media@vger.kernel.org>; Mon, 19 Jun 2017 17:02:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459689819.831695.1497775518752@communicator.strato.de>
References: <1459689819.831695.1497775518752@communicator.strato.de>
From: Adam Zegelin <adam@zegelin.com>
Date: Tue, 20 Jun 2017 10:02:19 +1000
Message-ID: <CAP2KGUkgSbo9n8ZES6fvW_-DY7M4pS=F89N=s+yGbjiKGKpiEA@mail.gmail.com>
Subject: Re: HauppaugeTV-quadHD DVB-T mpeg risc op code errors
To: Thomas Kuehne <thomas@thk-net.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

I haven't had much time to investigate the issue -- I'm currently in
the process of moving country, which is a lot of work!

One thing I was able to determine is that it appears to be related to
Intel VT-d/VT-x or whatever Intel's IOMMU/x86 virtualisation tech
thing is called.

I tried the card in a different older Intel i7 board and it worked
flawlessly. I then started to wonder if it was some new
incompatibility introduced with Kaby Lake. I had tweaked the UEFI
settings on the new Kaby Lake board to enable VT-d/VT-x since I wanted
to run Linux as a host OS with Windows 10 running on top of qemu/KVM.
Upon resetting the UEFI settings to their defaults (VT-d/VT-x
disabled) the card worked without issue.

Maybe this will point you in the right direction, especially since you
mention that your using EXSi with PCIe passthrough, which requires the
use of VT-d/VT-x.

Whether the card itself has issues with VT-d/VT-x or it's a driver bug
I have yet to determine -- how I do that, no idea!

I've CC'd the list, which should include your reply too. See
http://vger.kernel.org/vger-lists.html#linux-media to subscribe to the
list.

Regards,
Adam

On Sun, Jun 18, 2017 at 6:45 PM, Thomas Kuehne <thomas@thk-net.de> wrote:
> Hi Adam,
>
> interestingly, I have the same issue and you "fix" also works for me, at =
least partly.
>
> I run the quad HD on a little 1RU server that has vmware's ESXi superviso=
r installed, and the card is configured for PCI passthrough. The virtual ma=
chine that makes use of this card runs tvheadend 4.2.2. Other than that, th=
e setup is similar to what you describe. (Ubuntu 16.04.2 LTS Kernel 4.8, dr=
iver vb-demod-si2168-b40-01.fw version 4.0.11)
>
> Without the debug kernel option, I get the same load of errors, and the t=
vheadend software is not able to tune.
> Adding debug level 5, I get a picture. So, I guess I am with you that the=
 additional latency induced by the debug option helped the driver to cope.
>
> Were you successful in solving the issue with your card? Any idea how we =
might get this looked at? I haven't worked out how I can respond to your th=
read on the mailing list (found it via a google search at the mail archive)=
. Maybe you can add my response to the thread?
>
> Best regards,
>
> Thomas
