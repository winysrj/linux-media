Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:42817 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbZLRO5N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 09:57:13 -0500
Received: by yxe17 with SMTP id 17so2949022yxe.33
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2009 06:57:11 -0800 (PST)
Message-ID: <4B2B9842.6040108@gmail.com>
Date: Fri, 18 Dec 2009 12:57:06 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Paulo Assis <pj.assis@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Adaptec VideOh! DVD Media Center
References: <59cf47a80912180605o41708efao769d09d46b20a87e@mail.gmail.com> <829197380912180644y31f520fawee04a66ab28666e7@mail.gmail.com>
In-Reply-To: <829197380912180644y31f520fawee04a66ab28666e7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Fri, Dec 18, 2009 at 9:05 AM, Paulo Assis <pj.assis@gmail.com> wrote:
>> Hi,

>> Is there any simpler/standard way of handling these firmware uploads ?
>>
>> Regards,
>> Paulo
> 
> Hi Paulo,
> 
> I would start by looking at the request_firmware() function, which is
> used by a variety of other v4l cards.

Yes. Basically, you store all firmwares you need on /lib/firmware and 
request_firmware loads them when the driver is loaded. 

You don't need to add any extra udev magic for it to work, since there are
already some userspace programs that handle firmware requests when using
request_firmware().

Cheers,
Mauro.
