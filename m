Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L0MOV-00032Q-GG
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 21:32:55 +0100
Received: by qw-out-2122.google.com with SMTP id 9so406189qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 12:32:51 -0800 (PST)
Message-ID: <c74595dc0811121232s48a95a14v93edf27360ed5c21@mail.gmail.com>
Date: Wed, 12 Nov 2008 22:32:51 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
	"Igor M. Liplianin" <liplianin@tut.by>
MIME-Version: 1.0
Subject: [linux-dvb] S2API tune return code - potential problem?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0272270832=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0272270832==
Content-Type: multipart/alternative;
	boundary="----=_Part_12832_30572124.1226521971352"

------=_Part_12832_30572124.1226521971352
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All,

A question regarding the error code returned from the driver when using
DTV_TUNE property.
Following the code I came to dvb_frontend_ioctl_legacy function and reached
the FE_SET_FRONTEND case.
Looking on the logic I couldn't see any handling of error tuning, an event
is added to the frontend and zero is returned:

        fepriv->state = FESTATE_RETUNE;
        dvb_frontend_wakeup(fe);
        dvb_frontend_add_event(fe, 0);
        fepriv->status = 0;
        err = 0;
        break;

How should an application know that DTV_TUNE command succeed?
Monitoring the LOCK bit is not good, here's an example why I ask the
question:

Assuming the cx24116 driver is locked on a channel. Application sends tune
command to another channel while specifying
AUTO settings for modulation and FEC. The driver for that chip cant handle
AUTO settings and return error, while its still connected
to previous channel. So in that case LOCK bit will be ON, while the tune
command was ignored.

I thought of an workaround to query the driver for locked frequency and
check whenever its in bounds of frequency that was ordered
to be tuned + - some delta, but that's a very dirty solution.

Any thoughts? Or I'm missing something?

Thanks.

------=_Part_12832_30572124.1226521971352
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi All,<br><br>A question regarding the error code returned from the driver when using DTV_TUNE property.<br>Following the code I came to dvb_frontend_ioctl_legacy function and reached the FE_SET_FRONTEND case.<br>

Looking on the logic I couldn&#39;t see any handling of error tuning, an event is added to the frontend and zero is returned:<br><br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;state = FESTATE_RETUNE;<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dvb_frontend_wakeup(fe);<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dvb_frontend_add_event(fe, 0);<br>

&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;status = 0;<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; err = 0;<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br><br>How should an application know that DTV_TUNE command succeed?<br>Monitoring the LOCK bit is not good, here&#39;s an example why I ask the question:<br>

<br>Assuming the cx24116 driver is locked on a channel. Application sends tune command to another channel while specifying<br>AUTO settings for modulation and FEC. The driver for that chip cant handle AUTO settings and return error, while its still connected<br>
to previous channel. So in that case LOCK bit will be ON, while the tune command was ignored.<br><br>I thought of an workaround to query the driver for locked frequency and check whenever its in bounds of frequency that was ordered <br>
to be tuned + - some delta, but that&#39;s a very dirty solution.<br><br>Any thoughts? Or I&#39;m missing something?<br><br>Thanks.<br><br><h1 class="YfMhcb"><span id=":186" class="VrHWId"><br></span></h1></div>

------=_Part_12832_30572124.1226521971352--


--===============0272270832==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0272270832==--
