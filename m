Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:23475 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbZHLNEe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 09:04:34 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1239426rvb.5
        for <linux-media@vger.kernel.org>; Wed, 12 Aug 2009 06:04:35 -0700 (PDT)
Cc: linux-media@vger.kernel.org
Message-Id: <CE7D00C2-9D6E-4DF9-A82A-9DA270CD22E9@dockerz.net>
From: Tim Docker <tim@dockerz.net>
To: Nicolas Will <nico@youplala.net>
In-Reply-To: <1249996315.30127.3.camel@youkaida>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [linux-dvb] problem: Hauppauge Nova TD500
Date: Wed, 12 Aug 2009 23:04:29 +1000
References: <4A8169D0.3030008@dockerz.net> <1249996315.30127.3.camel@youkaida>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 11/08/2009, at 11:11 PM, Nicolas Will wrote:

> On Tue, 2009-08-11 at 13:53 +0100, Tim Docker wrote:
>> Hi,
>>
>> I'm trying to diagnose a problem with a mythtv setup based upon a
>> hauppauge nova td 500. I've had the setup for some months - it seemed
>> to
>> work reasonably reliably initially, but over the last few weeks I've
>> had
>> consistent problems with the tuner card entering a state where it is
>> unable to receive a signal.

> This problem is most probably caused by the tuner being in USB suspend
> when MythTV wants to use it too quickly.
>
> Either disable usb suspend in your kernel, or tell mythtv to take wait
> some more before tuning.
>
> I told MythTV to wait some more, and all is fine.
>
> http://www.youplala.net/linux/home-theater-pc#toc-not-losing-one-of-the-nova-t-500s-tuners

Thanks - I've make the changes, and it's survived the first 24 hours,  
which is an improvement. Time will tell if the problem has really gone.

Tim
