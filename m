Return-path: <linux-media-owner@vger.kernel.org>
Received: from joan.kewl.org ([212.161.35.248]:51623 "EHLO joan.kewl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZCZCBY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 22:01:24 -0400
From: Darron Broad <darron@kewl.org>
To: "Udo A. Steinberg" <udo@hypervisor.org>
cc: Darron Broad <darron@kewl.org>, v4l-dvb-maintainer@linuxtv.org,
	linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: Hauppauge/IR breakage with 2.6.28/2.6.29 
In-reply-to: <20090326023841.40ab3ad1@laptop.hypervisor.org> 
References: <20090326000932.6aa1a456@laptop.hypervisor.org> <29212.1238027207@kewl.org> <20090326023841.40ab3ad1@laptop.hypervisor.org>
Date: Thu, 26 Mar 2009 02:01:21 +0000
Message-ID: <30162.1238032881@kewl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In message <20090326023841.40ab3ad1@laptop.hypervisor.org>, "Udo A. Steinberg" wrote:

hi

>On Thu, 26 Mar 2009 00:26:47 +0000 Darron Broad (DB) wrote:
>
>DB> It's something I forget to deal with in that patch. A solution
>DB> would be to allow a device address to be a module param to
>DB> override the more modern addresses of 0x1e and 0x1f.
>DB>=20
>DB> I can't remember addresses off the top of my head but I believe
>DB> the modern silver remotes use 0x1f and the older black ones
>DB> use 0x1e. I think the black one I have came with a now dead
>DB> DEC2000.
>DB>=20
>DB> The problem with reverting the patch is that it makes modern
>DB> systems unusable as HTPCs when the television uses RC5. This
>DB> is a more important IMHO than supporting what in reality is
>DB> an obsolete remote control.
>
>Hi,
>
>Maybe there aren't many old remotes out there anymore, but from looking at
>the table at http://www.sbprojects.com/knowledge/ir/rc5.htm it appears the
>remote is not doing anything wrong by using RC5 address 0x0 to talk to what
>could be considered a TV (card).
>
>The more fundamental issue here is that both devices/remotes use the same
>RC5 address - not surprising if you own two devices of the same device clas=
>s.
>
>So I'm all for your suggestion of adding a parameter that will allow the
>user to either specify the address(es) to accept or ignore. Which of the
>following options would you consider most convenient for the unknowing user?
>
>1) parameter specifies the only device id that ir-kbd-i2c will accept
>2) parameter specifies a 32-bit mask of acceptable device ids. Any device id
>   whose bit is set will be accepted, others will be filtered
>3) parameter specifies a 32-bit mask of device ids to filter. Any device id
>   whose bit is set will be filtered, others will be accepted
>
>Cheers,

A quick think about this gives this idea:

1. have a module parm for device address and if it's '0' then accept ANY
address. this is the old behaviour.

2. if the module param isn't '0' then accept only that address.

cya


--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 

