Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:52329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab0IPVUD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 17:20:03 -0400
Message-ID: <4C9289FD.8030004@redhat.com>
Date: Thu, 16 Sep 2010 18:19:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?4pyOxqZhZmFlbCBWaWVpcmHimaY=?= <rafastv@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hello and question about firmwares
References: <AANLkTi=7fPmqkkhGpPEXP9b6od+QRMTF_Xwh-i=BjEku@mail.gmail.com>	<AANLkTi=C5vbVqcDe1JDcz7WxRRO3YeL-RKwQh5Bpv79G@mail.gmail.com> <AANLkTi=otOpFHMGKg9=wkMZKgY_KHOkBDAUq93-18fzb@mail.gmail.com>
In-Reply-To: <AANLkTi=otOpFHMGKg9=wkMZKgY_KHOkBDAUq93-18fzb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Rafael,

Em 16-09-2010 13:56, ✎Ʀafael Vieira♦ escreveu:
> I realize now that I was kind of fast foward :) So nice to meet you all.
> I hope someday, I'm able to help you guys.
> Let me give you some more data from the device, although is not
> directly related to my questions.
> 
> The two devices:
> 
> http://www.pixelview.com.br/play_tv_usb_sbtvd_fullseg.asp (works already)
> 
> http://www.pixelview.com.br/playtv_usb_hybrid.asp (I'm trying to get it to work)

They are completely independent devices. One uses dib0700, while the other uses cx23102,
plus a Fujitsu frontend. The second one is not supported. I wrote a patch to fix the
auto-detection issues between them a few days ago on my -git tree. Eventually, analog
support for s-video/composite will work, but analog or digital TV won't work. I need
to get one of those in order to fix the analog TV. For digital, it is more complicated,
as we don't have any info about the Fujitsu chip yet.

Abraços,
Mauro.
