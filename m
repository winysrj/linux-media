Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1JvAn4-0001IZ-6P
	for linux-dvb@linuxtv.org; Sun, 11 May 2008 14:36:34 +0200
Received: by yw-out-2324.google.com with SMTP id 3so1309266ywj.41
	for <linux-dvb@linuxtv.org>; Sun, 11 May 2008 05:36:20 -0700 (PDT)
Message-ID: <37219a840805110536h300b2b6eq699ab09d5b1fc220@mail.gmail.com>
Date: Sun, 11 May 2008 08:36:20 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Quentin Anciaux" <allcolor@gmail.com>
In-Reply-To: <57da2dd30805110344u629351e1mb23cc249ffbdde52@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <57da2dd30805110344u629351e1mb23cc249ffbdde52@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Wintv hvr-1200 hybrid cx23885
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sun, May 11, 2008 at 6:44 AM, Quentin Anciaux <allcolor@gmail.com> wrote:
> Hi,
>
> I've got a problem with my tv card hybrid hvr-1200. I've taken the latest
> v4l-dvb from the site, the card is recognized as I can see in dmesg, I have
> devices node created in /dev/dvb/adapter0/. But I've got no device
> /dev/video0.
>
> My question is, do my setup is erroneous or there is only digital support
> for this card on linux ?

The linux driver for this card currently supports digital tv, only.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
