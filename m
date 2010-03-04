Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:48643 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0CDBAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 20:00:23 -0500
Received: by ewy20 with SMTP id 20so1427966ewy.21
        for <linux-media@vger.kernel.org>; Wed, 03 Mar 2010 17:00:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197381003031548n703f0bf9sb44ce3527501c5c0@mail.gmail.com>
References: <74fd948d1003031535r1785b36dq4cece00f349975af@mail.gmail.com>
	 <829197381003031548n703f0bf9sb44ce3527501c5c0@mail.gmail.com>
Date: Thu, 4 Mar 2010 01:00:22 +0000
Message-ID: <74fd948d1003031700h187dbfd0v3f54800e652569b@mail.gmail.com>
Subject: Re: Excessive rc polling interval in dvb_usb_dib0700 causes
	interference with USB soundcard
From: Pedro Ribeiro <pedrib@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3 March 2010 23:48, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> On Wed, Mar 3, 2010 at 6:35 PM, Pedro Ribeiro <pedrib@gmail.com> wrote:
>> Hello all,
>>
>> yesterday I sent a message asking for help with a problem I was having
>> with a dib0700 USB adapter and my USB audio soundcard.
>>
>> Basically I discovered that the remote control polling in dvb_usb
>> module was causing it. For reference, my original message is here
>> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/16782
>> and I also file a kernel bug here
>> http://bugzilla.kernel.org/show_bug.cgi?id=15430
>>
>> Looking at dmesg when I plug the DVB adapter it says
>> dvb-usb: schedule remote query interval to 50 msecs.
>>
>> This seemed to me extremely excessive, so I solved the problem by
>> doing a quick dirty hack. In linux/drivers/media/dvb/dvb-usb-remote.c
>> I changed d->props.rc_interval to 10000, instead of the default 50
>> msec.
>>
>> So now when I load the driver, I get
>> dvb-usb: schedule remote query interval to 10000 msecs.
>>
>> And not only the USB audio card is working properly with the DVB
>> adapter but also the remote control is working perfectly, without any
>> delay at all!
>>
>> So my question is: why is this set to an excessive 50 msec? This is
>> waaaaaaay too much for remote control polling, and its proven it
>> causes trouble in the USB bus!
>> Also, I know my hack was dirty, what the is the proper way to change this?
>
> It's already been fixed.  Just update to the latest v4l-dvb code.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

Its working very well, thanks.

Can you please tell me if its going to be pushed to .33 stable? And
should I close the kernel bug?

Thanks,
Pedro
