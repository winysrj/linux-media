Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58530 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2EWJkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:40:07 -0400
Received: by ghrr11 with SMTP id r11so1137035ghr.19
        for <linux-media@vger.kernel.org>; Wed, 23 May 2012 02:40:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201205231121.43359.hverkuil@xs4all.nl>
References: <CAAfyv36ejCC1EZH3VyH4B+8UcBAvdYgpWc3=o6K6Bv5HU4V=mg@mail.gmail.com>
	<201205231121.43359.hverkuil@xs4all.nl>
Date: Wed, 23 May 2012 11:40:06 +0200
Message-ID: <CAAfyv34=M1dUSNgYDD=TtYGKzrp_QbwgNf7dYJPHAYFe0Fckbw@mail.gmail.com>
Subject: Re: FM si4712 driver
From: Belisko Marek <marek.belisko@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 23, 2012 at 11:21 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Wed 23 May 2012 11:09:04 Belisko Marek wrote:
>> Hi,
>>
>> I'm planning to start writing driver for si4712 (for GTA04).
>> Anybody doing same thing to avoid double work?
>
> There is a driver for the si4713 already. Is the si4712 very different from
> the si4713? If it is very similar, then I would suggest that you adapt the
> si4713 driver to also support the si4712.
Ups typo: it's not si4712 but si4721 (transceiver). Sorry for that.
>
> Regards,
>
>        Hans

Regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
