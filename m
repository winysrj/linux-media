Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56518 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1HSCNa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 22:13:30 -0400
Received: by ywf7 with SMTP id 7so1918394ywf.19
        for <linux-media@vger.kernel.org>; Thu, 18 Aug 2011 19:13:29 -0700 (PDT)
Message-ID: <4E4DC6C3.1000800@gmail.com>
Date: Fri, 19 Aug 2011 14:13:23 +1200
From: CJ <cjpostor@gmail.com>
MIME-Version: 1.0
To: javier Martin <javier.martin@vista-silicon.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Koen Kooi <koen@beagleboard.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, mch_kot@yahoo.com.cn
Subject: Re: [beagleboard] Re: [PATCH v7 1/2] Add driver for Aptina (Micron)
 mt9p031 sensor.
References: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com> <BANLkTinw6GoHgQYqJexbD-4=qitP6j0hDg@mail.gmail.com> <51BA5835-2D1F-4BD3-B5BF-B01B339C347E@beagleboard.org> <201106081824.46027.laurent.pinchart@ideasonboard.com> <BANLkTinqZ5xbTG=h+64rxVui=kXjjtehig@mail.gmail.com>
In-Reply-To: <BANLkTinqZ5xbTG=h+64rxVui=kXjjtehig@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to get the mt9p031 working from nand with a ubifs file 
system and I am having a few problems.

/dev/media0 is not present unless I run:
#mknod /dev/media0 c 251 0
#chown root:video /dev/media0

#media-ctl -p
Enumerating entities
media_open: Unable to enumerate entities for device /dev/media0 
(Inappropriate ioctl for device)

With the same rig/files it works fine running from EXT4 on an SD card.
Any idea why this does not work on nand with ubifs?

Regards,
CJ

On 13/06/11 22:39, javier Martin wrote:
> On 8 June 2011 18:24, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com>  wrote:
>> That works much better, thank you.
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
> So, how is it going?
>
> Are you finally accepting the patches for mainline?
>
> Thank you,
>
