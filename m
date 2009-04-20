Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:35401 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbZDTVwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 17:52:49 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KIF0042563NBZT0@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 20 Apr 2009 17:52:36 -0400 (EDT)
Date: Mon, 20 Apr 2009 17:52:35 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
In-reply-to: <1240259904.5388.178.camel@mountainboyzlinux0>
To: pghben@yahoo.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Steven Toth <stoth@linuxtv.org>
Message-id: <49ECEEA3.6010203@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <23cedc300904170207w74f50fc1v3858b663de61094c@mail.gmail.com>
 <BAY102-W34E8EA79DEE83E18177655CF7B0@phx.gbl> <49E9C4EA.30706@linuxtv.org>
 <loom.20090420T150829-849@post.gmane.org> <49EC9A08.50603@linuxtv.org>
 <1240245715.5388.126.camel@mountainboyzlinux0> <49ECA8DD.9090708@linuxtv.org>
 <1240249684.5388.146.camel@mountainboyzlinux0> <49ECBCF0.3060806@linuxtv.org>
 <1240255677.5388.153.camel@mountainboyzlinux0> <49ECD553.9090707@linuxtv.org>
 <1240259904.5388.178.camel@mountainboyzlinux0>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Benster & Jeremy wrote:
> On Mon, 2009-04-20 at 16:04 -0400, Steven Toth wrote:
>>>> So, under MCE find a major network ABC, NBC or CBS that works perfectly for you 
>>>> then locate the RF channel on antenna web.org.
>>> These all come in fine on mce.
>>>
>>> KDKA-DT    2.1    25
>>> WTAE-DT    4.1    51
>>> WQED-DT 13.1    38
>> (Rule #2, always CC the mailing list. Don't drop them off, even by accident. An 
>> honest mistake on your part so I've added them back in.)
>>
>> Modify your $HOME/.azap/channels.conf to look like this:
>>
>> ch25:539000000:8VSB:65:68:4
>> ch38:614000000:8VSB:65:68:4
>> ch51:695000000:8VSB:65:68:4
>>
>> The use the following command to tune ch25:
>>
>> azap -r ch25
>>
>> What happens next?
>>
>> - Steve
>>
> No indicator light - I know this is probably just a bit set somewhere
> that turns on/off the light and has nothing to do with actual operation
> of the card, but thought I would mention it.
> 
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 539000000 Hz
> video pid 0x0041, audio pid 0x0044
> status 00 | signal 7fe2 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 008c | snr 0082 | ber 00000000 | unc 00000000 |
> ....last line repeats indefinitely.....I hit ^c.
> 
> tried a second time - now all lines match last line and again I hit ^c.
> also the same as the second line for the other two channels.
> 
> Something I forgot to mention, if you remove the card with the system
> running linux it results in a freeze with a blinking caps lock led (btw
> it's a hp dv9208nr laptop). It's ok under windows (32bit). I am running
> 64 bit linux.
> 
> If I insert the card after booting linux without it, the lines
> referencing the card do not get added to dmesg's output, and the /dev
> entries do not appear. udevd issue or driver?

Hot swap is not supported, always cold boot with the device inserted.

> 
> I don't have any other expresscards that I could plug-in to see if hot
> swap works on other things.
> 
> Ben
> oops on the reply list. It has been a long time since I wrote to a mail
> list. I did catch one thing before you needed to tell me - i switched to
> plain text from html mail. 

I tested a 77001 D3C0 rev and it doesn't locked for me either.

This used to work. Either the xc3028 or s5h1409 driver has a regression.

End result: Bug, broken. Thanks for highlighting this.

- Steve
