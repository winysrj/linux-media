Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n6.bullet.re3.yahoo.com ([68.142.237.91])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <korey_avail@yahoo.com>) id 1Kq6hw-0006aw-1g
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 15:46:38 +0200
Date: Wed, 15 Oct 2008 06:46:01 -0700 (PDT)
From: Korey ODell <korey_avail@yahoo.com>
To: Michael Krufky <mkrufky@linuxtv.org>
In-Reply-To: <48F53A68.4070506@linuxtv.org>
MIME-Version: 1.0
Message-ID: <687344.54367.qm@web57506.mail.re1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dvico HDTV7 Dual Express signal strength
Reply-To: korey_avail@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0335919581=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0335919581==
Content-Type: multipart/alternative; boundary="0-468556043-1224078361=:54367"

--0-468556043-1224078361=:54367
Content-Type: text/plain; charset=us-ascii

I actually have both. 

The DViCO FusionHDTV 7 Gold [card=65] has the 1411 and the 

DViCO FusionHDTV7 Dual Express [card=10,autodetected] has the 1409.



I can not read the signal strength on either of them.

Here is what femon yields on the Gold card (1411)

status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 | FE_HAS_LOCK

status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 | FE_HAS_LOCK

status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 | FE_HAS_LOCK



recabling this same RF to a HDTV5 Gold card reports ~90-95% signal strength.

Thanks for any help.

--- On Tue, 10/14/08, Michael Krufky <mkrufky@linuxtv.org> wrote:
From: Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] Dvico HDTV7 Dual Express signal strength
To: korey_avail@yahoo.com
Cc: linux-dvb@linuxtv.org
Date: Tuesday, October 14, 2008, 6:33 PM

Korey ODell wrote:
> Does reading this card's signal strength work for anyone? I've
tried femon, azap with the latest v4l drivers and a 2.6.26 kernel. Card reports
a lock and otherwise works fine but basically reports 0 for a strength reading.


There are two versions of this card -- one that uses a s5h1409, and the other
uses a s5h1411.  Which version do you have?

(dmesg output will indicate which board you have)

-Mike


--- On Tue, 10/14/08, Michael Krufky <mkrufky@linuxtv.org> wrote:
From: Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] Dvico HDTV7 Dual Express signal strength
To: korey_avail@yahoo.com
Cc: linux-dvb@linuxtv.org
Date: Tuesday, October 14, 2008, 6:33 PM

Korey ODell wrote:
> Does reading this card's signal strength work for anyone? I've
tried femon, azap with the latest v4l drivers and a 2.6.26 kernel. Card reports
a lock and otherwise works fine but basically reports 0 for a strength reading.


There are two versions of this card -- one that uses a s5h1409, and the other
uses a s5h1411.  Which version do you have?

(dmesg output will indicate which board you have)

-Mike



      
--0-468556043-1224078361=:54367
Content-Type: text/html; charset=us-ascii

<table cellspacing="0" cellpadding="0" border="0" ><tr><td valign="top" style="font: inherit;">I actually have both. <br>
The DViCO FusionHDTV 7 Gold [card=65] has the 1411 and the <br>
DViCO FusionHDTV7 Dual Express [card=10,autodetected] has the 1409.<br>
<br>
I can not read the signal strength on either of them.<br>
Here is what femon yields on the Gold card (1411)<br>
status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 | FE_HAS_LOCK<br>
status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 | FE_HAS_LOCK<br>
status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 | FE_HAS_LOCK<br>
<br>
recabling this same RF to a HDTV5 Gold card reports ~90-95% signal strength.<br><br>Thanks for any help.<br><br>--- On <b>Tue, 10/14/08, Michael Krufky <i>&lt;mkrufky@linuxtv.org&gt;</i></b> wrote:<br><blockquote style="border-left: 2px solid rgb(16, 16, 255); margin-left: 5px; padding-left: 5px;">From: Michael Krufky &lt;mkrufky@linuxtv.org&gt;<br>Subject: Re: [linux-dvb] Dvico HDTV7 Dual Express signal strength<br>To: korey_avail@yahoo.com<br>Cc: linux-dvb@linuxtv.org<br>Date: Tuesday, October 14, 2008, 6:33 PM<br><br><pre>Korey ODell wrote:<br>&gt; Does reading this card's signal strength work for anyone? I've<br>tried femon, azap with the latest v4l drivers and a 2.6.26 kernel. Card reports<br>a lock and otherwise works fine but basically reports 0 for a strength reading.<br><br><br>There are two versions of this card -- one that uses a s5h1409, and the other<br>uses a s5h1411.  Which version do you have?<br><br>(dmesg output will indicate which
 board you have)<br><br>-Mike<br></pre></blockquote><br><br>--- On <b>Tue, 10/14/08, Michael Krufky <i>&lt;mkrufky@linuxtv.org&gt;</i></b> wrote:<br><blockquote style="border-left: 2px solid rgb(16, 16, 255); margin-left: 5px; padding-left: 5px;">From: Michael Krufky &lt;mkrufky@linuxtv.org&gt;<br>Subject: Re: [linux-dvb] Dvico HDTV7 Dual Express signal strength<br>To: korey_avail@yahoo.com<br>Cc: linux-dvb@linuxtv.org<br>Date: Tuesday, October 14, 2008, 6:33 PM<br><br><pre>Korey ODell wrote:<br>&gt; Does reading this card's signal strength work for anyone? I've<br>tried femon, azap with the latest v4l drivers and a 2.6.26 kernel. Card reports<br>a lock and otherwise works fine but basically reports 0 for a strength reading.<br><br><br>There are two versions of this card -- one that uses a s5h1409, and the other<br>uses a s5h1411.  Which version do you have?<br><br>(dmesg output will indicate which board you
 have)<br><br>-Mike<br></pre></blockquote></td></tr></table><br>

      
--0-468556043-1224078361=:54367--



--===============0335919581==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0335919581==--
