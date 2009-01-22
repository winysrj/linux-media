Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:11691 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754255AbZAVXWt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 18:22:49 -0500
Message-ID: <4978FFC1.4010301@ziv.id.au>
Date: Fri, 23 Jan 2009 09:52:41 +1030
From: Andy Zivkovic <andy@ziv.id.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org, linuxtv.org@jks.tupari.net
Subject: Re: [linux-dvb] device file ordering w/multiple cards
References: <alpine.LFD.2.00.0901221641300.8219@tupari.net>
In-Reply-To: <alpine.LFD.2.00.0901221641300.8219@tupari.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Joseph Shraibman wrote:
> I have two dvb cards in my system.  Is there any way to change the order 
> of the device files?

If the different cards use different drivers, you can pass the 
adapter_nr parameter to the module.

In my /etc/modprobe.conf I have:
options dvb_usb_dib0700 adapter_nr=0,1,2,3
options mantis adapter_nr=4


Andy
