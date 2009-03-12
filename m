Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:62532 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZCLWEj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 18:04:39 -0400
Message-ID: <49B986F3.9010805@kaiser-linux.li>
Date: Thu, 12 Mar 2009 23:04:35 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: mailinglist@august.de
Subject: Re: [linux-dvb] getting started
References: <49B982A5.7010103@august.de>
In-Reply-To: <49B982A5.7010103@august.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rolf Schumacher wrote:
> I once had my TechnoTrend DVB-C driver working with linux, looking tv.
> However, completely forgot how I managed that.
> 
> I think I was following the wiki
> 
> How to Obtain, Build and Install V4L-DVB Device Driver
> 
> I checked out the v4l-dvb sources using Mercurial.
> However, a make failed immediately:
> 
> ------------
> make -C /home/rsc/src/v4l-dvb/v4l
> make[1]: Entering directory `/home/rsc/src/v4l-dvb/v4l'
> Updating/Creating .config
> Preparing to compile for kernel version 2.6.28
> File not found: /lib/modules/2.6.28-7.slh.3-sidux-686/build/.config at
> ./scripts/make_kconfig.pl line 32, <IN> line 4.
> make[1]: *** Keine Regel vorhanden, um das Target ».myconfig«,
>   benötigt von »config-compat.h«, zu erstellen.  Schluss.
> make[1]: Leaving directory `/home/rsc/src/v4l-dvb/v4l'
> make: *** [all] Fehler 2
> -----------
> 
> Am I on the right track?
> If so, what is missing?

Kernel-headers and/or source installed?

Thomas
