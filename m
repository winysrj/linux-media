Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.230])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JjFpX-0000IA-3N
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 17:33:58 +0200
Received: by wr-out-0506.google.com with SMTP id c30so1778438wra.14
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 08:33:35 -0700 (PDT)
Message-ID: <617be8890804080833s445761c1y8688130c20b8128f@mail.gmail.com>
Date: Tue, 8 Apr 2008 17:33:34 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "mehmet canser" <mehmetcanser@hotmail.com>, linux-dvb@linuxtv.org
In-Reply-To: <BAY114-W3333A14A0D986A357AC946DBF20@phx.gbl>
MIME-Version: 1.0
References: <617be8890804080606y23bc62b7j7495a37c039bd3d6@mail.gmail.com>
	<BAY114-W531B3EFEA7CE4CAEC133AEDBF20@phx.gbl>
	<617be8890804080758o20a29e3dvd6e00dda7101b9f1@mail.gmail.com>
	<BAY114-W3333A14A0D986A357AC946DBF20@phx.gbl>
Subject: Re: [linux-dvb] Any progress on the AverMedia A700 (DVB-S Pro)?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0891603653=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0891603653==
Content-Type: multipart/alternative;
	boundary="----=_Part_17413_10354847.1207668814277"

------=_Part_17413_10354847.1207668814277
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Well, then it must be something on the linux side, as I have absolutely no
control on the dish itself.
I don't know how Disqec works, but maybe the fact that the card can't
control the dish through it provoques the problems.

Regards,
  Eduard



2008/4/8, mehmet canser <mehmetcanser@hotmail.com>:
>
>  I only modify two files and add one line for each.
>
> /etc/modules
>    saa7134
>
> /etc/modprobe.d/options
> options saa7134 i2c_scan=1
>
> My card directly connects disqec and I have two dishes. I have only weak
> signals, no other problem.
> Your satellite configuration different, may be you may need some
> adjustment for satellite signal, may be voltage, may be special frequency.
>
> If you can connect  satellite dish directly tv card, you may understand
> problem,  It s linux or satellite configuration.
>
> Best Regard,
> Mehmet Canser
>
>
>
> ------------------------------
> Get in touch in an instant. Get Windows Live Messenger now.<http://www.windowslive.com/messenger/overview.html?ocid=TXT_TAGLM_WL_Refresh_getintouch_042008>
>

------=_Part_17413_10354847.1207668814277
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Well, then it must be something on the linux side, as I have absolutely no control on the dish itself.<br>I don&#39;t know how Disqec works, but maybe the fact that the card can&#39;t control the dish through it provoques the problems.<br>
<br>Regards, <br>&nbsp; Eduard<br><br><br><br><div><span class="gmail_quote">2008/4/8, mehmet canser &lt;<a href="mailto:mehmetcanser@hotmail.com">mehmetcanser@hotmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">




<div>
I only modify two files and add one line for each. <br><br>/etc/modules&nbsp; <br>&nbsp;&nbsp; saa7134<br><br>/etc/modprobe.d/options<br>options saa7134 i2c_scan=1<br><br>My card directly connects disqec and I have two dishes. I have only weak signals, no other problem. <br>
Your satellite configuration different, may be you may need some adjustment for satellite signal, may be voltage, may be special frequency.<br><br>If you can connect&nbsp; satellite dish directly tv card, you may understand problem,&nbsp; It s linux or satellite configuration. <br>
<br>Best Regard,<br>Mehmet Canser<br><blockquote><div><blockquote style="padding-left: 1ex;"><div><br></div>

</blockquote></div>
</blockquote><br><hr>Get in touch in an instant. <a href="http://www.windowslive.com/messenger/overview.html?ocid=TXT_TAGLM_WL_Refresh_getintouch_042008" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">Get Windows Live Messenger now.</a></div>

</blockquote></div><br>

------=_Part_17413_10354847.1207668814277--


--===============0891603653==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0891603653==--
