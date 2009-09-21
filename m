Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49366 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbZIUMf5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 08:35:57 -0400
Message-ID: <4AB77329.5000405@iki.fi>
Date: Mon, 21 Sep 2009 15:35:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
CC: Roman <lists@hasnoname.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: MSI Digivox mini III Remote Control
References: <200909202026.27086.lists@hasnoname.de> <20090921081933.GA29884@moon> <200909211253.49766.lists@hasnoname.de> <20090921115122.GA2269@moon>
In-Reply-To: <20090921115122.GA2269@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/21/2009 02:51 PM, Aleksandr V. Piskunov wrote:
> Just grab that patch and apply it to the current vl4-dvb, no need to mess
> with old repository.
> http://linuxtv.org/hg/~anttip/af9015-digivox3_remote/raw-rev/914ded6d921d

With this patch remote will not work most likely. But after adding that 
patch you should see remote events dumped to the /var/log/messages when 
key is pressed. I need to know which key gives which code. After that I 
can add correct key mappings to the driver.

Antti
-- 
http://palosaari.fi/
