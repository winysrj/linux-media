Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailgw.detek.unideb.hu ([193.6.145.6])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lnovak@dragon.unideb.hu>) id 1LQQyb-0002Bv-13
	for linux-dvb@linuxtv.org; Fri, 23 Jan 2009 19:41:57 +0100
Received: from localhost (webmail.detek.unideb.hu [193.6.138.48])
	by mailgw.detek.unideb.hu (Postfix) with ESMTP id 3985A280C0
	for <linux-dvb@linuxtv.org>; Fri, 23 Jan 2009 19:41:26 +0100 (CET)
Message-ID: <20090123194122.ez7tev87a8kcw00g@webmail.detek.unideb.hu>
Date: Fri, 23 Jan 2009 19:41:22 +0100
From: lnovak@dragon.unideb.hu
To: linux-dvb@linuxtv.org
References: <000001c97d7c$3005c130$0202a8c0@speedy>
In-Reply-To: <000001c97d7c$3005c130$0202a8c0@speedy>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Which firmware for cx23885 and xc3028?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0133681965=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0133681965==
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Wayne and Holly <wayneandholly@alice.it> wrote:

>> I am trying to make an AverMedia AverTV Hybrid Express (A577)
>> work under Linux. It seems all major chips (cx23885, xc3028
>> and af9013) are already supported, so it should be doable in
>> principle.
>>
>> I am stuck a little bit since AFAIK both cx23885 and xc3028
>> need an uploadable firmware. Where should I download/extract
>> such firmware from? I tried Steven Toth's repo (the Hauppauge
>> HVR-1400 seems to be built around these chips as well) but
>> even after copying the files under /lib/firmware it didn't
>> really work. I tried to specify different cardtypes for the
>> cx23885 module. For cardtype=3D2 I got a /dev/video0 and a
>> /dev/video1 (the latter is of course unusable, I don't have a
>> MPEG encoder chip on my card) but tuning was unsuccesful. All
>> the other types I tried either didn't work at all or only
>> resulted in dvb devices detected. For the moment, I am fine
>> without DVB, and are interested mainly in analog devices.
>>
>> Maybe I should locate the windows driver of my card and
>> extract the firmware files from it? If so, how do I proceed?
>>
>
> Have you followed these instructions?:
> http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_t=
he
> _Firmware
>

Tried xc3028-v27.fw as well as v36 from Steven's site. There is nothing
showing up in the syslog when modprobing tuner-xc2028 (the doc mentions
the kernel driver should indicate which part it loads).

What's the situation with cx23885? After digging into the various docs
and descriptions pertaining to this chip, it's still not clear whether I
need a firmware (and if so, where from may I download/extract it).

Many thanks for your help!

Greetings,

Levente



-------------------------------------------------------
A levelet a DE TEK levelez=F5rendszeren kereszt=FCl k=FCldt=E9k




--===============0133681965==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0133681965==--
