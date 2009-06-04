Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:63468 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZFDWnD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 18:43:03 -0400
MIME-Version: 1.0
In-Reply-To: <208cbae30905271051jfe3294bye415b5b4cd0ce14b@mail.gmail.com>
References: <208cbae30905271051jfe3294bye415b5b4cd0ce14b@mail.gmail.com>
Date: Fri, 5 Jun 2009 02:43:04 +0400
Message-ID: <208cbae30906041543v583b411ah4434e66acf83fa77@mail.gmail.com>
Subject: Re: Probably strange bug with usb radio-mr800
From: Alexey Klimov <klimov.linux@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there any ideas about different behaviour of device on 32- and
64-bit platforms with the same usb bulk messages?
Any input is welcome.

On Wed, May 27, 2009 at 9:51 PM, Alexey Klimov<klimov.linux@gmail.com> wrote:

[...]

> So, the same messages to device works fine with radio on 32bit machine
> and nothing on 64bit machine.
> Good thing is if i add one more start message radio works on 64bit machine also.
>
> Is this usb subsystem bug?
> Should i make some workaround to deal with this and add comments about mplayer?


-- 
Best regards, Klimov Alexey
