Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab0DNRpH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 13:45:07 -0400
Message-ID: <4BC5FF15.10605@redhat.com>
Date: Wed, 14 Apr 2010 10:44:53 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org
Subject: Re: tm6000: firmware
References: <4BC5ECB8.2060208@arcor.de>
In-Reply-To: <4BC5ECB8.2060208@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

Em 14-04-2010 09:26, Stefan Ringel escreveu:
> Hi Mauro,
> 
> Can you added these three firmwares? The third is into archive file,
> because I'm extracted for an user (Bee Hock Goh).

Sorry, but for us to put the firmwares at the server and/or add them at linux-firmware 
git tree, we need to get the distribution rights from the manufacturer,
as described on:
	http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches#Firmware_submission

So, we need Xceive's ack, in order to add the firmware files somewhere. That's why
currently we're using the procedure described on the comments at the extraction
tool:
	Documentation/video4linux/extract_xc3028.pl  

Cheers,
Mauro
