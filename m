Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JQQ7h-0000mr-M6
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 17:42:45 +0100
Received: by fg-out-1718.google.com with SMTP id 22so768633fge.25
	for <linux-dvb@linuxtv.org>; Sat, 16 Feb 2008 08:42:45 -0800 (PST)
Message-ID: <ea4209750802160842w28bfcd45m99308f38997c7a7a@mail.gmail.com>
Date: Sat, 16 Feb 2008 17:42:44 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <ea4209750802160638k387fba4dtd422f250fa79be7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_18152_25039298.1203180164959"
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802141220s2402e94bvbd1479037d48cfc8@mail.gmail.com>
	<20080215181815.2583a2e5@gaivota>
	<200802152233.25423.dehnhardt@ahdehnhardt.de>
	<Pine.LNX.4.64.0802152241520.29944@pub5.ifh.de>
	<ea4209750802151543y16c7eefawf634cf194d6e3aa1@mail.gmail.com>
	<ea4209750802160638k387fba4dtd422f250fa79be7d@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_18152_25039298.1203180164959
Content-Type: multipart/alternative;
	boundary="----=_Part_18153_13685949.1203180164959"

------=_Part_18153_13685949.1203180164959
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

More information... I attach a dmesg of tuner-xc2028 loaded in debug mode
while doing a scan ( scan es-Collserola|tee channels.conf ). I don't see any
problem, but it doesn't work.

Albert

2008/2/16, Albert Comerma <albert.comerma@gmail.com>:
>
> For what I understand, changing the Firmware 64 to 60000200 changes the if
> frequency to 5.2MHz. So this modification on the firmware should make the
> card work. What it's more strange for me is that when trying to scan no
> signal or SNR is reported, so it seems like xc3028 firmware is not working
> properly. Perhaps could be a wrong BASE or DTV firmware loaded?
>
> Albert
>
> 2008/2/16, Albert Comerma <albert.comerma@gmail.com>:
> >
> > So, If it's not a problem, any of you could send me the current xc3028
> > firmware you are using, because mine does not seem to work... Thanks.
> >
> > Albert
> >
> > 2008/2/15, Patrick Boettcher <patrick.boettcher@desy.de>:
> > >
> > > Aah now I remember that issue, in fact it is no issue. I was seeing
> > > that
> > > problem when send the sleep command or any other firmware command
> > > without
> > > having a firmware running. In was, so far, no problem.
> > >
> > > Patrick.
> > >
> > >
> > >
> > > On Fri, 15 Feb 2008, Holger Dehnhardt wrote:
> > >
> > > > Hi Albert, Hi Mauro,
> > > >
> > > > I have successfulli patched and compiled the driver. Im using the
> > > terratec
> > > > cinergy device and it works fine.
> > > >
> > > >>> [ 2251.856000] xc2028 4-0061: Error on line 1063: -5
> > > >
> > > > This error message looked very familar to me, so i searched my log
> > > and guess
> > > > what I found:
> > > >
> > > > Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
> > > > Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
> > > > Feb 15 20:42:18 musik kernel: xc2028 3-0061: Error on line 1064: -5
> > > > Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for
> > > demod df75e800
> > > > to 0
> > > > Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for
> > > demod df75e800
> > > > to 0
> > > >
> > > > It identifies the marked line (just to be sure because of the
> > > differen line
> > > > numbers)
> > > >
> > > >       if (priv->firm_version < 0x0202)
> > > > ->            rc = send_seq(priv, {0x00, 0x08, 0x00, 0x00});
> > > >       else
> > > >               rc = send_seq(priv, {0x80, 0x08, 0x00, 0x00});
> > > >
> > > >> The above error is really weird. It seems to be related to
> > > something that
> > > >> happened before xc2028, since firmware load didn't start on that
> > > point of
> > > >> the code.
> > > >
> > > > The error really is weird, but it does not seem to cause the
> > > troubles - my
> > > > card works despite the error!
> > > >
> > > >>
> > > >>> [ 2289.284000] xc2028 4-0061: Device is Xceive 3028 version 1.0,
> > > firmware
> > > >>> version 2.7
> > > >>
> > > >> This message means that xc3028 firmware were successfully loaded
> > > and it is
> > > >> running ok.
> > > >
> > > > This and the following messages look similar...
> > > >
> > > > Holger
> > > >
> > > > _______________________________________________
> > > > linux-dvb mailing list
> > > > linux-dvb@linuxtv.org
> > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > >
> > >
> > > _______________________________________________
> > > linux-dvb mailing list
> > > linux-dvb@linuxtv.org
> > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > >
> >
> >
>

------=_Part_18153_13685949.1203180164959
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

More information... I attach a dmesg of tuner-xc2028 loaded in debug mode while doing a scan ( scan es-Collserola|tee channels.conf ). I don&#39;t see any problem, but it doesn&#39;t work.<br><br>Albert<br><br><div><span class="gmail_quote">2008/2/16, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
For what I understand, changing the Firmware 64 to 60000200 changes the if frequency to 5.2MHz. So this modification on the firmware should make the card work. What it&#39;s more strange for me is that when trying to scan no signal or SNR is reported, so it seems like xc3028 firmware is not working properly. Perhaps could be a wrong BASE or DTV firmware loaded?<br>

<br>Albert<br><br><div><span class="gmail_quote">2008/2/16, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">albert.comerma@gmail.com</a>&gt;:</span><div>
<span class="e" id="q_11822aeb03660eda_1"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
So, If it&#39;s not a problem, any of you could send me the current xc3028 firmware you are using, because mine does not seem to work... Thanks.<br><br>Albert<br><br><div><span class="gmail_quote">2008/2/15, Patrick Boettcher &lt;<a href="mailto:patrick.boettcher@desy.de" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">patrick.boettcher@desy.de</a>&gt;:</span><div>

<span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Aah now I remember that issue, in fact it is no issue. I was seeing that<br>problem when send the sleep command or any other firmware command without<br>having a firmware running. In was, so far, no problem.<br><br>Patrick.<br>


<br><br><br>On Fri, 15 Feb 2008, Holger Dehnhardt wrote:<br><br>&gt; Hi Albert, Hi Mauro,<br>&gt;<br>&gt; I have successfulli patched and compiled the driver. Im using the terratec<br>&gt; cinergy device and it works fine.<br>


&gt;<br>&gt;&gt;&gt; [ 2251.856000] xc2028 4-0061: Error on line 1063: -5<br>&gt;<br>&gt; This error message looked very familar to me, so i searched my log and guess<br>&gt; what I found:<br>&gt;<br>&gt; Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called<br>


&gt; Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called<br>&gt; Feb 15 20:42:18 musik kernel: xc2028 3-0061: Error on line 1064: -5<br>&gt; Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for demod df75e800<br>


&gt; to 0<br>&gt; Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for demod df75e800<br>&gt; to 0<br>&gt;<br>&gt; It identifies the marked line (just to be sure because of the differen line<br>&gt; numbers)<br>


&gt;<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (priv-&gt;firm_version &lt; 0x0202)<br>&gt; -&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;rc = send_seq(priv, {0x00, 0x08, 0x00, 0x00});<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rc = send_seq(priv, {0x80, 0x08, 0x00, 0x00});<br>


&gt;<br>&gt;&gt; The above error is really weird. It seems to be related to something that<br>&gt;&gt; happened before xc2028, since firmware load didn&#39;t start on that point of<br>&gt;&gt; the code.<br>&gt;<br>&gt; The error really is weird, but it does not seem to cause the troubles - my<br>


&gt; card works despite the error!<br>&gt;<br>&gt;&gt;<br>&gt;&gt;&gt; [ 2289.284000] xc2028 4-0061: Device is Xceive 3028 version 1.0, firmware<br>&gt;&gt;&gt; version 2.7<br>&gt;&gt;<br>&gt;&gt; This message means that xc3028 firmware were successfully loaded and it is<br>


&gt;&gt; running ok.<br>&gt;<br>&gt; This and the following messages look similar...<br>&gt;<br>&gt; Holger<br>&gt;<br>&gt; _______________________________________________<br>&gt; linux-dvb mailing list<br>&gt; <a href="mailto:linux-dvb@linuxtv.org" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">linux-dvb@linuxtv.org</a><br>


&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>&gt;<br><br>

_______________________________________________<br>linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">linux-dvb@linuxtv.org</a><br><a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>

</blockquote></span></div></div><br>
</blockquote></span></div></div><br>
</blockquote></div><br>

------=_Part_18153_13685949.1203180164959--

------=_Part_18152_25039298.1203180164959
Content-Type: text/plain; name=dmesg.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcqeeb3x
Content-Disposition: attachment; filename=dmesg.txt

WyAyMTk3LjcwODAwMF0gdXNiIDYtMTogbmV3IGhpZ2ggc3BlZWQgVVNCIGRldmljZSB1c2luZyBl
aGNpX2hjZCBhbmQgYWRkcmVzcyA0ClsgMjE5Ny44NDAwMDBdIHVzYiA2LTE6IGNvbmZpZ3VyYXRp
b24gIzEgY2hvc2VuIGZyb20gMSBjaG9pY2UKWyAyMTk3Ljg0MDAwMF0gZHZiLXVzYjogZm91bmQg
YSAnUGlubmFjbGUgRXhwcmVzc2NhcmQgMzIwY3gnIGluIGNvbGQgc3RhdGUsIHdpbGwgdHJ5IHRv
IGxvYWQgYSBmaXJtd2FyZQpbIDIxOTcuODQ0MDAwXSBkdmItdXNiOiBkb3dubG9hZGluZyBmaXJt
d2FyZSBmcm9tIGZpbGUgJ2R2Yi11c2ItZGliMDcwMC0xLjEwLmZ3JwpbIDIxOTguMDQ4MDAwXSBk
aWIwNzAwOiBmaXJtd2FyZSBzdGFydGVkIHN1Y2Nlc3NmdWxseS4KWyAyMTk4LjU1MjAwMF0gZHZi
LXVzYjogZm91bmQgYSAnUGlubmFjbGUgRXhwcmVzc2NhcmQgMzIwY3gnIGluIHdhcm0gc3RhdGUu
ClsgMjE5OC41NTIwMDBdIGR2Yi11c2I6IHdpbGwgcGFzcyB0aGUgY29tcGxldGUgTVBFRzIgdHJh
bnNwb3J0IHN0cmVhbSB0byB0aGUgc29mdHdhcmUgZGVtdXhlci4KWyAyMTk4LjU1MjAwMF0gRFZC
OiByZWdpc3RlcmluZyBuZXcgYWRhcHRlciAoUGlubmFjbGUgRXhwcmVzc2NhcmQgMzIwY3gpClsg
MjE5OC45MjAwMDBdIERWQjogcmVnaXN0ZXJpbmcgZnJvbnRlbmQgMCAoRGlCY29tIDcwMDBQQyku
Li4KWyAyMTk4LjkyMDAwMF0geGMyMDI4OiBYY3YyMDI4LzMwMjggaW5pdCBjYWxsZWQhClsgMjE5
OC45MjAwMDBdIHhjMjAyOCA0LTAwNjE6IHR5cGUgc2V0IHRvIFhDZWl2ZSB4YzIwMjgveGMzMDI4
IHR1bmVyClsgMjE5OC45MjAwMDBdIHhjMjAyOCA0LTAwNjE6IHhjMjAyOF9zZXRfY29uZmlnIGNh
bGxlZApbIDIxOTguOTIwMDAwXSBpbnB1dDogSVItcmVjZWl2ZXIgaW5zaWRlIGFuIFVTQiBEVkIg
cmVjZWl2ZXIgYXMgL2NsYXNzL2lucHV0L2lucHV0MTEKWyAyMTk4LjkyMDAwMF0gZHZiLXVzYjog
c2NoZWR1bGUgcmVtb3RlIHF1ZXJ5IGludGVydmFsIHRvIDE1MCBtc2Vjcy4KWyAyMTk4LjkyMDAw
MF0gZHZiLXVzYjogUGlubmFjbGUgRXhwcmVzc2NhcmQgMzIwY3ggc3VjY2Vzc2Z1bGx5IGluaXRp
YWxpemVkIGFuZCBjb25uZWN0ZWQuClsgMjIyMy45MzYwMDBdIHhjMjAyOCA0LTAwNjE6IHhjMjAy
OF9zZXRfcGFyYW1zIGNhbGxlZApbIDIyMjMuOTM2MDAwXSB4YzIwMjggNC0wMDYxOiBnZW5lcmlj
X3NldF9mcmVxIGNhbGxlZApbIDIyMjMuOTM2MDAwXSB4YzIwMjggNC0wMDYxOiBzaG91bGQgc2V0
IGZyZXF1ZW5jeSA1MTQwMDAga0h6ClsgMjIyMy45MzYwMDBdIHhjMjAyOCA0LTAwNjE6IGNoZWNr
X2Zpcm13YXJlIGNhbGxlZApbIDIyMjMuOTM2MDAwXSB4YzIwMjggNC0wMDYxOiBsb2FkX2FsbF9m
aXJtd2FyZXMgY2FsbGVkClsgMjIyMy45MzYwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmly
bXdhcmUgeGMzMDI4LXYyNy5mdwpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBMb2FkaW5n
IDgwIGZpcm13YXJlIGltYWdlcyBmcm9tIHhjMzAyOC12MjcuZncsIHR5cGU6IHhjMjAyOCBmaXJt
d2FyZSwgdmVyIDIuNwpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13
YXJlIHR5cGUgQkFTRSBGOE1IWiAoMyksIGlkIDAsIHNpemU9ODcxOC4KWyAyMjIzLjk0MDAwMF0g
eGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIEJBU0UgRjhNSFogTVRTICg3KSwg
aWQgMCwgc2l6ZT04NzEyLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZp
cm13YXJlIHR5cGUgQkFTRSBGTSAoNDAxKSwgaWQgMCwgc2l6ZT04NTYyLgpbIDIyMjMuOTQwMDAw
XSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgQkFTRSBGTSBJTlBVVDEgKGMw
MSksIGlkIDAsIHNpemU9ODU3Ni4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTogUmVhZGlu
ZyBmaXJtd2FyZSB0eXBlIEJBU0UgKDEpLCBpZCAwLCBzaXplPTg3MDYuClsgMjIyMy45NDAwMDBd
IHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBCQVNFIE1UUyAoNSksIGlkIDAs
IHNpemU9ODY4Mi4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2Fy
ZSB0eXBlICgwKSwgaWQgMTAwMDAwMDA3LCBzaXplPTE2MS4KWyAyMjIzLjk0MDAwMF0geGMyMDI4
IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIE1UUyAoNCksIGlkIDEwMDAwMDAwNywgc2l6
ZT0xNjkuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlw
ZSAoMCksIGlkIDIwMDAwMDAwNywgc2l6ZT0xNjEuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAw
NjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNVFMgKDQpLCBpZCAyMDAwMDAwMDcsIHNpemU9MTY5
LgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgKDAp
LCBpZCA0MDAwMDAwMDcsIHNpemU9MTYxLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBS
ZWFkaW5nIGZpcm13YXJlIHR5cGUgTVRTICg0KSwgaWQgNDAwMDAwMDA3LCBzaXplPTE2OS4KWyAy
MjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQg
ODAwMDAwMDA3LCBzaXplPTE2MS4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTogUmVhZGlu
ZyBmaXJtd2FyZSB0eXBlIE1UUyAoNCksIGlkIDgwMDAwMDAwNywgc2l6ZT0xNjkuClsgMjIyMy45
NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSAoMCksIGlkIDMwMDAw
MDBlMCwgc2l6ZT0xNjEuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmly
bXdhcmUgdHlwZSBNVFMgKDQpLCBpZCAzMDAwMDAwZTAsIHNpemU9MTY5LgpbIDIyMjMuOTQwMDAw
XSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgKDApLCBpZCBjMDAwMDAwZTAs
IHNpemU9MTYxLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJl
IHR5cGUgTVRTICg0KSwgaWQgYzAwMDAwMGUwLCBzaXplPTE2OS4KWyAyMjIzLjk0MDAwMF0geGMy
MDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQgMjAwMDAwLCBzaXplPTE2
MS4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIE1U
UyAoNCksIGlkIDIwMDAwMCwgc2l6ZT0xNjkuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6
IFJlYWRpbmcgZmlybXdhcmUgdHlwZSAoMCksIGlkIDQwMDAwMDAsIHNpemU9MTYxLgpbIDIyMjMu
OTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgTVRTICg0KSwgaWQg
NDAwMDAwMCwgc2l6ZT0xNjkuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcg
ZmlybXdhcmUgdHlwZSBEMjYzMyBEVFY2IEFUU0MgKDEwMDMwKSwgaWQgMCwgc2l6ZT0xNDkuClsg
MjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBEMjYyMCBE
VFY2IFFBTSAoNjgpLCBpZCAwLCBzaXplPTE0OS4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2
MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIEQyNjMzIERUVjYgUUFNICg3MCksIGlkIDAsIHNpemU9
MTQ5LgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUg
RDI2MjAgRFRWNyAoODgpLCBpZCAwLCBzaXplPTE0OS4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQt
MDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIEQyNjMzIERUVjcgKDkwKSwgaWQgMCwgc2l6ZT0x
NDkuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBE
MjYyMCBEVFY3OCAoMTA4KSwgaWQgMCwgc2l6ZT0xNDkuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0
LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBEMjYzMyBEVFY3OCAoMTEwKSwgaWQgMCwgc2l6
ZT0xNDkuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlw
ZSBEMjYyMCBEVFY4ICgyMDgpLCBpZCAwLCBzaXplPTE0OS4KWyAyMjIzLjk0MDAwMF0geGMyMDI4
IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIEQyNjMzIERUVjggKDIxMCksIGlkIDAsIHNp
emU9MTQ5LgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5
cGUgRk0gKDQwMCksIGlkIDAsIHNpemU9MTM1LgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYx
OiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgKDApLCBpZCAxMCwgc2l6ZT0xNjEuClsgMjIyMy45NDAw
MDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNVFMgKDQpLCBpZCAxMCwg
c2l6ZT0xNjkuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUg
dHlwZSAoMCksIGlkIDEwMDA0MDAwMDAsIHNpemU9MTY5LgpbIDIyMjMuOTQwMDAwXSB4YzIwMjgg
NC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgKDApLCBpZCBjMDA0MDAwMDAsIHNpemU9MTYx
LgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgKDAp
LCBpZCA4MDAwMDAsIHNpemU9MTYxLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFk
aW5nIGZpcm13YXJlIHR5cGUgKDApLCBpZCA4MDAwLCBzaXplPTE2MS4KWyAyMjIzLjk0MDAwMF0g
eGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIExDRCAoMTAwMCksIGlkIDgwMDAs
IHNpemU9MTYxLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJl
IHR5cGUgTENEIE5PR0QgKDMwMDApLCBpZCA4MDAwLCBzaXplPTE2MS4KWyAyMjIzLjk0MDAwMF0g
eGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIE1UUyAoNCksIGlkIDgwMDAsIHNp
emU9MTY5LgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5
cGUgKDApLCBpZCBiNzAwLCBzaXplPTE2MS4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTog
UmVhZGluZyBmaXJtd2FyZSB0eXBlIExDRCAoMTAwMCksIGlkIGI3MDAsIHNpemU9MTYxLgpbIDIy
MjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgTENEIE5PR0Qg
KDMwMDApLCBpZCBiNzAwLCBzaXplPTE2MS4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTog
UmVhZGluZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQgMjAwMCwgc2l6ZT0xNjEuClsgMjIyMy45NDAw
MDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNVFMgKDQpLCBpZCBiNzAw
LCBzaXplPTE2OS4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2Fy
ZSB0eXBlIE1UUyBMQ0QgKDEwMDQpLCBpZCBiNzAwLCBzaXplPTE2OS4KWyAyMjIzLjk0MDAwMF0g
eGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIE1UUyBMQ0QgTk9HRCAoMzAwNCks
IGlkIGI3MDAsIHNpemU9MTY5LgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5n
IGZpcm13YXJlIHR5cGUgU0NPREUgSEFTX0lGXzMyODAgKDYwMDAwMDAwKSwgaWQgMCwgc2l6ZT0x
OTIuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBT
Q09ERSBIQVNfSUZfMzMwMCAoNjAwMDAwMDApLCBpZCAwLCBzaXplPTE5Mi4KWyAyMjIzLjk0MDAw
MF0geGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIFNDT0RFIEhBU19JRl8zNDQw
ICg2MDAwMDAwMCksIGlkIDAsIHNpemU9MTkyLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYx
OiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgU0NPREUgSEFTX0lGXzM0NjAgKDYwMDAwMDAwKSwgaWQg
MCwgc2l6ZT0xOTIuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdh
cmUgdHlwZSBEVFY2IEFUU0MgT1JFTjM2IFNDT0RFIEhBU19JRl8zODAwICg2MDIxMDAyMCksIGlk
IDAsIHNpemU9MTkyLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13
YXJlIHR5cGUgU0NPREUgSEFTX0lGXzQwMDAgKDYwMDAwMDAwKSwgaWQgMCwgc2l6ZT0xOTIuClsg
MjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBEVFY2IEFU
U0MgVE9ZT1RBMzg4IFNDT0RFIEhBU19JRl80MDgwICg2MDQxMDAyMCksIGlkIDAsIHNpemU9MTky
LgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgU0NP
REUgSEFTX0lGXzQyMDAgKDYwMDAwMDAwKSwgaWQgMCwgc2l6ZT0xOTIuClsgMjIyMy45NDAwMDBd
IHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNT05PIFNDT0RFIEhBU19JRl80
MzIwICg2MDAwODAwMCksIGlkIDgwMDAsIHNpemU9MTkyLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjgg
NC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgU0NPREUgSEFTX0lGXzQ0NTAgKDYwMDAwMDAw
KSwgaWQgMCwgc2l6ZT0xOTIuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcg
ZmlybXdhcmUgdHlwZSBTQ09ERSBIQVNfSUZfNDUwMCAoNjAwMDAwMDApLCBpZCAyMDAwLCBzaXpl
PTE5Mi4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBl
IExDRCBOT0dEIElGIFNDT0RFIEhBU19JRl80NjAwICg2MDAyMzAwMCksIGlkIDgwMDAsIHNpemU9
MTkyLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUg
RFRWNzggWkFSTElOSzQ1NiBTQ09ERSBIQVNfSUZfNDc2MCAoNjIwMDAxMDApLCBpZCAwLCBzaXpl
PTE5Mi4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBl
IFNDT0RFIEhBU19JRl80OTQwICg2MDAwMDAwMCksIGlkIDAsIHNpemU9MTkyLgpbIDIyMjMuOTQw
MDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgRFRWNyBaQVJMSU5LNDU2
IFNDT0RFIEhBU19JRl81MjYwICg2MjAwMDA4MCksIGlkIDAsIHNpemU9MTkyLgpbIDIyMjMuOTQw
MDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgTU9OTyBTQ09ERSBIQVNf
SUZfNTMyMCAoNjAwMDgwMDApLCBpZCA4MDAwMDAwMDcsIHNpemU9MTkyLgpbIDIyMjMuOTQwMDAw
XSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgRFRWOCBTQ09ERSBIQVNfSUZf
NTQwMCAoNjAwMDAyMDApLCBpZCAwLCBzaXplPTE5Mi4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQt
MDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIERUVjYgQVRTQyBPUkVONTM4IFNDT0RFIEhBU19J
Rl81NTgwICg2MDExMDAyMCksIGlkIDAsIHNpemU9MTkyLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjgg
NC0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgU0NPREUgSEFTX0lGXzU2NDAgKDYwMDAwMDAw
KSwgaWQgMjAwMDAwMDA3LCBzaXplPTE5Mi4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTog
UmVhZGluZyBmaXJtd2FyZSB0eXBlIFNDT0RFIEhBU19JRl81NzQwICg2MDAwMDAwMCksIGlkIDgw
MDAwMDAwNywgc2l6ZT0xOTIuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcg
ZmlybXdhcmUgdHlwZSBEVFY3IERJQkNPTTUyIFNDT0RFIEhBU19JRl81OTAwICg2MTAwMDA4MCks
IGlkIDAsIHNpemU9MTkyLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5nIGZp
cm13YXJlIHR5cGUgTU9OTyBTQ09ERSBIQVNfSUZfNjAwMCAoNjAwMDgwMDApLCBpZCAxMCwgc2l6
ZT0xOTIuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlw
ZSBEVFY2IFFBTSBGNk1IWiBTQ09ERSBIQVNfSUZfNjIwMCAoNjgwMDAwNjApLCBpZCAwLCBzaXpl
PTE5Mi4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBl
IFNDT0RFIEhBU19JRl82MjQwICg2MDAwMDAwMCksIGlkIDEwLCBzaXplPTE5Mi4KWyAyMjIzLjk0
MDAwMF0geGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIE1PTk8gU0NPREUgSEFT
X0lGXzYzMjAgKDYwMDA4MDAwKSwgaWQgMjAwMDAwLCBzaXplPTE5Mi4KWyAyMjIzLjk0MDAwMF0g
eGMyMDI4IDQtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIFNDT0RFIEhBU19JRl82MzQwICg2
MDAwMDAwMCksIGlkIDIwMDAwMCwgc2l6ZT0xOTIuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAw
NjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNT05PIFNDT0RFIEhBU19JRl82NTAwICg2MDAwODAw
MCksIGlkIDQwMDAwMDAsIHNpemU9MTkyLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBS
ZWFkaW5nIGZpcm13YXJlIHR5cGUgRFRWNiBBVFNDIEFUSTYzOCBTQ09ERSBIQVNfSUZfNjU4MCAo
NjAwOTAwMjApLCBpZCAwLCBzaXplPTE5Mi4KWyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTog
UmVhZGluZyBmaXJtd2FyZSB0eXBlIFNDT0RFIEhBU19JRl82NjAwICg2MDAwMDAwMCksIGlkIDMw
MDAwMDBlMCwgc2l6ZT0xOTIuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcg
ZmlybXdhcmUgdHlwZSBNT05PIFNDT0RFIEhBU19JRl82NjgwICg2MDAwODAwMCksIGlkIDMwMDAw
MDBlMCwgc2l6ZT0xOTIuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IFJlYWRpbmcgZmly
bXdhcmUgdHlwZSBEVFY2IEFUU0MgVE9ZT1RBNzk0IFNDT0RFIEhBU19JRl84MTQwICg2MDgxMDAy
MCksIGlkIDAsIHNpemU9MTkyLgpbIDIyMjMuOTQwMDAwXSB4YzIwMjggNC0wMDYxOiBSZWFkaW5n
IGZpcm13YXJlIHR5cGUgU0NPREUgSEFTX0lGXzgyMDAgKDYwMDAwMDAwKSwgaWQgMCwgc2l6ZT0x
OTIuClsgMjIyMy45NDAwMDBdIHhjMjAyOCA0LTAwNjE6IEZpcm13YXJlIGZpbGVzIGxvYWRlZC4K
WyAyMjIzLjk0MDAwMF0geGMyMDI4IDQtMDA2MTogY2hlY2tpbmcgZmlybXdhcmUsIHVzZXIgcmVx
dWVzdGVkIHR5cGU9RjhNSFogRDI2MjAgRFRWOCAoMjBhKSwgaWQgMDAwMDAwMDAwMDAwMDAwMCwg
c2NvZGVfdGJsICgwKSwgc2NvZGVfbnIgMApbIDIyMjMuOTQwMDAwXSBkaWIwNzAwOiBzdGs3NzAw
cGhfeGMzMDI4X2NhbGxiYWNrOiBYQzIwMjhfVFVORVJfUkVTRVQgMApbIDIyMjMuOTQwMDAwXSAK
WyAyMjIzLjk2ODAwMF0geGMyMDI4IDQtMDA2MTogbG9hZF9maXJtd2FyZSBjYWxsZWQKWyAyMjIz
Ljk2ODAwMF0geGMyMDI4IDQtMDA2MTogc2Vla19maXJtd2FyZSBjYWxsZWQsIHdhbnQgdHlwZT1C
QVNFIEY4TUhaIEQyNjIwIERUVjggKDIwYiksIGlkIDAwMDAwMDAwMDAwMDAwMDAuClsgMjIyMy45
NjgwMDBdIHhjMjAyOCA0LTAwNjE6IEZvdW5kIGZpcm13YXJlIGZvciB0eXBlPUJBU0UgRjhNSFog
KDMpLCBpZCAwMDAwMDAwMDAwMDAwMDAwLgpbIDIyMjMuOTY4MDAwXSB4YzIwMjggNC0wMDYxOiBM
b2FkaW5nIGZpcm13YXJlIGZvciB0eXBlPUJBU0UgRjhNSFogKDMpLCBpZCAwMDAwMDAwMDAwMDAw
MDAwLgpbIDIyMjMuOTY4MDAwXSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxiYWNrOiBY
QzIwMjhfVFVORVJfUkVTRVQgMApbIDIyMjMuOTY4MDAwXSAKWyAyMjMwLjQ5MjAwMF0geGMyMDI4
IDQtMDA2MTogTG9hZCBpbml0MSBmaXJtd2FyZSwgaWYgZXhpc3RzClsgMjIzMC40OTIwMDBdIHhj
MjAyOCA0LTAwNjE6IGxvYWRfZmlybXdhcmUgY2FsbGVkClsgMjIzMC40OTIwMDBdIHhjMjAyOCA0
LTAwNjE6IHNlZWtfZmlybXdhcmUgY2FsbGVkLCB3YW50IHR5cGU9QkFTRSBJTklUMSBGOE1IWiBE
MjYyMCBEVFY4ICg0MjBiKSwgaWQgMDAwMDAwMDAwMDAwMDAwMC4KWyAyMjMwLjQ5MjAwMF0geGMy
MDI4IDQtMDA2MTogQ2FuJ3QgZmluZCBmaXJtd2FyZSBmb3IgdHlwZT1CQVNFIElOSVQxIEY4TUha
ICg0MDAzKSwgaWQgMDAwMDAwMDAwMDAwMDAwMC4KWyAyMjMwLjQ5MjAwMF0geGMyMDI4IDQtMDA2
MTogbG9hZF9maXJtd2FyZSBjYWxsZWQKWyAyMjMwLjQ5MjAwMF0geGMyMDI4IDQtMDA2MTogc2Vl
a19maXJtd2FyZSBjYWxsZWQsIHdhbnQgdHlwZT1CQVNFIElOSVQxIEQyNjIwIERUVjggKDQyMDkp
LCBpZCAwMDAwMDAwMDAwMDAwMDAwLgpbIDIyMzAuNDkyMDAwXSB4YzIwMjggNC0wMDYxOiBDYW4n
dCBmaW5kIGZpcm13YXJlIGZvciB0eXBlPUJBU0UgSU5JVDEgKDQwMDEpLCBpZCAwMDAwMDAwMDAw
MDAwMDAwLgpbIDIyMzAuNDkyMDAwXSB4YzIwMjggNC0wMDYxOiBsb2FkX2Zpcm13YXJlIGNhbGxl
ZApbIDIyMzAuNDkyMDAwXSB4YzIwMjggNC0wMDYxOiBzZWVrX2Zpcm13YXJlIGNhbGxlZCwgd2Fu
dCB0eXBlPUY4TUhaIEQyNjIwIERUVjggKDIwYSksIGlkIDAwMDAwMDAwMDAwMDAwMDAuClsgMjIz
MC40OTIwMDBdIHhjMjAyOCA0LTAwNjE6IEZvdW5kIGZpcm13YXJlIGZvciB0eXBlPUQyNjIwIERU
VjggKDIwOCksIGlkIDAwMDAwMDAwMDAwMDAwMDAuClsgMjIzMC40OTIwMDBdIHhjMjAyOCA0LTAw
NjE6IExvYWRpbmcgZmlybXdhcmUgZm9yIHR5cGU9RDI2MjAgRFRWOCAoMjA4KSwgaWQgMDAwMDAw
MDAwMDAwMDAwMC4KWyAyMjMwLjYwNDAwMF0geGMyMDI4IDQtMDA2MTogVHJ5aW5nIHRvIGxvYWQg
c2NvZGUgMApbIDIyMzAuNjA0MDAwXSB4YzIwMjggNC0wMDYxOiBsb2FkX3Njb2RlIGNhbGxlZApb
IDIyMzAuNjA0MDAwXSB4YzIwMjggNC0wMDYxOiBzZWVrX2Zpcm13YXJlIGNhbGxlZCwgd2FudCB0
eXBlPUY4TUhaIEQyNjIwIERUVjggU0NPREUgKDIwMDAwMjBhKSwgaWQgMDAwMDAwMDAwMDAwMDAw
MC4KWyAyMjMwLjYwNDAwMF0geGMyMDI4IDQtMDA2MTogRm91bmQgZmlybXdhcmUgZm9yIHR5cGU9
RFRWOCBTQ09ERSAoMjAwMDAyMDApLCBpZCAwMDAwMDAwMDAwMDAwMDAwLgpbIDIyMzAuNjA0MDAw
XSB4YzIwMjggNC0wMDYxOiBMb2FkaW5nIFNDT0RFIGZvciB0eXBlPURUVjggU0NPREUgSEFTX0lG
XzU0MDAgKDYwMDAwMjAwKSwgaWQgMDAwMDAwMDAwMDAwMDAwMC4KWyAyMjMwLjY1MjAwMF0geGMy
MDI4IDQtMDA2MTogeGMyMDI4X2dldF9yZWcgMDAwNCBjYWxsZWQKWyAyMjMwLjY1NjAwMF0geGMy
MDI4IDQtMDA2MTogeGMyMDI4X2dldF9yZWcgMDAwOCBjYWxsZWQKWyAyMjMwLjY2MDAwMF0geGMy
MDI4IDQtMDA2MTogRGV2aWNlIGlzIFhjZWl2ZSAzMDI4IHZlcnNpb24gMS4wLCBmaXJtd2FyZSB2
ZXJzaW9uIDIuNwpbIDIyMzAuNjg0MDAwXSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxi
YWNrOiBYQzIwMjhfUkVTRVRfQ0xLIDEKWyAyMjMwLjY4NDAwMF0gClsgMjIzMC44MDgwMDBdIHhj
MjAyOCA0LTAwNjE6IGRpdmlzb3I9IDAwIDAwIDdmIGQwIChmcmVxPTUxNC4wMDApClsgMjIzMi4x
OTYwMDBdIHhjMjAyOCA0LTAwNjE6IHhjMjAyOF9zZXRfcGFyYW1zIGNhbGxlZApbIDIyMzIuMTk2
MDAwXSB4YzIwMjggNC0wMDYxOiBnZW5lcmljX3NldF9mcmVxIGNhbGxlZApbIDIyMzIuMTk2MDAw
XSB4YzIwMjggNC0wMDYxOiBzaG91bGQgc2V0IGZyZXF1ZW5jeSA1MTQwMDAga0h6ClsgMjIzMi4x
OTYwMDBdIHhjMjAyOCA0LTAwNjE6IGNoZWNrX2Zpcm13YXJlIGNhbGxlZApbIDIyMzIuMTk2MDAw
XSB4YzIwMjggNC0wMDYxOiBjaGVja2luZyBmaXJtd2FyZSwgdXNlciByZXF1ZXN0ZWQgdHlwZT1G
OE1IWiBEMjYyMCBEVFY4ICgyMGEpLCBpZCAwMDAwMDAwMDAwMDAwMDAwLCBzY29kZV90YmwgKDAp
LCBzY29kZV9uciAwClsgMjIzMi4xOTYwMDBdIHhjMjAyOCA0LTAwNjE6IEJBU0UgZmlybXdhcmUg
bm90IGNoYW5nZWQuClsgMjIzMi4xOTYwMDBdIHhjMjAyOCA0LTAwNjE6IFN0ZC1zcGVjaWZpYyBm
aXJtd2FyZSBhbHJlYWR5IGxvYWRlZC4KWyAyMjMyLjE5NjAwMF0geGMyMDI4IDQtMDA2MTogU0NP
REUgZmlybXdhcmUgYWxyZWFkeSBsb2FkZWQuClsgMjIzMi4xOTYwMDBdIHhjMjAyOCA0LTAwNjE6
IHhjMjAyOF9nZXRfcmVnIDAwMDQgY2FsbGVkClsgMjIzMi4yMDQwMDBdIHhjMjAyOCA0LTAwNjE6
IHhjMjAyOF9nZXRfcmVnIDAwMDggY2FsbGVkClsgMjIzMi4yMDgwMDBdIHhjMjAyOCA0LTAwNjE6
IERldmljZSBpcyBYY2VpdmUgMzAyOCB2ZXJzaW9uIDEuMCwgZmlybXdhcmUgdmVyc2lvbiAyLjcK
WyAyMjMyLjIyODAwMF0gZGliMDcwMDogc3RrNzcwMHBoX3hjMzAyOF9jYWxsYmFjazogWEMyMDI4
X1JFU0VUX0NMSyAxClsgMjIzMi4yMjgwMDBdIApbIDIyMzIuMzUyMDAwXSB4YzIwMjggNC0wMDYx
OiBkaXZpc29yPSAwMCAwMCA3ZiBkMCAoZnJlcT01MTQuMDAwKQpbIDIyMzMuNTM2MDAwXSB4YzIw
MjggNC0wMDYxOiB4YzIwMjhfc2V0X3BhcmFtcyBjYWxsZWQKWyAyMjMzLjUzNjAwMF0geGMyMDI4
IDQtMDA2MTogZ2VuZXJpY19zZXRfZnJlcSBjYWxsZWQKWyAyMjMzLjUzNjAwMF0geGMyMDI4IDQt
MDA2MTogc2hvdWxkIHNldCBmcmVxdWVuY3kgNTE0MDAwIGtIegpbIDIyMzMuNTM2MDAwXSB4YzIw
MjggNC0wMDYxOiBjaGVja19maXJtd2FyZSBjYWxsZWQKWyAyMjMzLjUzNjAwMF0geGMyMDI4IDQt
MDA2MTogY2hlY2tpbmcgZmlybXdhcmUsIHVzZXIgcmVxdWVzdGVkIHR5cGU9RjhNSFogRDI2MjAg
RFRWOCAoMjBhKSwgaWQgMDAwMDAwMDAwMDAwMDAwMCwgc2NvZGVfdGJsICgwKSwgc2NvZGVfbnIg
MApbIDIyMzMuNTM2MDAwXSB4YzIwMjggNC0wMDYxOiBCQVNFIGZpcm13YXJlIG5vdCBjaGFuZ2Vk
LgpbIDIyMzMuNTM2MDAwXSB4YzIwMjggNC0wMDYxOiBTdGQtc3BlY2lmaWMgZmlybXdhcmUgYWxy
ZWFkeSBsb2FkZWQuClsgMjIzMy41MzYwMDBdIHhjMjAyOCA0LTAwNjE6IFNDT0RFIGZpcm13YXJl
IGFscmVhZHkgbG9hZGVkLgpbIDIyMzMuNTM2MDAwXSB4YzIwMjggNC0wMDYxOiB4YzIwMjhfZ2V0
X3JlZyAwMDA0IGNhbGxlZApbIDIyMzMuNTQ0MDAwXSB4YzIwMjggNC0wMDYxOiB4YzIwMjhfZ2V0
X3JlZyAwMDA4IGNhbGxlZApbIDIyMzMuNTQ4MDAwXSB4YzIwMjggNC0wMDYxOiBEZXZpY2UgaXMg
WGNlaXZlIDMwMjggdmVyc2lvbiAxLjAsIGZpcm13YXJlIHZlcnNpb24gMi43CgouLi4uCgpbIDIy
NzMuNzE2MDAwXSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxiYWNrOiBYQzIwMjhfUkVT
RVRfQ0xLIDEKWyAyMjczLjcxNjAwMF0gClsgMjI3My44NDAwMDBdIHhjMjAyOCA0LTAwNjE6IGRp
dmlzb3I9IDAwIDAwIGQ1IGQwIChmcmVxPTg1OC4wMDApClsgMjI3NS4yMTIwMDBdIHhjMjAyOCA0
LTAwNjE6IHhjMjAyOF9zZXRfcGFyYW1zIGNhbGxlZApbIDIyNzUuMjEyMDAwXSB4YzIwMjggNC0w
MDYxOiBnZW5lcmljX3NldF9mcmVxIGNhbGxlZApbIDIyNzUuMjEyMDAwXSB4YzIwMjggNC0wMDYx
OiBzaG91bGQgc2V0IGZyZXF1ZW5jeSA4NTgwMDAga0h6ClsgMjI3NS4yMTIwMDBdIHhjMjAyOCA0
LTAwNjE6IGNoZWNrX2Zpcm13YXJlIGNhbGxlZApbIDIyNzUuMjEyMDAwXSB4YzIwMjggNC0wMDYx
OiBjaGVja2luZyBmaXJtd2FyZSwgdXNlciByZXF1ZXN0ZWQgdHlwZT1GOE1IWiBEMjYyMCBEVFY4
ICgyMGEpLCBpZCAwMDAwMDAwMDAwMDAwMDAwLCBzY29kZV90YmwgKDApLCBzY29kZV9uciAwClsg
MjI3NS4yMTIwMDBdIHhjMjAyOCA0LTAwNjE6IEJBU0UgZmlybXdhcmUgbm90IGNoYW5nZWQuClsg
MjI3NS4yMTIwMDBdIHhjMjAyOCA0LTAwNjE6IFN0ZC1zcGVjaWZpYyBmaXJtd2FyZSBhbHJlYWR5
IGxvYWRlZC4KWyAyMjc1LjIxMjAwMF0geGMyMDI4IDQtMDA2MTogU0NPREUgZmlybXdhcmUgYWxy
ZWFkeSBsb2FkZWQuClsgMjI3NS4yMTIwMDBdIHhjMjAyOCA0LTAwNjE6IHhjMjAyOF9nZXRfcmVn
IDAwMDQgY2FsbGVkClsgMjI3NS4yMjAwMDBdIHhjMjAyOCA0LTAwNjE6IHhjMjAyOF9nZXRfcmVn
IDAwMDggY2FsbGVkClsgMjI3NS4yMjQwMDBdIHhjMjAyOCA0LTAwNjE6IERldmljZSBpcyBYY2Vp
dmUgMzAyOCB2ZXJzaW9uIDEuMCwgZmlybXdhcmUgdmVyc2lvbiAyLjcKWyAyMjc1LjI0NDAwMF0g
ZGliMDcwMDogc3RrNzcwMHBoX3hjMzAyOF9jYWxsYmFjazogWEMyMDI4X1JFU0VUX0NMSyAxClsg
MjI3NS4yNDQwMDBdIApbIDIyNzUuMzY4MDAwXSB4YzIwMjggNC0wMDYxOiBkaXZpc29yPSAwMCAw
MCBkNSBkMCAoZnJlcT04NTguMDAwKQpbIDIyNzYuNzMyMDAwXSB4YzIwMjggNC0wMDYxOiB4YzIw
Mjhfc2xlZXAgY2FsbGVkCg==
------=_Part_18152_25039298.1203180164959
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_18152_25039298.1203180164959--
