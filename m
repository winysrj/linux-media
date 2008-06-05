Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gujs.lists@gmail.com>) id 1K4L0Q-00069t-Tl
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 21:20:15 +0200
Received: by yw-out-2324.google.com with SMTP id 3so395601ywj.41
	for <linux-dvb@linuxtv.org>; Thu, 05 Jun 2008 12:20:10 -0700 (PDT)
Message-ID: <23be820f0806051220y2da4167ew3681396e136cdb94@mail.gmail.com>
Date: Thu, 5 Jun 2008 21:20:10 +0200
From: "Gregor Fuis" <gujs.lists@gmail.com>
To: "Vladimir Prudnikov" <vpr@krastelcom.ru>
In-Reply-To: <22F7D555-1DAA-4B47-8BFB-BB6E5B167C62@krastelcom.ru>
MIME-Version: 1.0
References: <4847B3F0.1030501@gmail.com>
	<22F7D555-1DAA-4B47-8BFB-BB6E5B167C62@krastelcom.ru>
Cc: Mailing list for VLC media player developers <vlc-devel@videolan.org>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] multiproto and vlc
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0692833608=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0692833608==
Content-Type: multipart/alternative;
	boundary="----=_Part_1834_7060362.1212693610754"

------=_Part_1834_7060362.1212693610754
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Jun 5, 2008 at 11:40 AM, Vladimir Prudnikov <vpr@krastelcom.ru>
wrote:

> That's because vlc is relocking every 10 secs.
>
> Regards,
> Vladimir
>
>
> On Jun 5, 2008, at 1:37 PM, Gregor Fuis wrote:
>
>  Hello
>>
>> I am using the latest multiproto from Manu's repository with KNC1 DVB-S2
>> card. I patched drivers with multiproto-support-old-api.dif patch which
>> enables drivers for older DVB api. When I watch programs with vlc i get
>> a lot of discontinuity error. I was measuring how frequently they are
>> appearing and came to an interesting finding. It looks like they are
>> appearing in every 10 seconds (+- 1 second).
>>
>> But if I use szap to select channel and then open dvr0, the stream is
>> working great and without any errors.
>>
>> szap and vlc are both compiled for old api. VLC is version 0.8.6h on
>> Ubuntu 8.04 compiled by me. If I use latest hg drivers with KNC1 DVB-S
>> card vlc is working without problems.
>>
>> Can somebody help me find where the problem could be in vlc or
>> multiproto drivers when vlc is accessing dvb card directly. Is there any
>> event in drivers or VLC which is occurring every 10 seconds, that it
>> could have some effect on card. Probably it should be something in the
>> drivers, because VLC is working great with hg drivers and dvb-s card.
>>
>> Thanks!
>>
>> Best Regards,
>> Gregor
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
>
How come that VLC is not causing any problems to DVB-S cards with latest hg
drivers. I don't know VLC code very well, but do you think that I could
disable this retuning every 10 seconds without causing another issues to VLC
DVB handling.

Regards,
Gregor

------=_Part_1834_7060362.1212693610754
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">On Thu, Jun 5, 2008 at 11:40 AM, Vladimir Prudnikov &lt;<a href="mailto:vpr@krastelcom.ru">vpr@krastelcom.ru</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
That&#39;s because vlc is relocking every 10 secs.<br>
<br>
Regards,<br>
Vladimir<div><div></div><div class="Wj3C7c"><br>
<br>
On Jun 5, 2008, at 1:37 PM, Gregor Fuis wrote:<br>
<br>
</div></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div><div></div><div class="Wj3C7c">
Hello<br>
<br>
I am using the latest multiproto from Manu&#39;s repository with KNC1 DVB-S2<br>
card. I patched drivers with multiproto-support-old-api.dif patch which<br>
enables drivers for older DVB api. When I watch programs with vlc i get<br>
a lot of discontinuity error. I was measuring how frequently they are<br>
appearing and came to an interesting finding. It looks like they are<br>
appearing in every 10 seconds (+- 1 second).<br>
<br>
But if I use szap to select channel and then open dvr0, the stream is<br>
working great and without any errors.<br>
<br>
szap and vlc are both compiled for old api. VLC is version 0.8.6h on<br>
Ubuntu 8.04 compiled by me. If I use latest hg drivers with KNC1 DVB-S<br>
card vlc is working without problems.<br>
<br>
Can somebody help me find where the problem could be in vlc or<br>
multiproto drivers when vlc is accessing dvb card directly. Is there any<br>
event in drivers or VLC which is occurring every 10 seconds, that it<br>
could have some effect on card. Probably it should be something in the<br>
drivers, because VLC is working great with hg drivers and dvb-s card.<br>
<br>
Thanks!<br>
<br>
Best Regards,<br>
Gregor<br>
<br>
<br></div></div>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org" target="_blank">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote>
<br>
</blockquote></div><br>How come that VLC is not causing any problems to DVB-S cards with latest hg drivers. I don&#39;t know VLC code very well, but do you think that I could disable this retuning every 10 seconds without causing another issues to VLC DVB handling.<br>
<br>Regards,<br>Gregor<br>

------=_Part_1834_7060362.1212693610754--


--===============0692833608==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0692833608==--
