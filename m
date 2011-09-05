Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45260 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab1IEROo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 13:14:44 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 86D0F94023E
	for <linux-media@vger.kernel.org>; Mon,  5 Sep 2011 19:14:37 +0200 (CEST)
Date: Mon, 5 Sep 2011 19:15:17 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: Re: spca1528 device (Device 015: ID 04fc:1528 Sunplus
 Technology)..libv4l2: error turning on	stream: Timer expired issue
Message-ID: <20110905191517.6945c15c@tele>
In-Reply-To: <4E64EBDD.9050807@gmail.com>
References: <4E63D3F2.8090500@gmail.com>
	<20110905091959.727346d5@tele>
	<4E64EBDD.9050807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 05 Sep 2011 11:33:49 -0400
Mauricio Henriquez <buhochileno@gmail.com> wrote:

> Thanks Jean, yeap I apply the patch, but still the same kind of messages 
> about timeout sing xawtv or svv:

OK Mauricio. So, I need more information. May you set the gspca debug
level to 0x0f

	echo 0x0f > /sys/module/gspca_main/parameters/debug

run 'svv' and send me the kernel messages starting from the last gspca
open?

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
