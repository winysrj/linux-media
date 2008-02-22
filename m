Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-Id: <0980249F-1C4D-482E-9860-1F20A6A86B44@hiof.no>
From: =?ISO-8859-1?Q?Andreas_Bergstr=F8m?= <andreas.bergstrom@hiof.no>
To: Steven Toth <stoth@linuxtv.org>
In-Reply-To: <47BDAEC4.4080000@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Fri, 22 Feb 2008 09:02:15 +0100
References: <OF036443EE.14B484CA-ONC12573F6.004FABE2-C12573F6.004FABEC@devoteam.com>
	<47BDAEC4.4080000@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Cannot switch polarization: Hauppauge
	WinTV-NOVA-HD-S2
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


On 21. feb.. 2008, at 18:03, Steven Toth wrote:
>> 13V is vertical and 18V is horisontal polarization, so I don't  =

>> think it
>> is related.
>>
>> I have two HVR-4000 working on OpenSuse 10.3 with the latest v4l-dvb
>> drivers from http://linuxtv.org/hg/v4l-dvb pathed with
>> http://dev.kewl.org/hauppauge/v4l-dvb-hg-sfe-latest.diff. I have also
>> followed the instructions you refer to, but had to do make release
>> before the make and make install to get it to work.
>
> Someone started screwing with the isl1621 (?) driver after support for
> this product was released (probably to fix another vendors board), it
> broke Hauppauge support.

Thanks for your help. Having checked voltage, I was stumped to why it  =

was not working, and it turns out that one of the recievers in our 8- =

way LNB no longer tunes to the horisontal polarization. (Its been  =

tuning to the same vertical polarized channel for the last 2.5 years,  =

so I guess something broke.) I tested with another cable, and it was  =

able to scan both vertical and horizontally polarized channels.

Regards,

--
Andreas Bergstr=F8m
=D8stfold University College
Dept. of Computer Sciences
Tel: +47 69 21 53 71
http://media.hiof.no/






_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
