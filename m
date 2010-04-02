Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34887 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0DBOYn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 10:24:43 -0400
Received: by gwb19 with SMTP id 19so158928gwb.19
        for <linux-media@vger.kernel.org>; Fri, 02 Apr 2010 07:24:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <r2z829197381004020659m8f31d527u12f7069d3cbacdca@mail.gmail.com>
References: <i2s6e8e83e21004020648n21b07894ma8ad2bf6757e83ff@mail.gmail.com>
	 <r2z829197381004020659m8f31d527u12f7069d3cbacdca@mail.gmail.com>
Date: Fri, 2 Apr 2010 22:24:42 +0800
Message-ID: <q2s6e8e83e21004020724xe5df6c55h27ac0606c6cc8a5f@mail.gmail.com>
Subject: Re: how does v4l2 driver communicate a frequency lock to mythtv
From: Bee Hock Goh <beehock@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks a lot for your advice! I will look into the g_tuner and signal function.

On Fri, Apr 2, 2010 at 9:59 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Fri, Apr 2, 2010 at 9:48 AM, Bee Hock Goh <beehock@gmail.com> wrote:
>> Dear all,
>>
>> i have been doing some usb snoop and making some changes to the
>> existing staging tm6000 to get my tm5600/xc2028 usb stick to work.
>> Thanks to a lot of help from Stefan, I have some limited success and
>> is able to get mythtv to do channel scan. However, mythtv is not able
>> to logon to the channel even though usbmon shown the same in/out using
>> usbmon and snoop on the stick windows application.
>>
>> Where should I be looking at to inform that a channel is to be locked?
>
> For most applications, the G_TUNER call must set the response struct
> v4l2_tuner's "signal" field to a nonzero value.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
