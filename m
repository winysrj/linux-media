Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51890 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1JZTnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Oct 2011 15:43:50 -0400
Received: by bkbzt19 with SMTP id zt19so1937055bkb.19
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2011 12:43:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EA85EE1.7080807@lockie.ca>
References: <4EA85EE1.7080807@lockie.ca>
Date: Wed, 26 Oct 2011 15:43:48 -0400
Message-ID: <CAGoCfiwTJ4Gepz5+VH7uRaAyX5fRLQnpOe0SD6Fgo3EnvL8_sA@mail.gmail.com>
Subject: Re: cx23885[0]: videobuf_dvb_register_frontend failed (errno = -12)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: James <rjl@lockie.ca>
Cc: linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 26, 2011 at 3:26 PM, James <rjl@lockie.ca> wrote:
> *I compiled kernel-3.1 and now my tuner card fails:
>
>> $ dmesg | grep cx
>> cx23885 driver version 0.0.3 loaded
>> cx23885 0000:03:00.0: PCI INT A -> Link[LNEA] -> GSI 16 (level, low) ->
>> IRQ 16
>> CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250
>> [card=3,autodetected]
>> cx23885[0]: hauppauge eeprom: model=79571
>> cx23885_dvb_register() allocating 1 frontend(s)
>> cx23885[0]: cx23885 based dvb card
>> DVB: registering new adapter (cx23885[0])
>> cx23885[0]: videobuf_dvb_register_frontend failed (errno = -12)
>> cx23885_dvb_register() dvb_register failed err = -22
>> cx23885_dev_setup() Failed to register dvb on VID_C
>> cx23885_dev_checkrevision() Hardware revision = 0xb0
>> cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 16, latency: 0, mmio:
>> 0xf9e00000
>> cx23885 0000:03:00.0: setting latency timer to 64
>
> **cx23885[0]: videobuf_dvb_register_frontend failed (errno = -12)
> **Where can I look up what errno  -12 is?

James,

This appears to be occurring on a cx88 board as well, suggesting some
problem in the framework.  It is being actively discussed in #linuxtv
on freenode.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
