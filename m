Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:36307 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZFEIx6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 04:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <20090604225349.GA8453@suse.de>
References: <208cbae30905271051jfe3294bye415b5b4cd0ce14b@mail.gmail.com>
	 <208cbae30906041543v583b411ah4434e66acf83fa77@mail.gmail.com>
	 <20090604225349.GA8453@suse.de>
Date: Fri, 5 Jun 2009 12:54:00 +0400
Message-ID: <208cbae30906050154u5bae7f2cr7a06adb21171b292@mail.gmail.com>
Subject: Re: Probably strange bug with usb radio-mr800
From: Alexey Klimov <klimov.linux@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Linux Media <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 5, 2009 at 2:53 AM, Greg KH<gregkh@suse.de> wrote:
> On Fri, Jun 05, 2009 at 02:43:04AM +0400, Alexey Klimov wrote:
>> Is there any ideas about different behaviour of device on 32- and
>> 64-bit platforms with the same usb bulk messages?
>
> No, there should be no difference.
>
> Have you run usbmon to look at the data on the wire?

Of course, there is my first letter (from May 27) on usb and v4l mail
lists with usbmon output.
Here is the link http://www.spinics.net/lists/linux-media/msg06051.html

-- 
Best regards, Klimov Alexey
