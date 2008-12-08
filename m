Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L9oWn-0005d7-69
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 23:24:34 +0100
Received: by nf-out-0910.google.com with SMTP id g13so727537nfb.11
	for <linux-dvb@linuxtv.org>; Mon, 08 Dec 2008 14:24:29 -0800 (PST)
Message-ID: <412bdbff0812081424s1cd67d6fv71a7ab3298eb5fff@mail.gmail.com>
Date: Mon, 8 Dec 2008 17:24:29 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "daniel. perzynski" <daniel.perzynski@aster.pl>
In-Reply-To: <A957E57448D25C0C661E9E181E74547A1228774205B964889A15616F1311@webmail.aster.pl>
MIME-Version: 1.0
Content-Disposition: inline
References: <A957E57448D25C0C661E9E181E74547A1228774205B964889A15616F1311@webmail.aster.pl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fw: Re: Avermedia A312 wiki page
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

On Mon, Dec 8, 2008 at 5:10 PM, daniel. perzynski
<daniel.perzynski@aster.pl> wrote:
> Hi,
>
> I'm asking again for more help as I haven't received any response to
> my previous e-mail pasted below. I've tried to run
> SniffUSB-x64-2.0.0006.zip but is not working under vista :( I've also
> found that card is using merlinb.rom and merlinc.rom (they are listed
> in device manager in windows vista)
>> I've tried to load all v4l modules (one by one) in 2.6.27.4 kernel -
>> nothing in syslog :(
>> I've then compiled and tried to load lgdt330x, cx25840,tuner-xc2028
>> and
>> wm8739 from http://linuxtv.org/hg/v4l-dvb mercurial repository -
>> nothing
>> in syslog :(
>>
>> At the end I've used http://linuxtv.org/hg/v4l-dvb-experimental
>> repository and when doing:
>>
>> insmod em28xx_cx25843, I've received :)
>> Nov 30 21:43:54 h3xu5 cx25843.c: starting probe for adapter SMBus
>> I801
>> adapter at 1200 (0x40004)
>> Nov 30 21:43:54 h3xu5 cx25843.c: detecting cx25843 client on address
>> 0x88
>>
>> It is a small progress and I need even more help here. There is a
>> question if I'm doing everything right? Do I need to load the
>> modules
>> with parameters? Why I need to do next to help in creation of
>> working
>> solution for that A312 card?
>
> Regards,
>

It's probably also worth mentioning that all the components in that
product do currently have Linux drivers, so it's just a matter of
combining them and providing the correct device configuration for your
hardware.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
