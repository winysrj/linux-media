Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:39024 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZLCWDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 17:03:12 -0500
Received: by fxm21 with SMTP id 21so2012527fxm.1
        for <linux-media@vger.kernel.org>; Thu, 03 Dec 2009 14:03:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <41ef408f0912031347j6b9a704flc6d9c302f4e0517@mail.gmail.com>
References: <1259695756.5239.2.camel@desktop>
	 <loom.20091202T230047-299@post.gmane.org>
	 <37219a840912021508s75535fa6v83006d3bad0c301@mail.gmail.com>
	 <1259874920.2151.13.camel@desktop>
	 <41ef408f0912031347j6b9a704flc6d9c302f4e0517@mail.gmail.com>
Date: Thu, 3 Dec 2009 17:03:16 -0500
Message-ID: <829197380912031403l6b828821q87f407fa95bc25f9@mail.gmail.com>
Subject: Re: af9015: tuner id:179 not supported, please report!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bert Massop <bert.massop@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 3, 2009 at 4:47 PM, Bert Massop <bert.massop@gmail.com> wrote:
> Hi Jan,
>
> The datasheet for the TDA18218 can be obtained from NXP:
> http://www.nxp.com/documents/data_sheet/TDA18218HN.pdf
>
> That's all the information I have at the moment, maybe Mike has some
> other information (like the Application Note mentioned in the
> datasheet, that claims to contain information on writing drivers, but
> cannot be found anywhere).
>
> Best regards,
>
> Bert

Took a quick look at that datasheet.  I would guess between that
datasheet and a usbsnoop, there is probably enough there to write a
driver that basically works for your particular hardware if you know
what you are doing.  The register map is abbreviated, but probably
good enough...

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
