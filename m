Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <florin@andrei.myip.org>) id 1Kxtl2-0003QZ-PX
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 02:34:02 +0100
Received: from localhost (weiqi.home.local [127.0.0.1])
	by weiqi.home.local (Postfix) with ESMTP id 4FDEC5770F3
	for <linux-dvb@linuxtv.org>; Wed,  5 Nov 2008 17:33:24 -0800 (PST)
Received: from weiqi.home.local ([127.0.0.1])
	by localhost (andrei.myip.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l3Sic+CJW7pO for <linux-dvb@linuxtv.org>;
	Wed,  5 Nov 2008 17:33:21 -0800 (PST)
Received: from [10.123.0.253] (unknown [10.123.0.253])
	by weiqi.home.local (Postfix) with ESMTP id 200FC576E26
	for <linux-dvb@linuxtv.org>; Wed,  5 Nov 2008 17:33:21 -0800 (PST)
Message-ID: <49124960.6070101@andrei.myip.org>
Date: Wed, 05 Nov 2008 17:33:20 -0800
From: Florin Andrei <florin@andrei.myip.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <491236F2.4050101@andrei.myip.org>
	<200811060153.37102.hftom@free.fr>
In-Reply-To: <200811060153.37102.hftom@free.fr>
Subject: Re: [linux-dvb] HD over satellite? (h.264)
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Christophe Thommeret wrote:
> Le jeudi 6 novembre 2008 01:14:42 Florin Andrei, vous avez =E9crit :
>> But I noticed that the european TV network that I watch over satellite
>> is now doing experiments with HD. They are testing HD broadcast over
>> satellite, encoded with h.264. They call it DVB-S HD.
>>
>> Question: Are you aware of any receiver that can be used with Linux to
>> capture DVB-S HD?
> =

> If it's DVB-S, any DVB-S device will.
> If it's DVB-S2, you need a DVB-S2 device.

So HD can be transmitted over DVB-S as well, it does not automatically =

imply DVB-S2. OK, that's something I didn't know.

A quick search on the Eutelsat website revealed that they transmit using =

DVB-S. So a DVB-S card like the Hauppauge WinTV-NOVA-S-Plus which I plan =

to purchase should be able to receive it, is that right?

(I can't receive Eutelsat from my area, but if they start broadcasting =

their HD channels on Galaxy 25, the way they do already with SD, then =

I'll be able to receive them.)

> Playback of such channels requires some strong multicore cpu, coupled wit=
h =

> latest ffmpeg svn.

Right. OTOH, I expect the satellite stuff to be transmitted at a pretty =

low bitrate, also perhaps with the more complex encoding features turned =

off. Based on the experiments that I did, h.264's playability depends a =

lot on the bitrate and on the features that were turned on in the encoder.

-- =

Florin Andrei

http://florin.myip.org/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
