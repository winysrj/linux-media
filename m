Return-path: <mchehab@pedra>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:41253 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab1EXMFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 08:05:38 -0400
Subject: Re: dvb: one demux per tuner or one demux per demod?
From: Steve Kerrison <steve@stevekerrison.com>
To: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
Cc: linux-media@vger.kernel.org, vlc-devel@videolan.org
In-Reply-To: <719f9c4d1bd57d5b2711bc24a9d5c3b1@chewa.net>
References: <719f9c4d1bd57d5b2711bc24a9d5c3b1@chewa.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 13:05:34 +0100
Message-ID: <1306238734.7397.102.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Rémi,

The cxd2820r supports DVB-T/T2 and also DVB-C. As such antti coded up a
multiple front end (MFE) implementation for em28xx then attaches the
cxd2820r in both modes.

I believe you can only use one frontend at once per adapter (this is
certainly enforced in the cxd2820r module), so I don't see how it would
cause a problem for mappings. I think a dual tuner device would register
itself as two adapters, wouldn't it?

But I'm new at this, so forgive me if I've overlooked something or
misunderstood the issue you've raised.

Regards,
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Tue, 2011-05-24 at 12:55 +0200, Rémi Denis-Courmont wrote:
> Hello,
> 
> Been testing the bleeding-edge Hauppauge 290E (em28174 + Sony cxd2820r)
> from Antti Palosaari and Steve Kerrison, now in linux-media GIT tree.
> 
> It seems the device creates two frontends and only one demux/dvr nodes.
> Are they not supposed to be one demux per frontend? Or how is user-space
> supposed to map the demux/dvr and the frontend, on a multi-proto card? on a
> multi-tuner card?
> 
> Best regards,
> 

