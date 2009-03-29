Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:59966 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZC2Lo1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 07:44:27 -0400
Received: from pub6.ifh.de (pub6.ifh.de [141.34.15.118])
	by znsun1.ifh.de (8.12.11.20060614/8.12.11) with ESMTP id n2TBiJMC029292
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 13:44:20 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])
	by pub6.ifh.de (Postfix) with ESMTP id D62D23000F2
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 13:44:19 +0200 (CEST)
Date: Sun, 29 Mar 2009 13:44:19 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Patch for Yuan MC770 DVB-T (1164:0871)
In-Reply-To: <47310330903101454h4fa1362axe2dbd61804093a76@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0903291343430.18473@pub6.ifh.de>
References: <47310330903061303l338d5eb5nf3c8d4f3bcde0bdd@mail.gmail.com> <47310330903101454h4fa1362axe2dbd61804093a76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Xoan,

On Tue, 10 Mar 2009, x04n 2.0 wrote:

> Hi,
> 
> I've recently buyed a Toshiba Qosmio F50-10Q with a Yuan MC770 DVB-T (1164:0871) and I tried to make it work,
> operation which ended quite satisfactory.
> 
> So i would like to share my patch with your team.
> 
> I'm running Linux kernel 2.6.28, using distro Debian Lenny and Kaffeine as a TV viewer.
> 
> I've downloaded the actual status of the mercurial at http://linuxtv.org/hg/v4l-dvb and modified the source to add this device.
> 
> So I compiled the drivers and did overwrite (make install) the current kernel modules.
> 
> I placed the firmware files dvb-usb-dib0700-1.20.fw and xc3028-v27.fw in /lib/firmware.
> 
> So now everything is working quite fine.

Thanks for the patch. Applied.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
