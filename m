Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1KZB5j-0001wl-Nf
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 23:01:12 +0200
Received: by wf-out-1314.google.com with SMTP id 27so937371wfd.17
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 14:01:06 -0700 (PDT)
Message-ID: <e32e0e5d0808291401x39932ab6q6086882e81547f84@mail.gmail.com>
Date: Fri, 29 Aug 2008 14:01:06 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
	HVR-1500
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1025043315=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1025043315==
Content-Type: multipart/alternative;
	boundary="----=_Part_5196_27746944.1220043666321"

------=_Part_5196_27746944.1220043666321
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Mijhail Moreyra wrote:
> Steven Toth wrote:
>> Mijhail Moreyra wrote:
>>> Steven Toth wrote:
>>>> Mijhail,
>>>>
>>>> http://linuxtv.org/hg/~stoth/cx23885-audio<http://linuxtv.org/hg/%7Estoth/cx23885-audio>
>>>>
>>>> This tree contains your patch with some minor whitespace cleanups
>>>> and fixes for HUNK related merge issues due to the patch wrapping at
>>>> 80 cols.
>>>>
>>>> Please build this tree and retest in your environment to ensure I
>>>> did not break anything. Does this tree still work OK for you?
>>>>
>>>> After this I will apply some other minor cleanups then invite a few
>>>> other HVR1500 owners to begin testing.
>>>>
>>>> Thanks again.
>>>>
>>>> Regards,
>>>>
>>>> Steve
>>>
>>> Hi, sorry for the delay.
>>>
>>> I've tested the http://linuxtv.org/hg/~stoth/cx23885-audio<http://linuxtv.org/hg/%7Estoth/cx23885-audio>tree and
>>> it doesn't work well.
>>>
>>> You seem to have removed a piece from my patch that avoids some register
>>> modification in cx25840-core.c:cx23885_initialize()
>>>
>>> -       cx25840_write(client, 0x2, 0x76);
>>> +       if (state->rev != 0x0000) /* FIXME: How to detect the bridge
>>> type ??? */
>>> +               /* This causes image distortion on a true cx23885
>>> board */
>>> +               cx25840_write(client, 0x2, 0x76);
>>>
>>> As the patch says that register write causes a horrible image distortion
>>> on my HVR-1500 which has a real cx23885 (not 23887, 23888, etc) board.
>>>
>>> I don't know if it's really required for any bridge as everything seems
>>> to be auto-configured by default, maybe it can be simply dropped.
>>>
>>> Other than that the cx23885-audio tree works well.
>>>
>>> WRT the whitespaces, 80 cols, etc; most are also in the sources I took
>>> as basis, so I didn't think they were a problem.
>>
>> That's a mistake, I'll add that later tonight, thanks for finding
>> this. I must of missed it when I had to tear apart your email because
>> of HUNK issues caused by patch line wrapping.
>>
>> Apart from this, is everything working as you expect?
>>
>> Regards,
>>
>> Steve
>>
>>
>
> OK.
>
> And sorry about the patch, I didn't know it was going to be broken that
> way by being sent by email.
>
>  >> Other than that the cx23885-audio tree works well.
>

> Great, thanks for confirming.

> Regards,

> Steve

I'll try asking again since my replies in gmail were not including the
correct subject heading.
Can this code for cx23885 analog support be adapted for the DViCO Fusion
HDTV7 Dual Express which also uses the cx23885?  Currently the driver for
that card is digital only and I am stuck with a free antiquated large
satellite system that is analog only in my apartment. I am willing to put in
the work if someone can point me in the right direction.  Thank you,

--Tim

------=_Part_5196_27746944.1220043666321
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Mijhail Moreyra wrote:<br>
&gt; Steven Toth wrote:<br>
&gt;&gt; Mijhail Moreyra wrote:<br>
&gt;&gt;&gt; Steven Toth wrote:<br>
&gt;&gt;&gt;&gt; Mijhail,<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; <a href="http://linuxtv.org/hg/%7Estoth/cx23885-audio" target="_blank">http://linuxtv.org/hg/~stoth/cx23885-audio</a><br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; This tree contains your patch with some minor whitespace cleanups<br>
&gt;&gt;&gt;&gt; and fixes for HUNK related merge issues due to the patch wrapping at<br>
&gt;&gt;&gt;&gt; 80 cols.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Please build this tree and retest in your environment to ensure I<br>
&gt;&gt;&gt;&gt; did not break anything. Does this tree still work OK for you?<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; After this I will apply some other minor cleanups then invite a few<br>
&gt;&gt;&gt;&gt; other HVR1500 owners to begin testing.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Thanks again.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Regards,<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Steve<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Hi, sorry for the delay.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I&#39;ve tested the <a href="http://linuxtv.org/hg/%7Estoth/cx23885-audio" target="_blank">http://linuxtv.org/hg/~stoth/cx23885-audio</a> tree and<br>
&gt;&gt;&gt; it doesn&#39;t work well.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; You seem to have removed a piece from my patch that avoids some register<br>
&gt;&gt;&gt; modification in cx25840-core.c:cx23885_<div id=":ak" class="ArwC7c ckChnd">initialize()<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; - &nbsp; &nbsp; &nbsp; cx25840_write(client, 0x2, 0x76);<br>
&gt;&gt;&gt; + &nbsp; &nbsp; &nbsp; if (state-&gt;rev != 0x0000) /* FIXME: How to detect the bridge<br>
&gt;&gt;&gt; type ??? */<br>
&gt;&gt;&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /* This causes image distortion on a true cx23885<br>
&gt;&gt;&gt; board */<br>
&gt;&gt;&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; cx25840_write(client, 0x2, 0x76);<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; As the patch says that register write causes a horrible image distortion<br>
&gt;&gt;&gt; on my HVR-1500 which has a real cx23885 (not 23887, 23888, etc) board.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I don&#39;t know if it&#39;s really required for any bridge as everything seems<br>
&gt;&gt;&gt; to be auto-configured by default, maybe it can be simply dropped.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Other than that the cx23885-audio tree works well.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; WRT the whitespaces, 80 cols, etc; most are also in the sources I took<br>
&gt;&gt;&gt; as basis, so I didn&#39;t think they were a problem.<br>
&gt;&gt;<br>
&gt;&gt; That&#39;s a mistake, I&#39;ll add that later tonight, thanks for finding<br>
&gt;&gt; this. I must of missed it when I had to tear apart your email because<br>
&gt;&gt; of HUNK issues caused by patch line wrapping.<br>
&gt;&gt;<br>
&gt;&gt; Apart from this, is everything working as you expect?<br>
&gt;&gt;<br>
&gt;&gt; Regards,<br>
&gt;&gt;<br>
&gt;&gt; Steve<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;<br>
&gt; OK.<br>
&gt;<br>
&gt; And sorry about the patch, I didn&#39;t know it was going to be broken that<br>
&gt; way by being sent by email.<br>
&gt;<br>
&gt; &nbsp;&gt;&gt; Other than that the cx23885-audio tree works well.<br>
&gt;<br>
<br>
&gt; Great, thanks for confirming.<br>
<br>
&gt; Regards,<br>
<br>
&gt; Steve</div><br>I&#39;ll try asking again since my replies in gmail were not including the correct subject heading.<br>Can this code for cx23885 analog support be adapted for the DViCO Fusion HDTV7 Dual Express which also uses the cx23885?&nbsp; Currently the driver for that card is digital only and I am stuck with a free antiquated large satellite system that is analog only in my apartment. I am willing to put in the work if someone can point me in the right direction.&nbsp; Thank you,<br clear="all">
<br> --Tim<br>
</div>

------=_Part_5196_27746944.1220043666321--


--===============1025043315==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1025043315==--
