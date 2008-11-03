Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <2manybills@gmail.com>) id 1Kx3mf-0003Oh-Uz
	for linux-dvb@linuxtv.org; Mon, 03 Nov 2008 19:04:15 +0100
Received: by nf-out-0910.google.com with SMTP id g13so1254891nfb.11
	for <linux-dvb@linuxtv.org>; Mon, 03 Nov 2008 10:04:10 -0800 (PST)
Message-ID: <157f4a8c0811031004j776b2eb2v67d59b80775246b9@mail.gmail.com>
Date: Mon, 3 Nov 2008 18:04:10 +0000
From: "hudo kkow" <2manybills@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <157f4a8c0811030703w195a4947uab8c3076173898e5@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<b42fca4d0810280227n44d53f03hfaa8237793fc1db9@mail.gmail.com>
	<c74595dc0810281223j25d78c9eqbcbed70a1b495b43@mail.gmail.com>
	<b42fca4d0810281305l6e741c25ia25e1f3f348761d5@mail.gmail.com>
	<c74595dc0810281320r9ef1a1cw172a36738c8a4e8@mail.gmail.com>
	<c74595dc0810301510t5ae3df6fg28c6a62e999aed83@mail.gmail.com>
	<20081031145853.2b722c9f@bk.ru>
	<157f4a8c0811030703w195a4947uab8c3076173898e5@mail.gmail.com>
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mon, Nov 3, 2008 at 3:03 PM, hudo kkow <2manybills@gmail.com> wrote:
> Hi.
> For me is also working strange scanning 30W Meo provider >>
> http://pt.kingofsat.net/pack-meo.php
> As you can see from the link above, all channels are on DVB-S2 8PSK
> and sometimes scan picks up every channel and other times it doesn't.
>
> After a few tries, every channel was picked up, but some parameters are missing.
>
> This is a scanned channel list.
> (null) - [000-0065];:12012:hS1:30W:30000:4097:4098:4100:100:101:0:0:0
> (null) - [001-0066];:12012:hS1:30W:30000:4105:4106:4100:100:102:0:0:0
> (null) - [002-0067];:12012:hS1:30W:30000:4113:4114:4100:100:103:0:0:0
> (null) - [003-0068];:12012:hS1:30W:30000:4121:4122:4100:100:104:0:0:0
> (null) - [004-0069];:12012:hS1:30W:30000:4129:4130:4100:100:105:0:0:0
> (null) - [005-006a];:12012:hS1:30W:30000:4137:4138:4100:100:106:0:0:0
> (null) - [006-006b];:12012:hS1:30W:30000:4145:4146:4100:100:107:0:0:0
> (null) - [007-006c];:12012:hS1:30W:30000:4153:4154:0:100:108:0:0:0
> (null) - [008-006d];:12012:hS1:30W:30000:4161:4162:0:100:109:0:0:0
> (null) - [009-006e];:12012:hS1:30W:30000:4169:4170:0:100:110:0:0:0
> (null) - [00a-006f];:12012:hS1:30W:30000:4177:4178:0:100:111:0:0:0
> (null) - [00b-0070];:12012:hS1:30W:30000:4185:4186:0:100:112:0:0:0
> (null) - [00c-0071];:12012:hS1:30W:30000:4193:4194:0:100:113:0:0:0
>
> As you can see, no network and provider are known, along with other
> parameters, aldo I scanned with
>
> ./scan-s2 -O 30W -x -2 -t 1 -p -o vdr -s3 -v -U HispaOnlyMEO > Meo_3_test
>
> I have tried with FEC 3/4
>
> # 30W
> S 12012000 H 30000000 3/4
> S 12052000 H 30000000 3/4
> S 12092000 H 30000000 3/4
>
> and FEC AUTO
>
> # 30W
> S 12012000 H 30000000 AUTO
> S 12052000 H 30000000 AUTO
> S 12092000 H 30000000 AUTO
>
> Auto seems to work better.
>
> If anyone wants to give it a try, go ahead and leave feedback.
>
> Using a TT-3200 on ubuntu 64.

Hi, again.
Some improvements were made. Changed frequency scan file from above to
the one below and a few more parameters were added by scan-s2.

 # 30W
S 12012000 H 30000000 3/4 AUTO 8PSK
S 12052000 H 30000000 3/4 AUTO 8PSK
S 12092000 H 30000000 3/4 AUTO 8PSK

The resulting scan:

(null) - [000-0065];:12012:hS1C34M5:30W:30000:4097:4098:4100:100:101:0:0:0
(null) - [001-0066];:12012:hS1C34M5:30W:30000:4105:4106:4100:100:102:0:0:0
(null) - [002-0067];:12012:hS1C34M5:30W:30000:4113:4114:4100:100:103:0:0:0
(null) - [003-0068];:12012:hS1C34M5:30W:30000:4121:4122:4100:100:104:0:0:0
(null) - [004-0069];:12012:hS1C34M5:30W:30000:4129:4130:4100:100:105:0:0:0
(null) - [005-006a];:12012:hS1C34M5:30W:30000:4137:4138:4100:100:106:0:0:0
(null) - [006-006b];:12012:hS1C34M5:30W:30000:4145:4146:4100:100:107:0:0:0
(null) - [007-006c];:12012:hS1C34M5:30W:30000:4153:4154:0:100:108:0:0:0
(null) - [008-006d];:12012:hS1C34M5:30W:30000:4161:4162:0:100:109:0:0:0
(null) - [009-006e];:12012:hS1C34M5:30W:30000:4169:4170:0:100:110:0:0:0
(null) - [00a-006f];:12012:hS1C34M5:30W:30000:4177:4178:0:100:111:0:0:0
(null) - [00b-0070];:12012:hS1C34M5:30W:30000:4185:4186:0:100:112:0:0:0
(null) - [00c-0071];:12012:hS1C34M5:30W:30000:4193:4194:0:100:113:0:0:0

Notice the difference from hS1 to hS1C34M5? Quite an improvement. I
don't know the rolloff parameter, do.

Any one knows you we can get rolloff?

BTW, a very complete set of files with satellites transponder list is
available at

>> http://joshyfun.cjb.net/ <<.

I recommend it's use. Thanks Joshy for providing such great files.

Testing continues.

And thanks Alex, for a great tool. The first one I used with
satisfactory results on DVB-S2 transponders. Well done.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
