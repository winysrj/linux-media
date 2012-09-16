Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39541 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab2IPOYC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 10:24:02 -0400
Message-ID: <5055E0ED.8030808@iki.fi>
Date: Sun, 16 Sep 2012 17:23:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: ITE9135 on AMD SB700 - ehci_hcd bug
References: <ksm5i9-2t1.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <ksm5i9-2t1.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2012 09:32 AM, Marx wrote:
> Hello
> I'm trying to use dual DVB-T tuner based on ITE9135 tuner. I use Debian
> kernel 3.5-trunk-686-pae. My motherboard is AsRock E350M1 (no USB3 ports).
> Tuner is detected ok, see log at the end of post.
>
> When I try to scan channels, bug happens:
> Sep 11 17:16:31 wuwek kernel: [  209.291329] ehci_hcd 0000:00:13.2:
> force halt; handshake f821a024 00004000 00000000 -> -110
> Sep 11 17:16:31 wuwek kernel: [  209.291401] ehci_hcd 0000:00:13.2: HC
> died; cleaning up
> Sep 11 17:16:31 wuwek kernel: [  209.291606] usb 2-3: USB disconnect,
> device number 2
> Sep 11 17:16:41 wuwek kernel: [  219.312848] dvb-usb: error while
> stopping stream.
> Sep 11 17:16:41 wuwek kernel: [  219.320585] dvb-usb: ITE 9135(9006)
> Generic successfully deinitialized and disconnected.
>
> After trying many ways I've read about problems with ehci on SB700 based
> boards and switched off ehci via command
> sh -c 'echo -n "0000:00:13.2" > unbind'
> and now ehci bug doesn't happen. Of course I can see only one tuner and
> in slower USB mode (see log at the end). But now I can scan succesfully
> without any errors.
>
> Of course it isn't acceptable fix for my problem. Drivers for ITE9135
> seems ok, but there is a problem with ehci_hcd on my motherboard.
> I would like to know what can I do to fix my problem.

I am quite sure dvb_usb_v2 fixes that. Test latest tree.

Antti

-- 
http://palosaari.fi/
