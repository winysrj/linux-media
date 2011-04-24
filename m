Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:39188 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515Ab1DXM4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2011 08:56:03 -0400
Date: Sun, 24 Apr 2011 13:37:35 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: Steffen Barszus <steffenbpunkt@googlemail.com>
Subject: Re: stb0899/stb6100 tuning problems
CC: <linux-media@vger.kernel.org>, <tuxoholic@hotmail.de>,
	Manu Abraham <abraham.manu@gmail.com>
Mime-Version: 1.0
Message-ID: <711PDXLKj7488S01.1303645055@web01.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 24/04/11 09:44, Steffen Barszus wrote:
> On Sat, 23 Apr 2011 22:55:27 +0200
> Issa Gorissen <flop.m@usa.net> wrote:
>
>> Hi,
>>
>> Running kernel 2.6.39rc4. I've got trouble with tuning some
>> transponders on Hotbird 13°E with a TT S2-3200.
>> The transponders have been emitting DVB-S until end of march when they
>> now emit DVB-S2 signals. They are:
>> - 11681.00H 27500 3/4 8psk nid:319 tid:15900 on Hotbird 6
>> - 12692.00H 27500 3/4 8psk nid:319 tid:9900 on Hotbird 9
>>
>>
>> [1] https://patchwork.kernel.org/patch/244201/
>> [2]
>> http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg09214.html
>>
>> 1) Patch [2] is merged into kernel 2.6.39rc4. Using scan-s2, I get no
>> service available.
>>
>> 2) I applied patch [1] and still could not get any service with
>> scan-s2 from those transponders.
>>
>> 3) I *reverted* patch[2] and now scan-s2 returns partial results.
>> scan-s2 can tune onto the transponder on Hotbird 6 really quick and
>> gives back the full services list.
>> But I have to run scan-s2 with scan iterations count set to as high as
>> 100 to be able to get results from the transponder on Hotbird 9.
>>
>> When those transponders were emitting in DVB-S, I had no problem at
>> all.
>>
>> Can someone try the same thing on those transponders and report
>> please ?
> As mentioned before, try to use [1] + [2] + following patch. I would
> expect this to be working. Please confirm. 
>
> --- a/linux/drivers/media/dvb/frontends/stb0899_drv.c   2011-02-26
06:44:11.000000000 +0000
> +++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c   2011-04-24
07:39:06.000000000 +0000
> @@ -1426,9 +1426,9 @@ static void stb0899_set_iterations(struc
>         if (iter_scale > config->ldpc_max_iter)
>                 iter_scale = config->ldpc_max_iter;
>
> -       reg = STB0899_READ_S2REG(STB0899_S2DEMOD, MAX_ITER);
> +       reg = STB0899_READ_S2REG(STB0899_S2FEC, MAX_ITER);
>         STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
> -       stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_MAX_ITER,
STB0899_OFF0_MAX_ITER, reg);
> +       stb0899_write_s2reg(state, STB0899_S2FEC, STB0899_BASE_MAX_ITER,
STB0899_OFF0_MAX_ITER, reg);
>  }
>
>  static enum dvbfe_search stb0899_search(struct dvb_frontend *fe, struct
dvb_frontend_parameters *p)

Thx for your reply.

Applied [1] + [2] + your path.

Unfortunately, this does not work for me. scan-s2 can tune only on the
1st of those 3 transponders on HB13E

S1  12654000 H 27500000  3/4
S2 12692000 H 27500000  3/4 35   8PSK
S2 11681000 H 27500000  3/4 35   8PSK

Please note that I can tune quick/fast on those 3 transponders with a
ngene based card. szap will report a signal of 60% and snr of 70% for
them. Problem is the CI support does not work for me.

I am wondering if there is a dvb-s2 card with ci support which
flawlessly works on linux... ?


