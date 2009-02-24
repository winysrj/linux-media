Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:56960 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZBXIN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 03:13:56 -0500
Received: by bwz5 with SMTP id 5so5537412bwz.13
        for <linux-media@vger.kernel.org>; Tue, 24 Feb 2009 00:13:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <37219a840902231457k20895709j7b9416a48128547e@mail.gmail.com>
References: <37843.1235429340@iinet.net.au>
	 <37219a840902231457k20895709j7b9416a48128547e@mail.gmail.com>
Date: Tue, 24 Feb 2009 09:13:53 +0100
Message-ID: <617be8890902240013h5f8e920dl51b335599b9c3177@mail.gmail.com>
Subject: Re: running multiple DVB cards successfully.. what do I need to
	know?? (major and minor numbers??)
From: Eduard Huguet <eduardhc@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: sonofzev@iinet.net.au, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
    Another way of controlling the numbering schema of your DVB
devices is to blacklist the modules (so udev doesn't load them)m and
then modprobing them manually at system startup. This is what I did
for my Nova T-500 and Avermedia A700.

Briefly (this is for Gentoo, running OpenRC):

In /etc/modprobe.d/blacklist:
blacklist saa7134                  # for Avermedia A700
blacklist dvb_usb_dib0700      # for Hauppauge Nova T-500

And in /etc/conf.d/modules:
modules_2_6="${modules_2_6} dvb_usb_dib0700"
modules_2_6="${modules_2_6} saa7134"


This way, udev doesn't load the modules automatically at startup,
which was causing a different reordering of the DVB devices on reboot
and from a cold boot (due to the delay caused by firmware loading on
the Nova-T). The modules are loaded sequentially now, and in the order
specified in /etc/conf.d/modules.

Best regards,
  Eduard

PS: I doubt this hardly solve your firmware problems, but at least it
might help you with device ordering.





2009/2/23 Michael Krufky <mkrufky@linuxtv.org>:
> On Mon, Feb 23, 2009 at 5:49 PM, sonofzev@iinet.net.au
> <sonofzev@iinet.net.au> wrote:
>> Some of you may have read some of my posts about an "incorrect firmware readback"
>> message appearing in my dmesg, shortly after a tuner was engaged.
>>
>> I have isolated this problem, but the workaround so far has not been pretty.
>> On a hunch I removed my Dvico Fusion HDTV lite card from the system, running now
>> only with the Dvico Fusion Dual Express.
>>
>> The issue has gone, I am not getting the kdvb process hogging cpu cycles and this
>> message has stopped.
>>
>> I had tried both letting the kernel (or is it udev) assign the major and minor
>> numbers and I had tried to manually set them via modprobe.conf (formerly
>> modules.conf, I don't know if this is a global change or specific to Gentoo)....
>>
>> I had the major number the same for both cards, with a separate minor number for
>> each of the three tuners, this seems to be the same.
>>
>> Is this how I should be setting up for 2 cards or should I be using some other
>> type of configuration.
>
> Allan,
>
> I recommend to use the 'adapter_nr' module option.  You can specify
> this option in modprobe.conf -- the name of this file is
> distro-specific.
>
> For instance, to make the dual card appear before the lite card:
>
> options cx23885 adapter_nr=0,1
> options dvb-bt8xx adapter_nr=2
>
> to make the lite card appear before the dual card:
>
> options cx23885 adapter_nr=0
> options dvb-bt8xx adapter_nr=1,2
>
> I hope you find this helpful.
>
> Regards,
>
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
