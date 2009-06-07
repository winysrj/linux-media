Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:63728 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZFGNlM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 09:41:12 -0400
MIME-Version: 1.0
In-Reply-To: <200906062307.14730.oliver@neukum.org>
References: <208cbae30905271051jfe3294bye415b5b4cd0ce14b@mail.gmail.com>
	 <208cbae30906041543v583b411ah4434e66acf83fa77@mail.gmail.com>
	 <200906062307.14730.oliver@neukum.org>
Date: Sun, 7 Jun 2009 17:41:13 +0400
Message-ID: <208cbae30906070641j12cc04c1vcaf28f31b38e8e1e@mail.gmail.com>
Subject: Re: Probably strange bug with usb radio-mr800
From: Alexey Klimov <klimov.linux@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Linux Media <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Sun, Jun 7, 2009 at 1:07 AM, Oliver Neukum<oliver@neukum.org> wrote:
> Am Freitag, 5. Juni 2009 00:43:04 schrieb Alexey Klimov:
>> Is there any ideas about different behaviour of device on 32- and
>> 64-bit platforms with the same usb bulk messages?
>> Any input is welcome.
>
> Are you running a 32 bit userland? If so, ioctls could be critical.

Two different machines. The answer is no.

> If not, the driver may not be 64bit clean. Which driver is affected?

media/radio/radio-mr800.c
Please, also take a look in my first letter to usb and v4l mail lists
from May 27.

-- 
Best regards, Klimov Alexey
