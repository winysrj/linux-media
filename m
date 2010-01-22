Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:53176 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab0AVDPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 22:15:42 -0500
Received: by fxm23 with SMTP id 23so841718fxm.38
        for <linux-media@vger.kernel.org>; Thu, 21 Jan 2010 19:15:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f74f98341001211842y6dabbe97s1d7c362bac2d87b8@mail.gmail.com>
References: <f74f98341001211842y6dabbe97s1d7c362bac2d87b8@mail.gmail.com>
Date: Fri, 22 Jan 2010 07:15:40 +0400
Message-ID: <1a297b361001211915i120c31e8se244231ddae2d52f@mail.gmail.com>
Subject: Re: About MPEG decoder interface
From: Manu Abraham <abraham.manu@gmail.com>
To: Michael Qiu <fallwind@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, Jan 22, 2010 at 6:42 AM, Michael Qiu <fallwind@gmail.com> wrote:
> Hi all,
>
>  How can I export my MPEG decoder control interface to user space?
>  Or in other words, which device file(/dev/xxx) should a proper
> driver for mpeg decoder provide?

The AV7110 based and the STi7109 based PCI and PCIe devices use
/dev/dvb/adapterX/videoY and
/dev/dvb/adapterX/osdY and
/dev/dvb/adapterX/audioY

You can find the relevant headers in include/dvb/video.h, audio.h and osd.h

>  And, in linux dvb documents, all the frontend interface looks like
> /dev/dvb/adapter/xxx, it looks just for PCI based tv card.
>  If it's not a TV card, but a frontend for a embedded system without
> PCI, which interface should I use?

The decoder interface is different from the frontend interface.


Regards,
Manu
