Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-m06.mx.aol.com ([64.12.138.200]:9902 "EHLO
	imr-m06.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZDPNuW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 09:50:22 -0400
References: <1239420379.7179.16.camel@desktop>
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Transfer-Encoding: 7bit
Subject: Re: [linux-dvb] Compro T750F not working yet...BUG: unable to handle kernel
 paging request at fffffff4
Date: Thu, 16 Apr 2009 09:41:20 -0400
In-Reply-To: <1239420379.7179.16.camel@desktop>
MIME-Version: 1.0
From: td9678td@aim.com
Content-Type: text/plain; charset="us-ascii"; format=flowed
Message-Id: <8CB8CB027F1FC52-12EC-85E@webmail-stg-d01.sysops.aol.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

i guess, this is not the cause of your problem, but maybe can help a 
bit. Do you only use Linux, or Linux and Windows on your machine?
Sometimes i noticed, if i start Linux first, and after this Windows, i 
have only sound but no video, using the card's analog tuner. I have 
Compro T750, and under Linux it just loads some driver at startup, but 
i don't do anything else...

Cheers,
Daniel




>Hi Everyone,

>I have a Compro VideoMate T750F which is not working under Ubuntu 9.04
>BETA. I get the same result as davor emard <davoremard <at> gmail.com>
>posted 2009-01-19 11:45:46 GMT.

>The relevant part of the dmesg below, perhaps the 'BUG: unable to 
handle
>kernel paging request at fffffff4' part is part of the problem?

>I have pasted the attached xc3028-v27.fw created in Ubuntu 8.10
>into /lib/firmware but still no go.

>Thanks,
>Andrew


