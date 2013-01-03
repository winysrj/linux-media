Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54307 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab3ACVYd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jan 2013 16:24:33 -0500
Received: from mailout-eu.gmx.com ([10.1.101.210]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LcVHU-1T89Kz24NK-00jrgp for
 <linux-media@vger.kernel.org>; Thu, 03 Jan 2013 22:24:31 +0100
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Subject: Re: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
References: <op.wp845xcf4bfdfw@quantal> <50E36298.3040009@iki.fi>
 <op.wp9b661h4bfdfw@quantal> <50E37C95.3020208@iki.fi>
Date: Thu, 03 Jan 2013 22:24:27 +0100
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "Antti Palosaari" <crope@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Diorser <diorser@gmx.fr>
Message-ID: <op.wqctq1ej4bfdfw@quantal>
In-Reply-To: <50E37C95.3020208@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>  I don't know why you resists to remove antenna or unplug stick, but  
> even you remove antenna I am quite sure you will see similar results.

I've been simply confused by the signal reported at ffff level most of the  
time, and the scanning working.
I thought the problem was a step behind with the demux error reported by  
dvbsnoop wrongly used.

Can you confirm, either you personally, or someone else you know, that  
AVerTV_Volar_HD_PRO_A835 using same components as A918R fully works  
including tuning+scanning ?
If so, it's hard to believe that Avermedia made something different when  
changing from a USB stick to Express card detected as USB, but who  
knows....

> Maybe there is some GPIO controlling antenna input or switching some  
> other.

I've noticed that af9035.c does not contain any GPIO settings for TDA18218  
(all other tuners have).
Would it be possible to implement gpio setting for TDA18218 so that they  
are used for implementations requesting it ? (just an assumption of  
course). Don't know at all if this kind of information is easily available.

If necessary, although not familiar at all with debugging, I can try co  
compile a specific kernel with CONFIG_DEBUG_KERNEL=y option to see if I  
can grab something interesting.

Finally, it seems that fresh implementation of TDA18218 needs a bit more  
investigation checked on more devices.

BTW, is the A918R patch proposal accepted to be taken into consideration,  
or do I have to make a more formal GIT request ?

Regards.
Diorser.







