Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45994 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbbKWOHS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 09:07:18 -0500
Subject: Re: DVBSky T330 DVB-C regression Linux 4.1.12 to 4.3
To: Stephan Eisvogel <eisvogel@seitics.de>,
	Olli Salonen <olli.salonen@iki.fi>
References: <CAAZRmGwzsqFYtSNDCCCwFR4vCRgtz9CrixsZyc0xJzb=S6OEsw@mail.gmail.com>
 <564D0B81.5040604@seitics.de>
Cc: linux-media <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56531D93.3070007@iki.fi>
Date: Mon, 23 Nov 2015 16:07:15 +0200
MIME-Version: 1.0
In-Reply-To: <564D0B81.5040604@seitics.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 11/19/2015 01:36 AM, Stephan Eisvogel wrote:
> Hey Olli, Antti,

> culprit is:
>
> http://git.linuxtv.org/cgit.cgi/linux.git/commit/drivers/media/dvb-frontends/si2168.c?id=7adf99d20ce0e96a70755f452e3a63824b14060f
>
> I removed it like this:
>          /* error bit set? */
> /*
>          if ((cmd->args[0] >> 6) & 0x01) {
>              ret = -EREMOTEIO;
>              goto err;
>          }
> */
>
> With this change backed out I zapped through about a 100 channels, and
> my DVB stick works
> again. Of course demodulator error handling would be nice anyhow. Beyond
> my time budget
> for now.

Surprising finding. Init succeeded already as firmware was downloaded so 
that error likely happens during si2168_set_frontend(). As set frontend 
is called once for each tuning request one failure should not cause more 
harm than one tuning failure. It could be nice to see which function is 
failing and if it fails repeatedly.

To see that, debug messages should be enabled:
modprobe si2168 dyndbg==pmftl
or
modprobe si2168; echo -n 'module si2168 =pft' > 
/sys/kernel/debug/dynamic_debug/control

You could also replace all dev_dbg with dev_info if you don't care 
compile kernel with dynamic debugs enabled needed for normal debug logging.

Also, you used 4.0.19 firmware. Could you test that old one:
http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-B40/4.0.11/

Unfortunately I don't have that device at all, so I cannot do much 
myself. It is more up to Olli :]

regards
Antti

-- 
http://palosaari.fi/
