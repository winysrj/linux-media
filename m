Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma01.mx.aol.com ([64.12.206.39]:60684 "EHLO
	imr-ma01.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1JQTA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Oct 2011 15:00:59 -0400
Received: from mtaout-ma02.r1000.mx.aol.com (mtaout-ma02.r1000.mx.aol.com [172.29.41.2])
	by imr-ma01.mx.aol.com (8.14.1/8.14.1) with ESMTP id p9HJ0shJ019883
	for <linux-media@vger.kernel.org>; Mon, 17 Oct 2011 15:00:54 -0400
Received: from [192.168.1.34] (unknown [190.50.38.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-ma02.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 8C465E00011E
	for <linux-media@vger.kernel.org>; Mon, 17 Oct 2011 15:00:53 -0400 (EDT)
Message-ID: <4E9C7B53.5010305@netscape.net>
Date: Mon, 17 Oct 2011 16:00:35 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 3.2] cx23885 alsa cleaned and prepaired
References: <201110101752.11536.liplianin@me.by> <4E9C3819.2000307@netscape.net>
In-Reply-To: <4E9C3819.2000307@netscape.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

El 17/10/11 11:13, Alfredo Jesús Delaiti escribió:
> Hi
>
> El 10/10/11 11:52, Igor M. Liplianin escribió:
>> Hi Mauro and Steven,
>>
> When compile, I get this error:
>
> dhcppc1:/usr/src/linux # make SUBDIRS=drivers/media/video/cx23885 
> modules -j2
>   Building modules, stage 2.
>   MODPOST 2 modules
> WARNING: "cx23885_risc_databuffer" 
> [drivers/media/video/cx23885/cx23885.ko] undefined!
>
> dhcppc1:/usr/src/linux # modprobe cx23885 debug=3 v4l_debug=3 i2c_scan=3
> FATAL: Error inserting cx23885 
> (/lib/modules/3.0.6-2-desktop/kernel/drivers/media/video/cx23885/cx23885.ko): 
> Unknown symbol in module, or unknown parameter (see dmesg)
>
> dmesg:
> ....
> [13447.629867] cx23885: Unknown symbol cx23885_risc_databuffer (err 0)
>
>
> I use kernel 3.0.6 and OpenSuse 11.4
>
>
I found the error. There are more spaces in the definition of 
cx23885_risc_databuffer.
Please correct them. They are in: 
http://git.linuxtv.org/liplianin/media_tree.git/tree/159b64f3415b9882e3391492255a60133b5fd080:/drivers/media/video/cx23885/

Thank

Alfredo

-- 
Dona tu voz
http://www.voxforge.org/es

