Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:53652 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbZIPG5D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 02:57:03 -0400
Date: Wed, 16 Sep 2009 08:57:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?UTF-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Message-ID: <20090916085701.6e883600@hyperion.delvare>
In-Reply-To: <200909160300.28382.pluto@agmk.net>
References: <200909160300.28382.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Wed, 16 Sep 2009 03:00:28 +0200, Paweł Sikora wrote:
> the latest 2.6.31 kernel oopses in ir-kbd-i2c on my box:
> afaics the 2.6.28.10 is also affected.
> 
> http://imgbin.org/index.php?page=image&id=776
> http://imgbin.org/index.php?page=image&id=777
> http://imgbin.org/index.php?page=image&id=778
> 
> installed pinnacle tv card with infra-red receiver:
> 
> 05:00.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
>         Video Broadcast Decoder (rev d1)
>         Subsystem: Pinnacle Systems Inc. PCTV 110i (saa7133)
>         Kernel driver in use: saa7134
>         Kernel modules: saa7134
> 
> if you need i'll provide more information.
> please, CC me on reply.

This would have best been posted to linux-media... Cc'd.

I think this would be fixed by the following patch:
http://patchwork.kernel.org/patch/45707/

Can you please give it a try?

If I am correct then only kernel 2.6.31 would be affected, 2.6.30
wouldn't be.

-- 
Jean Delvare
