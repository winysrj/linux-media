Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38830 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbbFPLJL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 07:09:11 -0400
Received: by wibdq8 with SMTP id dq8so15813723wib.1
        for <linux-media@vger.kernel.org>; Tue, 16 Jun 2015 04:09:10 -0700 (PDT)
Message-ID: <558003D7.1080906@gmail.com>
Date: Tue, 16 Jun 2015 12:09:11 +0100
From: Andy Furniss <adf.lists@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"Gabor Z. Papp" <gzpapp.lists@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx problem with 3.10-4.0
References: <x6d212hdgj@gzp>	<x6d20wi1ml@gzp> <20150616062056.34b4d4ef@recife.lan>
In-Reply-To: <20150616062056.34b4d4ef@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em Tue, 16 Jun 2015 08:54:58 +0200 "Gabor Z. Papp"
> <gzpapp.lists@gmail.com> escreveu:
>
>> * "Gabor Z. Papp" <gzpapp.lists@gmail.com>:
>>
>> | I would like to use my Pinnacle Dazzle DVC usb encoder with
>> kernels | 3.10-4.0, but I'm getting the same error all the time.
>>
>> | Latest working kernel is the 3.4 line.
>>
>> | What happend with the driver?
>
> Nothing. You just ran out of continuous memory. This driver requires
> long chunks of continuous memory for USB data transfer.
>
> Please see this thread:
> http://www.spinics.net/lists/linux-media/msg43868.html
>
> As far as I remember, some things changed from 3.4 on the part that
> allocates memory there, reducing the risk of getting out of memory,
> but can't remember the specific details anymore.

Oh interesting - I only recently stopped using the low mem box in that
post. I think I ended up on kernel 3.9 and had uptimes of > 200 days
without issue.

I still have the 290e but now on a box with 4 gig ram - haven't had time
to see if I'll hit it again with 4.1.

My use case was dvb not analogue.

If you just want to plug and cap something you may be able to workaround
by first, as root, doing -

sync;echo 3 >/proc/sys/vm/drop_caches

to clean out men.



