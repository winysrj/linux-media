Return-path: <linux-media-owner@vger.kernel.org>
Received: from skyboo.net ([82.160.187.4]:41464 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751339Ab2GaIdn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 04:33:43 -0400
Message-ID: <5017983B.9080104@skyboo.net>
Date: Tue, 31 Jul 2012 10:32:59 +0200
From: Mariusz Bialonczyk <manio@skyboo.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Wojciech Myrda <vojcek@tlen.pl>
References: <1343326123-11882-1-git-send-email-manio@skyboo.net> <50174C3A.1070407@redhat.com>
In-Reply-To: <50174C3A.1070407@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Add support for Prof Revolution DVB-S2 8000 PCI-E card
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2012 05:08 AM, Mauro Carvalho Chehab wrote:
> Em 26-07-2012 15:08, Mariusz Bialonczyk escreveu:
>> The device is based on STV0903 demodulator, STB6100 tuner
>> and CX23885 chipset; subsystem id: 8000:3034
>>
>> Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>
> 
> This is the second time I see this patch. It seems very similar to the
> one sent by Wojciech. So, who is the author of this patch?
Hi!
Wojciech Myrda's patch was based on original producer patch from here:
http://www.proftuners.com/sites/default/files/prof8000_0.patch

>From my diagnose (diff original and his patch) he rebased it to take
into account later kernel sources.

You ask him to post it again with Signed-off-by line, but he doesn't
respond for over a year (at least to linux media mailing list).

My patch uses stv090x frontend instead and I assumed that I can
ommit additional signed-off-by lines in this case.

If it is not ok, please tell me and I will prepare second patch
with additional Signed-off-by lines.

regards!
-- 
Mariusz Białończyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
