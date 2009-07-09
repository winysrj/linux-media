Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay02.cambriumhosting.nl ([217.19.16.174]:34917 "EHLO
	relay02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756559AbZGILvC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2009 07:51:02 -0400
Message-ID: <4A55D9A3.4070502@powercraft.nl>
Date: Thu, 09 Jul 2009 13:50:59 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Call for testers: Terratec Cinergy T XS USB support
References: <829197380906290700n16a0f4faxd29caa12587222f7@mail.gmail.com> <4A4E220B.8090800@powercraft.nl>
In-Reply-To: <4A4E220B.8090800@powercraft.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jelle de Jong schreef:
> Devin Heitmueller wrote:
>> Hello all,
>>
>> A few weeks ago, I did some work on support for the Terratec Cinergy T
>> XS USB product.  I successfully got the zl10353 version working and
>> issued a PULL request last week
>> (http://www.kernellabs.com/hg/~dheitmueller/em28xx-terratec-zl10353)
>>
>> However, the other version of the product, which contains a mt352 is
>> not yet working.
>>
>> I am looking for people who own the device and would be willing to do
>> testing of a tree to help debug the issue.  Ideal candidates should
>> have the experience using DVB devices under Linux in addition to some
>> other known-working tuner product so we can be sure that certain
>> frequencies are available and that the antenna/location work properly.
>>  If you are willing to provide remote SSH access for short periods of
>> time if necessary, also indicate that in your email.
>>
>> Please email me if you are interested in helping out getting the device working.
>>
>> Thank you,
>>
>> Devin
>>
> 
> Not much time to do the actual coding and compiling but I will set you
> up with :-)
> 
> I will get you a dedicated machine with ssh access you can play with as
> much as you like, it will be up and running next week after Wednesday.
> 
> Have you ever heard of ssh gateways, I am kind of good at this I build
> my support systems around this. So I will set you up with an account :D

As said I made you a very nice dvb-t test station, you can log into it
with a ssh gateway that I created for you. There are several usb dvb-t
en hybrid devices attached, all with dvb-t signals, analog is also possible.

I send you an additional private email with the information you need to
login into the systems. You have full root access and can compile what
ever you want ;-p

If you got any question you can contact me on IRC with the nickname
tuxcrafter or use the pct-support-chat[1] tool.

Best regards,

Jelle de Jong

[1]
https://secure.powercraft.nl/svn/packages/trunk/source/pct-support-scripts/
