Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <richard.palmer@gmail.com>) id 1L4FMi-00016T-QQ
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 14:51:12 +0100
Received: by yx-out-2324.google.com with SMTP id 8so759527yxg.41
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 05:51:03 -0800 (PST)
Message-ID: <100c0ba70811230551p1558032ehb24f5d489fea6048@mail.gmail.com>
Date: Sun, 23 Nov 2008 13:51:02 +0000
From: "Richard Palmer" <richard.palmer@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <49285C15.4040903@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <100c0ba70811181413p57abe7daw1f2ac4a89881d2f8@mail.gmail.com>
	<49285C15.4040903@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Reception problems with af9015 based USB stick
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

Hi,

On Sat, Nov 22, 2008 at 7:23 PM, Antti Palosaari <crope@iki.fi> wrote:
> Richard Palmer wrote:
>>  Whilst it works well in single mode (in dual mode neither tuner
>>  worked), there seem to be a lot more 'pops' in the sound and blocks
>>  appearing in the picture. Are there any more tuning options I can try
>> when
>>  loading the module?. I have re-scanned the channels in MythTV but no
>>  improvement. I know it's not a signal strength problem as both a set-top
>> box
>>  and the nova-t ran from the same aerial without these problems.
>
> I made test version that uses different tuner driver. Please test if it
> helps. http://linuxtv.org/hg/~anttip/af9015-mxl500x/

All the sound glitches have gone, the picture is almost perfect (a few
blocks occasionally but probably caused
by interference). Many thanks Antti.

I thought I'd push my luck and see if the dual tuner support worked
with the new driver, it seems to
as the first frontend is working just as well as in single mode now,
but no frontend device is appearing for
the second tuner so I can't test it.

Thanks again,

Richard

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
