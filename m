Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:59872 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886AbZJODdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 23:33:05 -0400
Received: by fxm27 with SMTP id 27so567769fxm.17
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 20:32:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255576352.5829.16.camel@palomino.walls.org>
References: <4AD591BB.80607@onelan.com>
	 <1255516547.3848.10.camel@palomino.walls.org>
	 <4AD5AFA6.8080401@onelan.com>
	 <1255576352.5829.16.camel@palomino.walls.org>
Date: Wed, 14 Oct 2009 23:32:27 -0400
Message-ID: <829197380910142032s71924b24k8eb87d2982fce53b@mail.gmail.com>
Subject: Re: Poor reception with Hauppauge HVR-1600 on a ClearQAM cable feed
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: Simon Farnsworth <simon.farnsworth@onelan.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 14, 2009 at 11:12 PM, Andy Walls <awalls@radix.net> wrote:
> On Wed, 2009-10-14 at 12:01 +0100, Simon Farnsworth wrote:
>> Andy Walls wrote:
>> > Have your remote user read
>> >
>> > http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality
>> >
>> > and take any actions that seem appropriate/easy.
>> >
>> I'll try that again - they're grouching, because their TV is fine, and
>> the same card in a Windows PC is also fine. It's just under Linux that
>> they're seeing problems, so I may not be able to get them to co-operate.
>
>
> Right, the windows driver code for the mxl5005s is better.  Inform him
> that the linux driver for the mxl5005s could be better.  If he has any
> contacts at MaxLinear to get the datasheet and programming manual
> released to me, I can make the linux driver better.

I've got the datasheet.  It's just one of those projects on my list
where I have to get around to hooking up the i2c analyzer to a running
board, capture the block that gets programmed into the chip under
Windows, and compare the bits against Linux.

I've just been tied up in too much other stuff to do the legwork required.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
