Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:60366 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0A2GWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 01:22:42 -0500
Message-ID: <4B627EAE.7020303@freemail.hu>
Date: Fri, 29 Jan 2010 07:22:38 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: David Henig <dhhenig@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Make failed - standard ubuntu 9.10
References: <4B62113E.40905@googlemail.com>
In-Reply-To: <4B62113E.40905@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Henig wrote:
> Please can someone assist, not sure what the cause of the below is? This 
> is my second attempt to get linux tv to work, I suspect it's a basic 
> level error - sorry I'm fairly new to Linux... output below, I'm running 
> a fairly standard ubuntu 9.10 setup.
> 
> make[1]: Entering directory `/home/david/v4l-dvb/v4l'
> Updating/Creating .config
> Preparing to compile for kernel version 2.6.31
> File not found: /lib/modules/2.6.31-17-generic/build/.config at 
> ./scripts/make_kconfig.pl line 32, <IN> line 4.
> make[1]: *** No rule to make target `.myconfig', needed by 
> `config-compat.h'. Stop.
> make[1]: Leaving directory `/home/david/v4l-dvb/v4l'
> make: *** [all] Error 2

I think you don't have the kernel development files installed.

The recommended reading would be:
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

Regards,

	Márton Németh
