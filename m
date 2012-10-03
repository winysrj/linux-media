Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38142 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab2JCLJH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Oct 2012 07:09:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TJMon-0005bz-91
	for linux-media@vger.kernel.org; Wed, 03 Oct 2012 13:08:45 +0200
Received: from abmw50.neoplus.adsl.tpnet.pl ([83.7.242.50])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2012 13:08:45 +0200
Received: from acc.for.news by abmw50.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2012 13:08:45 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: ITE9135 on AMD SB700 - ehci_hcd bug
Date: Wed, 03 Oct 2012 12:55:11 +0200
Message-ID: <f5itj9-4o9.ln1@wuwek.kopernik.gliwice.pl>
References: <ksm5i9-2t1.ln1@wuwek.kopernik.gliwice.pl> <5055E0ED.8030808@iki.fi> <505F3750.8070104@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <505F3750.8070104@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23.09.2012 18:22, Antti Palosaari wrote:
> On 09/16/2012 05:23 PM, Antti Palosaari wrote:
>> On 09/12/2012 09:32 AM, Marx wrote:
>>> Hello
>>> I'm trying to use dual DVB-T tuner based on ITE9135 tuner. I use Debian
>>> kernel 3.5-trunk-686-pae. My motherboard is AsRock E350M1 (no USB3
>>> ports).
>>> Tuner is detected ok, see log at the end of post.
>>>
>>> When I try to scan channels, bug happens:
>>> Sep 11 17:16:31 wuwek kernel: [ 209.291329] ehci_hcd 0000:00:13.2:
>>> force halt; handshake f821a024 00004000 00000000 -> -110
>>> Sep 11 17:16:31 wuwek kernel: [ 209.291401] ehci_hcd 0000:00:13.2: HC
>>> died; cleaning up
>>> Sep 11 17:16:31 wuwek kernel: [ 209.291606] usb 2-3: USB disconnect,
>>> device number 2
>>> Sep 11 17:16:41 wuwek kernel: [ 219.312848] dvb-usb: error while
>>> stopping stream.
>>> Sep 11 17:16:41 wuwek kernel: [ 219.320585] dvb-usb: ITE 9135(9006)
>>> Generic successfully deinitialized and disconnected.
>>>
>>> After trying many ways I've read about problems with ehci on SB700 based
>>> boards and switched off ehci via command
>>> sh -c 'echo -n "0000:00:13.2" > unbind'
>>> and now ehci bug doesn't happen. Of course I can see only one tuner and
>>> in slower USB mode (see log at the end). But now I can scan succesfully
>>> without any errors.
>>>
>>> Of course it isn't acceptable fix for my problem. Drivers for ITE9135
>>> seems ok, but there is a problem with ehci_hcd on my motherboard.
>>> I would like to know what can I do to fix my problem.
>>
>> I am quite sure dvb_usb_v2 fixes that. Test latest tree.
>>
>> Antti
>>
>
> Test results please?

I've replaced motherboard (no AMD chipset) and this problem disappeared. 
Unfortunatelly there were some problem with newsgate on gmane and I 
didn't receive your reply on time. Now I don't have this motherboard, 
but I can confirm ITE9135 drivers now works ok, so this problem was with 
USB driver.

Now I have some small problem with ITE9135 driver. I use dual tuner.
When I restart computer while the card is connected then disconnect and 
connect card again, I have four devices in /dev/dvb instead of two.
Is it known bug and is fixed or I should attach some logs?
Marx

