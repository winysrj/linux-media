Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:55077 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbcEURSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2016 13:18:16 -0400
Date: Sat, 21 May 2016 19:18:04 +0200 (CEST)
From: Rolf Evers-Fischer <embedded24@evers-fischer.de>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, olli.salonen@iki.fi
Message-ID: <1462632761.60865.9e12e00b-17f0-44f6-a594-47afc484639a.open-xchange@email.1und1.de>
In-Reply-To: <7a7c5464-f0ba-c6ab-e6a5-d021672762b5@iki.fi>
References: <1677993131.49456.01924d52-f180-4aca-bc23-42b237aaedb7.open-xchange@email.1und1.de>
 <7a7c5464-f0ba-c6ab-e6a5-d021672762b5@iki.fi>
Subject: Re: DVBSky T330 DVB-C regression Linux 4.1.12 to 4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Antti Palosaari <crope@iki.fi> hat am 21. Mai 2016 um 02:16 geschrieben:
> 
> Reason is that silicon vendor has changed firmware API somewhere between 
> 4.0.11 and 4.0.19 so that newer firmwares will put device to full sleep 
> which causes even device firmware lost.
> 
> Fix is here, and I hope I can push it to 4.8 - it will took about half 
> year from this day until it is on mainline (it is not regression so I 
> cannot send it to older kernels and for 4.7 it is too late). Before that 
> just use 4.0.11 firmware.
> 
> https://git.linuxtv.org/anttip/media_tree.git/commit/?h=mygica&id=cfd6ab8e840815eb54eb777c9f64807022ba922c
> 

Thank you for the fix. I can confirm that it works with 4.0.11 and 4.0.19
firmware. Let's hope that you can push it at least to 4.8.

Kind regards,
 Rolf
