Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:52711 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab0BWOuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 09:50:35 -0500
Received: by fxm19 with SMTP id 19so3886140fxm.21
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 06:50:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266935667.4589.27.camel@palomino.walls.org>
References: <829000.26472.qm@web57006.mail.re3.yahoo.com>
	 <1266935667.4589.27.camel@palomino.walls.org>
Date: Tue, 23 Feb 2010 18:50:33 +0400
Message-ID: <1a297b361002230650u42e86976j7b5373ef04d6322@mail.gmail.com>
Subject: Re: [linux-dvb] soft demux device
From: Manu Abraham <abraham.manu@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 23, 2010 at 6:34 PM, Andy Walls <awalls@radix.net> wrote:
> On Tue, 2010-02-23 at 05:12 -0800, ozgur cagdas wrote:
>> Hi All,
>>
>> I have just compiled v4l-dvb successfully. My aim is to develop some
>> experimental dvb applications on top of this dvb kernel api.
>> Initially, I do not want to use any hardware and would like to play
>> with the recorded ts files I have. So, is there any software demux
>> device available within this package or somewhere else?
>
> I do not know.  You could write a simple dvb_dummy driver module.  The
> existing dvb_dummy_fe module would be helpful in such an endeavor, I
> suppose.

Indeed, that's the right way :-)

Regards,
Manu
