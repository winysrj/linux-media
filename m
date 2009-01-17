Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout10.t-online.de ([194.25.134.21]:35131 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZAQKI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 05:08:59 -0500
Message-ID: <4971AE26.9070901@t-online.de>
Date: Sat, 17 Jan 2009 11:08:38 +0100
From: Detlef Rohde <rohde.d@t-online.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Jochen Friedrich <jochen@scram.de>,
	Roberto Ragusa <mail@robertoragusa.it>,
	linux-media@vger.kernel.org
Subject: Re: MC44S803 frontend (it works)
References: <4936FF66.3020109@robertoragusa.it> <494C0002.1060204@scram.de> <49623372.90403@robertoragusa.it> <4965327A.5000605@t-online.de> <496CD4C8.50004@t-online.de> <496E2C6B.3050607@scram.de> <496E2FB5.4080406@scram.de> <4971367E.90504@iki.fi>
In-Reply-To: <4971367E.90504@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,
thanks for your work. I unpacked mc44s803-b7ac1c462be3 and tried to run 
"make install" as root since I wanted to update my kernel modules. This 
did not work. On the other hand running only "make" finished with some 
warnings but no errors. My kernel is  2.6.27-11-generic from Ubuntu 
8.10. The system is up to date. These tries I performed on a newly 
installed Linux where I never tried running my DVB-T stick (TerraTec 
Electronic GmbH Cinergy T XE DVB-T Receiver, MKII) under Linux before. 
Have installed VMware on this machine and can use the stick without 
problems in a WXP-Pro VM. Can you please give an advice what I should do 
next? I wo'nt destroy my running system.
Best regards,
Detlef

Antti Palosaari schrieb:
> Hello
> I just pushed Jochen's MC44S803 driver to linuxtv.org devel tree. I 
> did some changes to patch that adds this tuner to AF9015, because 
> patch didn't applied and also some other changes. Hopefully it doesn't 
> break functionality. Please test.
>
> http://linuxtv.org/hg/~anttip/mc44s803/
>
> regards
> Antti
