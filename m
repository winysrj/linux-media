Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:41761 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759927Ab2FURLR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 13:11:17 -0400
Message-ID: <4FE355B2.50906@fisher-privat.net>
Date: Thu, 21 Jun 2012 19:11:14 +0200
From: Oleksij Rempel <bug-track@fisher-privat.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-uvc-devel@lists.sourceforge.net, linux-media@vger.kernel.org
Subject: Re: [linux-uvc-devel] [RFC] Media controller entity information ioctl
 [was "Re: [patch] suggestion for media framework"]
References: <4FCB9C12.1@fisher-privat.net> <9993866.a3VUSWRbyi@avalon> <CA+Dpati=kqq52JMu0gJBT=VeLGLXVgd3E-aY4YmfkXytMCDzyA@mail.gmail.com> <1915602.ON5YbSOUmP@avalon>
In-Reply-To: <1915602.ON5YbSOUmP@avalon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08.06.2012 04:46, Laurent Pinchart wrote:
> Hi Robert,
> 
> On Monday 04 June 2012 10:11:33 Robert Krakora wrote:
>> When you say "static" you mean items that are "well known" by the system by
>> reading a registry at initialization?
> 
> By static I mean items that are initialized at driver initialization time and 
> not modified afterwards. I don't think we should support adding/removing items 
> at runtime, at least in the first version.
> 
>> When a new device exposes functionality that necessitates the creation of a
>> new "static" item then how does the registry get updated to reflect this or
>> am I misunderstanding?
> 
> Item types should be defined in a kernel header and documented. If a driver 
> needs a new item types, the driver developer should add the new type to the 
> header and document it.

Hi Laurent,

what is your progress on this issue?

I was able to make video stream on my webcam work more stable by setting
"snd_usb_audio ignore_ctl_error=1". I think it is one of cases where
media framework should help.

-- 
Regards,
Oleksij
