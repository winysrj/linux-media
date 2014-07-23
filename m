Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35821 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbaGWGnO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 02:43:14 -0400
Message-ID: <53CF597C.6050708@iki.fi>
Date: Wed, 23 Jul 2014 09:43:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: Re: [linuxtv-media:master 378/499] ERROR: "__udivdi3" [drivers/media/dvb-frontends/rtl2832_sdr.ko]
 undefined!
References: <53cf9a8e.E95mSmw/U7btaj7k%fengguang.wu@intel.com>
In-Reply-To: <53cf9a8e.E95mSmw/U7btaj7k%fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!


On 07/23/2014 02:20 PM, kbuild test robot wrote:
> tree:   git://linuxtv.org/media_tree.git master
> head:   eb9da073bd002f2968c84129a5c49625911a3199
> commit: 77bbb2b049c1c3e935f5bec510bec337d94ae8f8 [378/499] rtl2832_sdr: move from staging to media
> config: i386-randconfig-ha2-0723 (attached as .config)
>
> Note: the linuxtv-media/master HEAD eb9da073bd002f2968c84129a5c49625911a3199 builds fine.
>        It only hurts bisectibility.
>
> All error/warnings:
>
>>> ERROR: "__udivdi3" [drivers/media/dvb-frontends/rtl2832_sdr.ko] undefined!


Could you say what I should do for that? Bug is fixed and solution is 
merged as that patch:

commit a98ccfcf4804beb2651b9f44a4bc5cbb387019ec
Author: Antti Palosaari <crope@iki.fi>
Date:   Tue Jul 22 00:18:19 2014 -0300

     [media] rtl2832_sdr: remove plain 64-bit divisions

Do you want Mauro to rebase whole media/master in order to make 
bisectibility possible in any case?

regards
Antti

-- 
http://palosaari.fi/
