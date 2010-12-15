Return-path: <mchehab@gaivota>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33954 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0LOFdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 00:33:45 -0500
Received: by gyb11 with SMTP id 11so823685gyb.19
        for <linux-media@vger.kernel.org>; Tue, 14 Dec 2010 21:33:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik-ek+KT73+jU251h3o5HEV4WU-7g36nnys5xC3@mail.gmail.com>
References: <AANLkTik-ek+KT73+jU251h3o5HEV4WU-7g36nnys5xC3@mail.gmail.com>
Date: Wed, 15 Dec 2010 06:33:44 +0100
Message-ID: <AANLkTinmeTuFC5VWgGTxTr43MO8=p8F2OF2phoOCnS_E@mail.gmail.com>
Subject: Re: Simple request : mini-pcie analog TV capture card
From: Markus Rechberger <mrechberger@gmail.com>
To: Fernando Laudares Camargos <fernando.laudares.camargos@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On Wed, Dec 15, 2010 at 1:25 AM, Fernando Laudares Camargos
<fernando.laudares.camargos@gmail.com> wrote:
>
> Hello List,
>
> I'm after a somehow quite simple information: I'm looking for a
> mini-pcie TV tuner/capture card. I simply need to plug my cable TV
> decoder to such a card to "watch" TV on Linux. I've got success with a
> Hauppauge 950Q USB stick and TV time but this is not a one-time
> project and we would need to replicate it in a somehow large scale, so
> a mini-pcie card would fit the hardware best.
>
> Does anybody know any mini-pcie model analog card that are still
> available on the market and that is compatible with this need ?
>
> I've looked at linuxtv.org lists but couldn't find one.
>
> Habey has a new model, based on the ATI Theater 750 HD chip, which is
> not supported.
>
> AVerMedia has some models too, but none seems to have analog mode
> working on Linux.
>
> Any suggestions would be kindly appreciated.
>

We have MiniPCIe AnalogTV devices which are very well supported.

Basically those devices are using the USB Pins of the MiniPCIe Bus.
All worldwide standards are supported, we have
ATSC/clearQAM/analogTV(NTSC)/VBI/FM-Radio/composite and s-video
are available through reserved pin routing.
A European version is also available.

Tested applications
* http://tvtime.sourceforge.net tvtime
* http://www.videolan.org/vlc/ VLC
* http://www.mplayerhq.hu/design7/news.html Linux mplayer
* http://www.mythtv.org/ MythTV
* http://linux.bytesex.org/xawtv/ XawTV
* http://zapping.sourceforge.net/Zapping/index.html Zapping
* http://ekiga.org/ Ekiga VOIP (Channel 0: TV Channel 1: Composite
Channel 2: S-Video)
* http://www.lavrsen.dk/twiki/bin/view/Motion/WebHome Motion detection Software

http://support.sundtek.com/index.php/topic,4.0.html
http://sundtek.com/images/vivi.png (some virtual driver emulation for testing)

Setup shouldn't take longer than a few seconds

Best Regards,
Markus
