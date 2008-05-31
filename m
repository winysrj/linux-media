Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1K2QbD-0003R2-1b
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 14:54:19 +0200
Received: by fk-out-0910.google.com with SMTP id f40so2308054fka.1
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 05:54:05 -0700 (PDT)
Message-ID: <ea4209750805310554h75ecb9e4wdd05f3fb275454c6@mail.gmail.com>
Date: Sat, 31 May 2008 14:54:05 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
In-Reply-To: <ea4209750805281007g7c2d3b9dl4d3da8f4397ca34a@mail.gmail.com>
MIME-Version: 1.0
References: <483C2458.4080004@pandora.be>
	<ea4209750805270823h357384fcmfa981d2244472dae@mail.gmail.com>
	<20080527160509.723fa149@gaivota>
	<ea4209750805281007g7c2d3b9dl4d3da8f4397ca34a@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problem initialising Terratec Cinergy HT USB XE
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0023323783=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0023323783==
Content-Type: multipart/alternative;
	boundary="----=_Part_24_11432669.1212238445478"

------=_Part_24_11432669.1212238445478
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I just tested the latest changes and they work great!!

Albert

2008/5/28 Albert Comerma <albert.comerma@gmail.com>:

> I can't test it right now (I'm out for work). But I've looked the changes
> and they seem great for me, I just compiled and installed, without any
> problem, there's just the test left, for next weekend.
>
> Thanks!
>
> Albert
>
> 2008/5/27 Mauro Carvalho Chehab <mchehab@infradead.org>:
>
> Hi Albert,
>>
>> On Tue, 27 May 2008 17:23:50 +0200
>> "Albert Comerma" <albert.comerma@gmail.com> wrote:
>>
>> > There seems to be a problem with the last changes on xc2028 code, please
>> try
>> > this;
>> >
>> > In linux/drivers/media/common/tuners/tuner-xc2028.c file, on
>> xc2028_attach,
>> > video_dev must be = cfg->video_dev;
>> > and on the current source it's = cfg->i2c_adap->algo_data; which
>> completely
>> > breaks the module when loaded.
>> >
>> > It was already suggested that this should be changed, but nobody said
>> why
>> > this modification was done or why it was kept.
>> >
>> > Mauro could you trace when and why this modification was done? or at
>> least
>> > give it back to original state?
>> >
>>
>> It seems that I forgot to merge the fix for this. I've just committed it.
>> Could
>> you please test ? It is already available at mercurial tree.
>>
>> Cheers,
>> Mauro
>>
>
>

------=_Part_24_11432669.1212238445478
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I just tested the latest changes and they work great!!<br><br>Albert<br><br><div class="gmail_quote">2008/5/28 Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I can&#39;t test it right now (I&#39;m out for work). But I&#39;ve looked the changes and they seem great for me, I just compiled and installed, without any problem, there&#39;s just the test left, for next weekend.<br><br>

Thanks!<br><br>Albert<br><br><div class="gmail_quote">2008/5/27 Mauro Carvalho Chehab &lt;<a href="mailto:mchehab@infradead.org" target="_blank">mchehab@infradead.org</a>&gt;:<div><div></div><div class="Wj3C7c"><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

Hi Albert,<br>
<div><br>
On Tue, 27 May 2008 17:23:50 +0200<br>
&quot;Albert Comerma&quot; &lt;<a href="mailto:albert.comerma@gmail.com" target="_blank">albert.comerma@gmail.com</a>&gt; wrote:<br>
<br>
&gt; There seems to be a problem with the last changes on xc2028 code, please try<br>
&gt; this;<br>
&gt;<br>
&gt; In linux/drivers/media/common/tuners/tuner-xc2028.c file, on xc2028_attach,<br>
&gt; video_dev must be = cfg-&gt;video_dev;<br>
&gt; and on the current source it&#39;s = cfg-&gt;i2c_adap-&gt;algo_data; which completely<br>
&gt; breaks the module when loaded.<br>
&gt;<br>
&gt; It was already suggested that this should be changed, but nobody said why<br>
&gt; this modification was done or why it was kept.<br>
&gt;<br>
&gt; Mauro could you trace when and why this modification was done? or at least<br>
&gt; give it back to original state?<br>
&gt;<br>
<br>
</div>It seems that I forgot to merge the fix for this. I&#39;ve just committed it. Could<br>
you please test ? It is already available at mercurial tree.<br>
<br>
Cheers,<br>
<font color="#888888">Mauro<br>
</font></blockquote></div></div></div><br>
</blockquote></div><br>

------=_Part_24_11432669.1212238445478--


--===============0023323783==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0023323783==--
