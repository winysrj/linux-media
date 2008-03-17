Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JbEZP-0000Lg-RH
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 13:36:04 +0100
Received: by fk-out-0910.google.com with SMTP id z22so7225653fkz.1
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 05:36:00 -0700 (PDT)
Message-ID: <ea4209750803170535m36914e6bu93e39269e8c7faf3@mail.gmail.com>
Date: Mon, 17 Mar 2008 13:35:59 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47DE5F42.8070005@iki.fi>
MIME-Version: 1.0
References: <20080316182618.2e984a46@slackware.it> <47DDC4B5.5050607@iki.fi>
	<20080317025002.2fee3860@slackware.it> <47DDD009.30504@iki.fi>
	<20080317025849.49b07428@slackware.it> <47DDD817.9020605@iki.fi>
	<20080317104147.1ade57fe@slackware.it>
	<20080317114802.0df56399@slackware.it>
	<abf3e5070803170409j8be4c54r96f97eb2d3fd4dac@mail.gmail.com>
	<47DE5F42.8070005@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] New unsupported device
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1094325697=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1094325697==
Content-Type: multipart/alternative;
	boundary="----=_Part_14688_10739072.1205757359808"

------=_Part_14688_10739072.1205757359808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Pinnacle 72e was working, so looking on what you said a modification of the
same driver should work with 73e... I will send the files later (I must find
them...), because I think the changes needed where not added to the current
v4l.

/17, Antti Palosaari <crope@iki.fi>:
>
> Jarryd Beck wrote:
> > That means the driver either couldn't work out what the tuner is
> > and therefore, couldn't attach a frontend, or there was an error
> > attaching the frontend. The next job is to work out what the
> > tuner chip is, you might have to open it up and read the writing
> > off the chip to find that out.
>
>
> yep, tuner is missing. It could be mt2266. Look other devices in the
> file patched and try if some of those will work.
>
>
> regards
> Antti
> --
> http://palosaari.fi/
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_14688_10739072.1205757359808
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Pinnacle 72e was working, so looking on what you said a modification of the same driver should work with 73e... I will send the files later (I must find them...), because I think the changes needed where not added to the current v4l.<br>
<br>/17, Antti Palosaari &lt;<a href="mailto:crope@iki.fi" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">crope@iki.fi</a>&gt;:<div>
<span class="gmail_quote"></span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Jarryd Beck wrote:<br> &gt; That means the driver either couldn&#39;t work out what the tuner is<br>

 &gt; and therefore, couldn&#39;t attach a frontend, or there was an error<br> &gt; attaching the frontend. The next job is to work out what the<br> &gt; tuner chip is, you might have to open it up and read the writing<br>

 &gt; off the chip to find that out.<br> <br> <br>yep, tuner is missing. It could be mt2266. Look other devices in the<br> file patched and try if some of those will work.<br> <br><br> regards<br> Antti<br> --<br> <a href="http://palosaari.fi/" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://palosaari.fi/</a><br>

 <br> <br>_______________________________________________<br> linux-dvb mailing list<br> <a href="mailto:linux-dvb@linuxtv.org" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">linux-dvb@linuxtv.org</a><br>
 <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
 </blockquote></div><br>

------=_Part_14688_10739072.1205757359808--


--===============1094325697==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1094325697==--
