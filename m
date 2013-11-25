Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:46392 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab3KYJX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:23:58 -0500
Date: Mon, 25 Nov 2013 10:23:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] femon: Display SNR in dB
Message-ID: <20131125102345.4b654435@endymion.delvare>
In-Reply-To: <CAHFNz9LX0WzmO1zvn51Ge8VQkfiPrao3AQVLprhqrp1V-0h=fQ@mail.gmail.com>
References: <20130603171607.73d0b856@endymion.delvare>
 <20130603172150.1aaf1904@endymion.delvare>
 <CAHFNz9LX0WzmO1zvn51Ge8VQkfiPrao3AQVLprhqrp1V-0h=fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manu,

On Sun, 24 Nov 2013 22:51:33 +0530, Manu Abraham wrote:
> Sorry, that I came upon this patch quite late.

No problem, better late than never! :)

> On Mon, Jun 3, 2013 at 8:51 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > SNR is supposed to be reported by the frontend drivers in dB, so print
> > it that way for drivers which implement it properly.
> 
> Not all frontends do report report the SNR in dB. Well, You can say quite
> some frontends do report it that way.

Last time I discussed this, I was told that this was the preferred way
for frontends to report the SNR. I also referred to this document:
  http://palosaari.fi/linux/v4l-dvb/snr_2012-05-21.txt
I don't know now up-to-date it is by now, but back then it showed a
significant number of frontends reporting in .1 dB already, including
the ones I'm using right now (drx-3916k and drx-3913k.) With the
current version of femon, "femon -H" reports it as 0%, which is quite
useless. Thus my patch.

> Making the application report it in
> dB for frontends which do not will show up as incorrect results, from what
> I can say.

My code has a conditional to interpret high values (>= 1000) as % and
low values (< 1000) as .1 dB. This is a heuristic which works fine for
me in practice (tested on drxk, cx22702 and dib3000mc.) I would
certainly welcome testing on other DVB cards. I seem to recall that
Mauro suggested that values above 40 dB (?) were not possible so we
could probably lower the threshold from 1000 to 400 or so if the
current value causes trouble. I think the maximum I've see on my card
was ~32 dB.

If you find a significant number of frontend drivers for which the
heuristic doesn't work, and lowering the threshold doesn't help, then
I'm fine considering a different approach such as an extra command line
parameter. But if only a small number of drivers cause trouble, I'd say
these drivers should simply be fixed.

Thanks,
-- 
Jean Delvare
