Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33048 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab1HNL0h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 07:26:37 -0400
Message-ID: <4E47B0E9.2030801@iki.fi>
Date: Sun, 14 Aug 2011 14:26:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: TerraTec T6 Dual Tuner Stick initial support available
References: <201108140930.07873.hfvogt@gmx.net>
In-Reply-To: <201108140930.07873.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/14/2011 10:30 AM, Hans-Frieder Vogt wrote:
> just wanted to inform you that I got the TerraTec Dual DVB-T Stick working 
> using a slightly patched driver from Afatech. Please see the wiki entry
> http://www.linuxtv.org/wiki/index.php/TerraTec_T6_Dual_DVB-T_Stick
> Currently both tuners work, but the remote doesn't.
> 
> This driver is only supposed to be a temporary solution until I have 
> integrated the bits into Antti's af9035 driver, see
> http://openee.googlecode.com/svn-history/r137/trunk/recipes/v4l-dvb/files/v4l-
> dvb-af9035.patch
> http://openee.googlecode.com/svn-history/r137/trunk/recipes/v4l-dvb/files/v4l-
> dvb-af9033.patch

Situation of my AF9035 & AF9033 driver is and have been years totally
frozen, I given it up since I never got permission from ITE to push it
Kernel and firmware distribution. Thus I left it. I have had in mind to
write out all vendor code (not much code I think) to get rid of
copyrights and do what I want - but never had enough time.

Due to that I am not going to work my AF9035 + AF9033 unless something
changes dramatically at least now when there is other drivers.


regards
Antti


-- 
http://palosaari.fi/
