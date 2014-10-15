Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu004-omc2s14.hotmail.com ([65.55.111.89]:62097 "EHLO
	BLU004-OMC2S14.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932620AbaJOCTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 22:19:13 -0400
Message-ID: <BLU436-SMTP141969E0C35CB6AA7413886C5AA0@phx.gbl>
Date: Wed, 15 Oct 2014 12:19:05 +1000
From: serrin <serrin19@outlook.com>
MIME-Version: 1.0
To: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: Hauppauge HVR-2200 (saa7164) problems (on Linux Mint 17)
References: <543C5B34.5090002@outlook.com>	<BLU437-SMTP32BE04CD60AF807B75686C5AC0@phx.gbl> <CALzAhNUm53w65BJPgSitpVcf3VrUdTAX09quT4s+xtre24u1Hw@mail.gmail.com>
In-Reply-To: <CALzAhNUm53w65BJPgSitpVcf3VrUdTAX09quT4s+xtre24u1Hw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for that, it's working now. I didn't realise you had to apply the 
patch before building it, silly me.

Yours sincerely

serrin

On 14/10/2014 9:48 PM, Steven Toth wrote:
> Please keep the discussion on the mailing list at all times.
>
>> I couldn't figure out how to apply the patch using the patch file, so I
>> manually edited the file (drivers/media/pci/saa7164/saa7164-fw.c), but I
>> kept getting the image corrupt message.
> That's probably the issue. Assuming you have the patch applied and are
> using the firmware it will work for you.
>

