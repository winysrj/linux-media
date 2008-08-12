Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kknull0@gmail.com>) id 1KShdY-0000dD-4A
	for linux-dvb@linuxtv.org; Tue, 12 Aug 2008 02:21:22 +0200
Received: by yx-out-2324.google.com with SMTP id 8so717242yxg.41
	for <linux-dvb@linuxtv.org>; Mon, 11 Aug 2008 17:21:15 -0700 (PDT)
Message-ID: <57ed08da0808111721v2d152865t5feee0c81cfaaf5c@mail.gmail.com>
Date: Tue, 12 Aug 2008 02:21:15 +0200
From: Xaero <kknull0@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <57ed08da0808111720j5514e218o2f4a17d2f4a954b7@mail.gmail.com>
MIME-Version: 1.0
References: <57ed08da0808081449m598af353n7edf908551753318@mail.gmail.com>
	<412bdbff0808081458v418449c4q6db215cf83e3ead0@mail.gmail.com>
	<57ed08da0808111720j5514e218o2f4a17d2f4a954b7@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle pctv hybrid pro stick 340e support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1759871412=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1759871412==
Content-Type: multipart/alternative;
	boundary="----=_Part_75038_26345442.1218500475402"

------=_Part_75038_26345442.1218500475402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

ok,
I've opened the card. The component are similar to 801e but they're not the
same..

-DibCom 700C1 - ACXXa-G
 USB 2.0 DVB QHGG0
 03M95.1
 0809 - 1100 - C
- XCeive 4000ACQ
  DP5579
  0805TWE3
- Conexant CX25843 - 24Z
  81038424
  0804 KOREA
- Cirrus 5340CZZ
  0744


2008/8/8 Devin Heitmueller <devin.heitmueller@gmail.com>

2008/8/8 Xaero <kknull0@gmail.com>:
> > Hi,
> > I'm trying to make the 340e card work. (This is a reply to Gerard post,
> I've
> > just subscribed to this list and I didn't know how to reply, sorry :D)
> > I have the same lsusb output as Gerard. but I can't get more information
> > from dmesg:
> > I get only
> >
> > usb 6-8: new high speed USB device using ehci_hcd and address 8
> > usb 6-8: configuration #1 chosen from 1 choice
> >
> > when the card is plugged. (maybe I have to configure some kernel
> options?)
> >
> > Btw, I tried the dib0770 modules (following Albert's instructions) , and
> no
> > dvb devices are created, so i don't think they'rer the right drivers (I'm
> > not sure again, dmesg doesn't write anything)...
> > Suggestion?
>
> I'm not sure how similar the 340e is to the "Pinnacle PCTV HD Pro USB"
> stick that's available in the United States, but it's possible they're
> similar devices:
>
> http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Pro_Stick_(801e)<http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Pro_Stick_%28801e%29>
>
> Why don't you open it up and see if it's got the same components?
>
> I have been working on it for the last few days, and I'm pretty close
> to having it working.  Once I do, adding another USB ID would be
> pretty simple.  I should have a patch for digital support toward the
> end of next week (I will be out of town until then).
>
> If it's not the same device, you should create a page in the Wiki
> comparable to the one above, containing all of the chips that the
> device includes (so at least people will know definitively that it's
> not supported and what it is composed of).
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

------=_Part_75038_26345442.1218500475402
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><div class="gmail_quote"><div dir="ltr">ok, <br>I&#39;ve opened the card. The component are similar to 801e but they&#39;re not the same..<br><br>-DibCom 700C1 - ACXXa-G<br>&nbsp;USB 2.0 DVB QHGG0<br>&nbsp;03M95.1<br>
&nbsp;0809 - 1100 - C<br>- XCeive 4000ACQ <br>
&nbsp; DP5579<br>&nbsp; 0805TWE3<br>- Conexant CX25843 - 24Z<br>&nbsp; 81038424<br>&nbsp; 0804 KOREA<br>- Cirrus 5340CZZ<br>&nbsp; 0744<br><br><br><div class="gmail_quote">2008/8/8 Devin Heitmueller <span dir="ltr">&lt;<a href="mailto:devin.heitmueller@gmail.com" target="_blank">devin.heitmueller@gmail.com</a>&gt;</span><div>
<div></div><div class="Wj3C7c"><br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">2008/8/8 Xaero &lt;<a href="mailto:kknull0@gmail.com" target="_blank">kknull0@gmail.com</a>&gt;:<br>

<div><div></div><div>&gt; Hi,<br>
&gt; I&#39;m trying to make the 340e card work. (This is a reply to Gerard post, I&#39;ve<br>
&gt; just subscribed to this list and I didn&#39;t know how to reply, sorry :D)<br>
&gt; I have the same lsusb output as Gerard. but I can&#39;t get more information<br>
&gt; from dmesg:<br>
&gt; I get only<br>
&gt;<br>
&gt; usb 6-8: new high speed USB device using ehci_hcd and address 8<br>
&gt; usb 6-8: configuration #1 chosen from 1 choice<br>
&gt;<br>
&gt; when the card is plugged. (maybe I have to configure some kernel options?)<br>
&gt;<br>
&gt; Btw, I tried the dib0770 modules (following Albert&#39;s instructions) , and no<br>
&gt; dvb devices are created, so i don&#39;t think they&#39;rer the right drivers (I&#39;m<br>
&gt; not sure again, dmesg doesn&#39;t write anything)...<br>
&gt; Suggestion?<br>
<br>
</div></div>I&#39;m not sure how similar the 340e is to the &quot;Pinnacle PCTV HD Pro USB&quot;<br>
stick that&#39;s available in the United States, but it&#39;s possible they&#39;re<br>
similar devices:<br>
<br>
<a href="http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Pro_Stick_%28801e%29" target="_blank">http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Pro_Stick_(801e)</a><br>
<br>
Why don&#39;t you open it up and see if it&#39;s got the same components?<br>
<br>
I have been working on it for the last few days, and I&#39;m pretty close<br>
to having it working. &nbsp;Once I do, adding another USB ID would be<br>
pretty simple. &nbsp;I should have a patch for digital support toward the<br>
end of next week (I will be out of town until then).<br>
<br>
If it&#39;s not the same device, you should create a page in the Wiki<br>
comparable to the one above, containing all of the chips that the<br>
device includes (so at least people will know definitively that it&#39;s<br>
not supported and what it is composed of).<br>
<br>
Devin<br>
<font color="#888888"><br>
--<br>
Devin J. Heitmueller<br>
<a href="http://www.devinheitmueller.com" target="_blank">http://www.devinheitmueller.com</a><br>
AIM: devinheitmueller<br>
</font></blockquote></div></div></div><br></div>
</div><br></div>

------=_Part_75038_26345442.1218500475402--


--===============1759871412==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1759871412==--
