Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <websdaleandrew@googlemail.com>) id 1K6YYH-00034c-R0
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 00:12:22 +0200
Received: by fg-out-1718.google.com with SMTP id e21so2340977fga.25
	for <linux-dvb@linuxtv.org>; Wed, 11 Jun 2008 15:12:16 -0700 (PDT)
Message-ID: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>
Date: Wed, 11 Jun 2008 23:12:15 +0100
From: "Andrew Websdale" <websdaleandrew@googlemail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1480951548=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1480951548==
Content-Type: multipart/alternative;
	boundary="----=_Part_17186_30987024.1213222335458"

------=_Part_17186_30987024.1213222335458
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/6/10 Antti Palosaari <crope@iki.fi>:

> Andrew Websdale wrote:
>
>> I've got a Dposh DVB-T USB2.0 (marked ATMT) and I've downloaded some
>> firmware ( which was v.difficult to find as the page in the wiki is blank)
>> which put the stick into a "warm" state i.e.
>>
>> dvb-usb: found a 'Dposh DVB-T USB2.0' in cold state, will try to load a
>> firmware
>> dvb-usb: downloading firmware from file 'dvb-usb-dposh-01.fw'
>> dvb_usb_m920x: probe of 5-1:1.0 failed with error 64
>> dvb-usb: found a 'Dposh DVB-T USB2.0' in warm state.
>> dvb-usb: will pass the complete MPEG2 transport stream to the software
>> demuxer.
>> dvb-usb: Dposh DVB-T USB2.0 successfully initialized and connected.
>> usbcore: registered new interface driver dvb_usb_m920x
>>
>> I've tried Kaffeine and w_scan to no avail, (WinXP gets a signal), I could
>> do with some advice on a)perhaps new firmware and b)help with how to use
>> dvbsnoop or similar to divine what is happening with this device as I lack
>> sufficient knowledge to proceed
>> Regards Andrew
>>
>
> There was someone asking this same some time ago. I think it could be
> possible that MT352 demodulator is changed to other one and it does not work
> due to that. Could you open the stick and check chips?
>
> Antti
> --
> http://palosaari.fi/




I got the front end info from dvbsnoop last night & it says its a Zarlink
MT352, but I should try to open the stick anyway to clear up exactly what
chips it uses, although I think its moulded plastics so I'll have to cut it
open. (@work now, will try later)
Andrew (sorry if I sent an email to you direct, Antii, I'm not sure how
Gmail handles mailing lists

------=_Part_17186_30987024.1213222335458
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/6/10 Antti Palosaari &lt;<a href="mailto:crope@iki.fi" target="_blank">crope@iki.fi</a>&gt;:<div><div class="Ih2E3d"><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

<div><div>Andrew Websdale wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I&#39;ve got a Dposh DVB-T USB2.0 (marked ATMT) and I&#39;ve downloaded some
firmware ( which was v.difficult to find as the page in the wiki is
blank) which put the stick into a &quot;warm&quot; state i.e.<br>
<br>
dvb-usb: found a &#39;Dposh DVB-T USB2.0&#39; in cold state, will try to load a firmware<br>
dvb-usb: downloading firmware from file &#39;dvb-usb-dposh-01.fw&#39;<br>
dvb_usb_m920x: probe of 5-1:1.0 failed with error 64<br>
dvb-usb: found a &#39;Dposh DVB-T USB2.0&#39; in warm state.<br>
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>
dvb-usb: Dposh DVB-T USB2.0 successfully initialized and connected.<br>
usbcore: registered new interface driver dvb_usb_m920x<br>
<br>
I&#39;ve tried Kaffeine and w_scan to no avail, (WinXP gets a signal), I
could do with some advice on a)perhaps new firmware and b)help with how
to use dvbsnoop or similar to divine what is happening with this device
as I lack sufficient knowledge to proceed<br>

Regards Andrew<br>
</blockquote>
<br></div></div>
There was someone asking this same some time ago. I think it could be
possible that MT352 demodulator is changed to other one and it does not
work due to that. Could you open the stick and check chips?<br>
<br>
Antti<br><font color="#888888">
-- <br>
<a href="http://palosaari.fi/" target="_blank">http://palosaari.fi/</a></font></blockquote></div></div><br><br><br>I
got the front end info from dvbsnoop last night &amp; it says its a
Zarlink MT352, but I should try to open the stick anyway to clear up
exactly what chips it uses, although I think its moulded plastics so
I&#39;ll have to cut it open. (@work now, will try later)<br>
Andrew (sorry if I sent an email to you direct, Antii, I&#39;m not sure how Gmail handles mailing lists<br>

------=_Part_17186_30987024.1213222335458--


--===============1480951548==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1480951548==--
