Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1JPl6J-00037c-OP
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 21:54:35 +0100
Received: by fk-out-0910.google.com with SMTP id z22so497722fkz.1
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 12:54:35 -0800 (PST)
Message-ID: <37219a840802141254y12375e4dxd0e61cec97f8dc1a@mail.gmail.com>
Date: Thu, 14 Feb 2008 15:54:35 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Thomas Kaiser" <linux-dvb@kaiser-linux.li>
In-Reply-To: <47B4A69F.9020009@kaiser-linux.li>
MIME-Version: 1.0
Content-Disposition: inline
References: <47B4A69F.9020009@kaiser-linux.li>
Cc: _LinuxTV-DVB - Mailinglist <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [OT] request_firmware()
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thu, Feb 14, 2008 at 3:37 PM, Thomas Kaiser
<linux-dvb@kaiser-linux.li> wrote:
> Hello
>
>  I know this is the wrong list to ask, but you use this function (see subject)
>  and I think somebody can answer my question.
>
>  Why does request_firmware need a device as parameter?
>  int request_firmware(const struct firmware **fw, const char *name,
>                      struct device *device);
>
>  I thought request_firmware just loads the firmware in the struct firmware?


IIRC, when the device is destroyed, it is a signal for the memory used
to store the firmware to be freed if not done already.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
