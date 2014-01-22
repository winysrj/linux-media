Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44444 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaAVPq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 10:46:28 -0500
Received: by mail-oa0-f47.google.com with SMTP id m1so629758oag.6
        for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 07:46:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140121122826.GA25490@pequod.mess.org>
References: <20140115173559.7e53239a@samsung.com>
	<1390246787-15616-1-git-send-email-a.seppala@gmail.com>
	<20140121122826.GA25490@pequod.mess.org>
Date: Wed, 22 Jan 2014 17:46:28 +0200
Message-ID: <CAKv9HNZzRq=0FnBH0CD0SCz9Jsa5QzY0-Y0envMBtgrxsQ+XBA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] rc: Adding support for sysfs wakeup scancodes
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 January 2014 14:28, Sean Young <sean@mess.org> wrote:
> On Mon, Jan 20, 2014 at 09:39:43PM +0200, Antti Seppälä wrote:
>> This patch series introduces a simple sysfs file interface for reading
>> and writing wakeup scancodes to rc drivers.
>>
>> This is an improved version of my previous patch for nuvoton-cir which
>> did the same thing via module parameters. This is a more generic
>> approach allowing other drivers to utilize the interface as well.
>>
>> I did not port winbond-cir to this method of wakeup scancode setting yet
>> because I don't have the hardware to test it and I wanted first to get
>> some comments about how the patch series looks. I did however write a
>> simple support to read and write scancodes to rc-loopback module.
>
> Doesn't the nuvoton-cir driver need to know the IR protocol for wakeup?
>
> This is needed for winbond-cir; I guess this should be another sysfs
> file, something like "wakeup_protocol". Even if the nuvoton can only
> handle one IR protocol, maybe it should be exported (readonly) via
> sysfs?
>
> I'm happy to help with a winbond-cir implementation; I have the hardware.
>
>
> Sean

Nuvoton-cir doesn't care about the IR protocol because the hardware
compares raw IR pulse lengths and wakes the system if received pulse
is within certain tolerance of the one pre-programmed to the HW. This
approach is agnostic to the used IR protocol.

I glanced over the winbond-cir driver and porting the driver to use
sysfs for wakeup scancodes looks doable. Also a new sysfs entry for
setting the wakeup protocol would indeed be needed... I will take a
closer look at this when I have some more time.

-Antti
