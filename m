Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KwyAD-00010r-DG
	for linux-dvb@linuxtv.org; Mon, 03 Nov 2008 13:04:12 +0100
Received: by qw-out-2122.google.com with SMTP id 9so1025832qwb.17
	for <linux-dvb@linuxtv.org>; Mon, 03 Nov 2008 04:04:04 -0800 (PST)
Message-ID: <c74595dc0811030404h7c6dc1cchf406f36e0c6962ec@mail.gmail.com>
Date: Mon, 3 Nov 2008 14:04:04 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Kovacs Balazs" <basq@bitklub.hu>
In-Reply-To: <167586304.20081103115116@bitklub.hu>
MIME-Version: 1.0
References: <167586304.20081103115116@bitklub.hu>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API + TT3200 + Amos4w 10.723 S2 problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2122356685=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2122356685==
Content-Type: multipart/alternative;
	boundary="----=_Part_50727_29757750.1225713844290"

------=_Part_50727_29757750.1225713844290
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have Twinhan 1041, same chipset as your card and I have the same behavior
with S2 channels.
Some can be locked, some can't. I think it's a known issue with stb0899
chips, I mean known here in the list.

Hope someone will be able to fix that. DVB-S2 scannint and locking is done
in the chip itself, so without knowledge of chip
internals it will be very hard to resolve that issue.

On Mon, Nov 3, 2008 at 12:51 PM, Kovacs Balazs <basq@bitklub.hu> wrote:

> Hi All!
>
>  I tried a few variation, but without any success:
>
>  I try to lock (stable! :)) on our new transponders at Amos 4W:
>
> 10,723(V) GHz, DVB-S2/8PSK, SR:30000, FEC:2/3, MPEG-4/Conax
> 10,759(V) GHz, DVB-S2/8PSK, SR:30000, FEC:2/3, MPEG-4/Conax
> 10,842(V) GHz, DVB-S2/8PSK, SR:30000, FEC:2/3, MPEG-4/Conax
>
> with a TT3200 card + Debian etch with 2.4.24 etchnhalf kernel + the current
> V4L-DVB mercurial drivers compiled.
>
>  The drivers recognizes my card, and for example it works good with
> Premiere's S2 transponders at Astra 19.2E.
>
> But it won't lock stable on our Amos's transponders.
>
>  FYI: on these TP's there's a pilot signal and rolloff set to 0.20. I tried
> to push these parameters to scan-s2 and szap-s2, but scan-s2 sometimes lock
> and sometimes won't on these transponders and also szap-s2 (after a few try
> to lock with scan-s2 and get the channels.conf from these transponders)
> sometimes locks, but it's not stable, it lost lock after a few seconds.
>
>  What I recognized also: if i run szap-s2 on our transponders it gives me
> the status message lines much slower than on other TP's.
>
> it almost always looks like this:
>
> /usr/src/dvb/s2api/szap-s2# ./szap-s2-thome.sh
> reading channels from file '/root/.szap/channels.conf'
> zapping to 1 '1':
> delivery DVB-S2, modulation 8PSK
> sat 0, frequency 10723 MHz V, symbolrate 30000000, coderate 2/3, rolloff
> 0.20
> vpid 0x00b3, apid 0x00b1, sid 0x00b4
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
> status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
> status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
> status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
> status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
> status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
> status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
>
> but sometimes it can lock, very rare...
>
> please, help me.
>
> thanks,
>
> Basq
>
>
>
>
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_50727_29757750.1225713844290
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div>I have Twinhan 1041, same chipset as your card and I have the same behavior with S2 channels.</div>
<div>Some can be locked, some can&#39;t. I think it&#39;s a known issue with stb0899 chips, I mean known here in the list.</div>
<div>&nbsp;</div>
<div>Hope someone will be able to fix that. DVB-S2 scannint and locking is done in the chip itself, so without knowledge of chip</div>
<div>internals it will be very hard to resolve that issue.<br><br></div>
<div class="gmail_quote">On Mon, Nov 3, 2008 at 12:51 PM, Kovacs Balazs <span dir="ltr">&lt;<a href="mailto:basq@bitklub.hu">basq@bitklub.hu</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Hi All!<br><br>&nbsp;I tried a few variation, but without any success:<br><br>&nbsp;I try to lock (stable! :)) on our new transponders at Amos 4W:<br>
<br>10,723(V) GHz, DVB-S2/8PSK, SR:30000, FEC:2/3, MPEG-4/Conax<br>10,759(V) GHz, DVB-S2/8PSK, SR:30000, FEC:2/3, MPEG-4/Conax<br>10,842(V) GHz, DVB-S2/8PSK, SR:30000, FEC:2/3, MPEG-4/Conax<br><br>with a TT3200 card + Debian etch with 2.4.24 etchnhalf kernel + the current V4L-DVB mercurial drivers compiled.<br>
<br>&nbsp;The drivers recognizes my card, and for example it works good with Premiere&#39;s S2 transponders at Astra 19.2E.<br><br>But it won&#39;t lock stable on our Amos&#39;s transponders.<br><br>&nbsp;FYI: on these TP&#39;s there&#39;s a pilot signal and rolloff set to 0.20. I tried to push these parameters to scan-s2 and szap-s2, but scan-s2 sometimes lock and sometimes won&#39;t on these transponders and also szap-s2 (after a few try to lock with scan-s2 and get the channels.conf from these transponders) sometimes locks, but it&#39;s not stable, it lost lock after a few seconds.<br>
<br>&nbsp;What I recognized also: if i run szap-s2 on our transponders it gives me the status message lines much slower than on other TP&#39;s.<br><br>it almost always looks like this:<br><br>/usr/src/dvb/s2api/szap-s2# ./szap-s2-thome.sh<br>
reading channels from file &#39;/root/.szap/channels.conf&#39;<br>zapping to 1 &#39;1&#39;:<br>delivery DVB-S2, modulation 8PSK<br>sat 0, frequency 10723 MHz V, symbolrate 30000000, coderate 2/3, rolloff 0.20<br>vpid 0x00b3, apid 0x00b1, sid 0x00b4<br>
using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |<br>status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |<br>
status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |<br>status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |<br>status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |<br>status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |<br>
status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |<br><br>but sometimes it can lock, very rare...<br><br>please, help me.<br><br>thanks,<br><br>Basq<br><br><br><br><br><br><br><br>_______________________________________________<br>
linux-dvb mailing list<br><a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br></div>

------=_Part_50727_29757750.1225713844290--


--===============2122356685==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2122356685==--
