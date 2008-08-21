Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.241])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1KWH1h-0002g5-BP
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 22:45:04 +0200
Received: by an-out-0708.google.com with SMTP id c18so54022anc.125
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 13:44:55 -0700 (PDT)
Message-ID: <ea4209750808211344r28f64308q5954d10f78ca66aa@mail.gmail.com>
Date: Thu, 21 Aug 2008 22:44:55 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <37219a840808211329j697556fcj760057bb1c7b58a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_38119_30427390.1219351495518"
References: <1219330331.15825.2.camel@dark> <48ADCC81.5000407@nafik.cz>
	<37219a840808211321k34590d38v7ada0fb9655e5dfe@mail.gmail.com>
	<412bdbff0808211325h64d454d5m3353d8756b9eb737@mail.gmail.com>
	<37219a840808211329j697556fcj760057bb1c7b58a8@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 and analog broadcasting
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_38119_30427390.1219351495518
Content-Type: multipart/alternative;
	boundary="----=_Part_38120_25925046.1219351495519"

------=_Part_38120_25925046.1219351495519
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I already discussed this dibcom + analog with Michael and Pattrick and I
ended with the conclusion that was better to wait a little for Michael (or
somebody) integrate the standard stuff with the dvb-usb api. Seeing there's
more people interested that what we thought initialy I just send the answer
from Pattrick which give good guides on the dibcom stuff. I'm not going to
start anything, as I said I think is better to wait a little.

Albert

Here's Pattrick answer for the interested (again thanks for your kind help);

Analog and DiBCom, *sigh*, it works, but it is a baby nobody really wants.
OK, let me tell you, what I had once in mind: The analog and DVB hardware
abstraction in the driver is signifacantly different. That's why it was
possible for me to create something like dvb-usb, but not so easy to have
something like v4l-usb, which abstracts the streaming and other common
things.
Mainly the frontend-architecture is it, which makes DVB more powerful that
v4l hardware abstraction. But OK.
If there would be a generic streaming mechanism which works similar to the
one in dvb-usb, I think it would be relatively easy to add analog-support
for dvb-usb or to add a analog-support to a dvb-usb-based device (function
pointer which is called each time a URB is returned instead of directly
passing it to the dvb-demuxer).
For the dib0700-driver you need some things to set up in order to receive
analog audio and video (see attached):
First you need to configure the streaming interface on the
dib0700-usb-bridge. This is done with a USB request from the host and
depends on the video format.
Then the streaming needs to be enabled in a different way then in DVB.
That's it. If I understand everything correctly, there are no special
settings for the cx2584x, but time will tell. Also it is important to know,
that the audio is coming in on endpoint3 and the video on endpoint2, which
might give some AV async.

Patrick.

2008/8/21 Michael Krufky <mkrufky@linuxtv.org>

> On Thu, Aug 21, 2008 at 4:25 PM, Devin Heitmueller
> <devin.heitmueller@gmail.com> wrote:
> > On Thu, Aug 21, 2008 at 4:21 PM, Michael Krufky <mkrufky@linuxtv.org>
> wrote:
> >> On Thu, Aug 21, 2008 at 4:13 PM, gothic nafik <nafik@nafik.cz> wrote:
> >>> One more question - what about radio and remote control via lirc? Can i
> >>> receive radio signal via antenna (for digital tv) i got in box with
> >>> notebook? Is today's version of dib0700 module able to create
> /dev/radio?
> >>
> >> The driver supports IR, but does not require LIRC, afaik -- try it
> >> yourself and find out if your device is supported.
> >>
> >> Radio is analog, thus, not supported by this driver.
> >
> > FWIW:  Working on CX25843 analog support for the dib0700 based
> > Pinnnacle PCTV HD Pro was next on my list once I get the ATSC support
> > working.
>
> Devin,
>
> Lets sync up when you get to that point -- I have a good chunk of code
> written that will add analog support to the dvb-usb framework as an
> optional additional adapter type.
>
> Hopefully I'll get more work done on it before then, but if not, this
> is at least a good starting point.
>
> The idea is to add support to the framework so that the sub-drivers
> (such as dib0700, cxusb et al) can all use the common code.
>
> CX25843 is already supported, just the dvb-usb framework currently
> lacks a v4l2 interface.
>
> Regards,
>
> Mike
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_38120_25925046.1219351495519
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">I already discussed this dibcom + analog with Michael and Pattrick and I ended with the conclusion that was better to wait a little for Michael (or somebody) integrate the standard stuff with the dvb-usb api. Seeing there&#39;s more people interested that what we thought initialy I just send the answer from Pattrick which give good guides on the dibcom stuff. I&#39;m not going to start anything, as I said I think is better to wait a little.<br>
<br>Albert<br><br>Here&#39;s Pattrick answer for the interested (again thanks for your kind help);<br><br>Analog and DiBCom, *sigh*, it works, but it is a baby nobody really wants.<br>
OK, let me tell you, what I had once in mind: The analog and DVB
hardware abstraction in the driver is signifacantly different. That&#39;s
why it was possible for me to create something like dvb-usb, but not so
easy to have something like v4l-usb, which abstracts the streaming and
other common things.<br>
Mainly the frontend-architecture is it, which makes DVB more powerful that v4l hardware abstraction. But OK.<br>
If there would be a generic streaming mechanism which works similar to
the one in dvb-usb, I think it would be relatively easy to add
analog-support for dvb-usb or to add a analog-support to a
dvb-usb-based device (function pointer which is called each time a URB
is returned instead of directly passing it to the dvb-demuxer).<br>
For the dib0700-driver you need some things to set up in order to receive analog audio and video (see attached):<br>
First you need to configure the streaming interface on the
dib0700-usb-bridge. This is done with a USB request from the host and
depends on the video format.<br>
Then the streaming needs to be enabled in a different way then in DVB.<br>
That&#39;s it. If I understand everything correctly, there are no special
settings for the cx2584x, but time will tell. Also it is important to
know, that the audio is coming in on endpoint3 and the video on
endpoint2, which might give some AV async.<br>
<br>
Patrick.<br><br><div class="gmail_quote">2008/8/21 Michael Krufky <span dir="ltr">&lt;<a href="mailto:mkrufky@linuxtv.org">mkrufky@linuxtv.org</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">On Thu, Aug 21, 2008 at 4:25 PM, Devin Heitmueller<br>
&lt;<a href="mailto:devin.heitmueller@gmail.com">devin.heitmueller@gmail.com</a>&gt; wrote:<br>
&gt; On Thu, Aug 21, 2008 at 4:21 PM, Michael Krufky &lt;<a href="mailto:mkrufky@linuxtv.org">mkrufky@linuxtv.org</a>&gt; wrote:<br>
&gt;&gt; On Thu, Aug 21, 2008 at 4:13 PM, gothic nafik &lt;<a href="mailto:nafik@nafik.cz">nafik@nafik.cz</a>&gt; wrote:<br>
&gt;&gt;&gt; One more question - what about radio and remote control via lirc? Can i<br>
&gt;&gt;&gt; receive radio signal via antenna (for digital tv) i got in box with<br>
&gt;&gt;&gt; notebook? Is today&#39;s version of dib0700 module able to create /dev/radio?<br>
&gt;&gt;<br>
&gt;&gt; The driver supports IR, but does not require LIRC, afaik -- try it<br>
&gt;&gt; yourself and find out if your device is supported.<br>
&gt;&gt;<br>
&gt;&gt; Radio is analog, thus, not supported by this driver.<br>
&gt;<br>
&gt; FWIW: &nbsp;Working on CX25843 analog support for the dib0700 based<br>
&gt; Pinnnacle PCTV HD Pro was next on my list once I get the ATSC support<br>
&gt; working.<br>
<br>
</div>Devin,<br>
<br>
Lets sync up when you get to that point -- I have a good chunk of code<br>
written that will add analog support to the dvb-usb framework as an<br>
optional additional adapter type.<br>
<br>
Hopefully I&#39;ll get more work done on it before then, but if not, this<br>
is at least a good starting point.<br>
<br>
The idea is to add support to the framework so that the sub-drivers<br>
(such as dib0700, cxusb et al) can all use the common code.<br>
<br>
CX25843 is already supported, just the dvb-usb framework currently<br>
lacks a v4l2 interface.<br>
<br>
Regards,<br>
<br>
Mike<br>
<div><div></div><div class="Wj3C7c"><br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br></div>

------=_Part_38120_25925046.1219351495519--

------=_Part_38119_30427390.1219351495518
Content-Type: text/x-csrc; name=dib0700_analog.c
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk5udr590
Content-Disposition: attachment; filename=dib0700_analog.c

DQovLyBGaXJzdCBieXRlIGRhdGEgcmVjZWl2ZWQgb24gRW5kcG9pbnQgMCAoY29udHJvbCBieXRl
KQ0KZW51bSBUWVBFX1VTQl9SRVFVRVNUDQp7DQoJUkVRVUVTVF9VTlVTRURfMCA9IDAsDQoJUkVR
VUVTVF9ET1dOTE9BRCwNCglSRVFVRVNUX0kyQ19SRUFELA0KCVJFUVVFU1RfSTJDX1dSSVRFLA0K
CVJFUVVFU1RfUE9MTF9SQywNCglSRVFVRVNUX0RJU0NPTk5FQ1QsDQoJUkVRVUVTVF9HRVRfR1BJ
TywNCglSRVFVRVNUX1NFVF9JT0NUTCwNCglSRVFVRVNUX0pVTVBSQU0sDQoJUkVRVUVTVF9BSEJf
UkVBRCwNCglSRVFVRVNUX0FIQl9XUklURSwNCglSRVFVRVNUX1NFVF9DTE9DSywNCglSRVFVRVNU
X1NFVF9HUElPLA0KCVJFUVVFU1RfU0VUX1BXTSwNCglSRVFVRVNUX1NFVF9BTkFfTU9ERSwNCglS
RVFVRVNUX0VOQUJMRV9WSURFTywNCglSRVFVRVNUX1NFVF9JMkNfUEFSQU0sDQoJUkVRVUVTVF9T
RVRfUkMsDQoJUkVRVUVTVF9ORVdfSTJDX1JFQUQsDQoJUkVRVUVTVF9ORVdfSTJDX1dSSVRFLA0K
CVJFUVVFU1RfU0VUX1NVU1BfUEFSQU0sDQoJUkVRVUVTVF9HRVRfVkVSU0lPTiwNCglSRVFVRVNU
X1NSQU1fUkVBRF9TTUFMTCwNCglSRVFVRVNUX1NSQU1fUkVBRF9CSUcsDQoJUkVRVUVTVF9TUkFN
X1dSSVRFLA0KCVJFUVVFU1RfTUFYDQp9Ow0KDQpzdGF0aWMgaW50IGRpYjA3MDBfc2V0X3N0cmVh
bWluZyhzdHJ1Y3QgZGliQnVzQWRhcHRlciAqY3RybCwgc3RydWN0IGRpYlN0cmVhbWluZ1JlcXVl
c3QgKnJlcXVlc3QpDQp7DQoJc3RydWN0IGRpYjA3MDBfc3RhdGUgKnN0YXRlID0gY3RybC0+cHJp
djsNCgl1aW50OF90IG1vZGUgPSAwLCBzdWJfbW9kZTsNCgl1aW50OF90IGNoMV9lbjsNCgl1aW50
OF90IGNoMl9lbjsNCg0KCWlmIChzdGF0ZS0+c3JhbV9zZGlvX2FjdGl2ZSkgLyogaW4gY2FzZSBv
ZiBTUkFNIGVuYWJsZWQgZG9uJ3QgZG8gYW55IHNldF9zdHJlYW1pbmcgcmVxdWVzdCAqLw0KCQly
ZXR1cm4gRElCX1JFVFVSTl9TVUNDRVNTOw0KDQoJaWYgKHJlcXVlc3QtPm1vZGUgJiBNT0RFX0RJ
R0lUQUwpDQoJCW1vZGUgPSAwOw0KCWVsc2UgaWYgKHJlcXVlc3QtPm1vZGUgJiBNT0RFX0FOQUxP
RykNCgkJbW9kZSA9IDE7DQoJZWxzZSBpZiAocmVxdWVzdC0+bW9kZSAmIE1PREVfQU5BTE9HX0FE
QykNCgkJbW9kZSA9IDI7DQoNCglpZiAocmVxdWVzdC0+dmlkZW9fc3RhbmRhcmQgPT0gQW5hbG9n
VmlkZW9fTm9uZSkNCgkJcmVxdWVzdC0+dmlkZW9fc3RhbmRhcmQgPSBzdGF0ZS0+Y3VycmVudF9z
dGFuZGFyZDsNCgllbHNlDQoJCXN0YXRlLT5jdXJyZW50X3N0YW5kYXJkID0gcmVxdWVzdC0+dmlk
ZW9fc3RhbmRhcmQ7DQoNCglpZiAoKG1vZGUgPT0gMSAmJiAocmVxdWVzdC0+dmlkZW9fc3RhbmRh
cmQgJiBBbmFsb2dWaWRlb19OVFNDX01hc2spICE9IDApKQ0KCQlzdWJfbW9kZSA9IDB4MDA7ICAg
Ly8gKDB4MDEgPDwgNCkgPT0gTnRzYyBtb2RlLCAweDAxID09IGNoYW5uZWwgZW5hYmxlZA0KCWVs
c2UNCgkJc3ViX21vZGUgPSAweDAxOyAgIC8vICgweDAxIDw8IDQpID09IFBhbCBtb2RlLCAweDAx
ID09IGNoYW5uZWwgZW5hYmxlZA0KDQoJZGJncGwoJmRpYjA3MDBfZGJnLCAibW9kaWZ5aW5nICgl
ZCkgc3RyZWFtaW5nIHN0YXRlIGZvciAlZCIsIHJlcXVlc3QtPm9ub2ZmLCByZXF1ZXN0LT5pZCk7
DQoNCglpZiAocmVxdWVzdC0+aWQgPT0gMCkNCiAgICAgICAgY2gxX2VuID0gcmVxdWVzdC0+b25v
ZmY7DQoJZWxzZQ0KICAgICAgICBjaDFfZW4gPSAhcmVxdWVzdC0+b25vZmY7DQogICAgY2gyX2Vu
ID0gIWNoMV9lbjsNCg0KCXJldHVybiBkaWIwNzAwX3ZpZGVvX2VuYWJsZShzdGF0ZSwgcmVxdWVz
dC0+b25vZmYsIG1vZGUsIHN1Yl9tb2RlLCBjaDFfZW4sIGNoMl9lbik7DQp9DQoNCnN0YXRpYyBp
bnQgZGliMDcwMF9zZXRfc2NhbGluZyhzdHJ1Y3QgZGliQnVzQWRhcHRlciogY3RybCwgc3RydWN0
IGRpYlZpZGVvQ29uZmlnICogdmlkZW9fY29uZmlnLCBzdHJ1Y3QgZGliVmlkZW9UcmFuc2l0aW9u
cyAqIHZpZGVvX3RyYW5zaXRpb25zKQ0Kew0KCXN0cnVjdCBkaWIwNzAwX3N0YXRlICpzdGF0ZSA9
IGN0cmwtPnByaXY7DQoNCgl1aW50OF90IGJbMjFdOw0KDQoJLy9Gb3Igbm93LCB3ZSBnZXQgdGhl
IG5iIG9mIHRoZSBsaW5lIGluIHRoZSBTQVYgYW5kIGFsd2F5cyBnZXQgVkJJIGluZm9ybWF0aW9u
cw0KCWJbIDBdID0gKCgodmlkZW9fY29uZmlnLT5TdGFuZGFyZCA9PSA2MjUpPzE6MCk8PDcpIHwg
KDE8PDYpIHwgKDE8PDUpIHwgKDE8PDQpOw0KCS8vIGJpdCBzaGlmdGVkIGJ5IDYgPSBTQVYgZW5h
YmxlDQoJLy8gYml0IHNoaWZ0ZWQgYnkgNSA9IFZCSSBpcyBwcmVzZW50DQoJLy8gYml0IHNoaWZ0
ZWQgYnkgNCA9IGluc2VydGlvbiBvZiBsaW5lIE51bWJlcg0KDQoJYlsgMV0gPSAodWludDhfdCko
dmlkZW9fY29uZmlnLT5Id1ZpZGVvTGluZVNpemUrNCkmMHhmZjsNCgliWyAyXSA9ICh1aW50OF90
KSgodmlkZW9fY29uZmlnLT5Id1ZpZGVvTGluZVNpemUrNCk+PjgpJjB4ZmY7DQoNCgliWyAzXSA9
ICh1aW50OF90KSh2aWRlb19jb25maWctPkh3VmJpTGluZVNpemUrNCkmMHhmZjsNCgliWyA0XSA9
ICh1aW50OF90KSgodmlkZW9fY29uZmlnLT5Id1ZiaUxpbmVTaXplKzQpPj44KSYweGZmOw0KDQoJ
YlsgNV0gPSAodWludDhfdClzdGF0ZS0+ZGVzYy0+dXJiX21heF9zaXplJjB4ZmY7DQoJYlsgNl0g
PSAodWludDhfdCkoc3RhdGUtPmRlc2MtPnVyYl9tYXhfc2l6ZT4+OCkmMHhmZjsNCg0KCWJbIDdd
ID0gKHVpbnQ4X3QpdmlkZW9fdHJhbnNpdGlvbnMtPlN0YXJ0T2ZPZGRGaWVsZCYweGZmOw0KCWJb
IDhdID0gKHVpbnQ4X3QpKHZpZGVvX3RyYW5zaXRpb25zLT5TdGFydE9mT2RkRmllbGQ+PjgpJjB4
ZmY7DQoJYlsgOV0gPSAodWludDhfdCl2aWRlb190cmFuc2l0aW9ucy0+U3RhcnRPZkV2ZW5GaWVs
ZCYweGZmOw0KCWJbMTBdID0gKHVpbnQ4X3QpKHZpZGVvX3RyYW5zaXRpb25zLT5TdGFydE9mRXZl
bkZpZWxkPj44KSYweGZmOw0KDQoJYlsxMV0gPSAodWludDhfdCl2aWRlb190cmFuc2l0aW9ucy0+
U3RhcnRPZkFjdGl2ZU9kZCYweGZmOw0KCWJbMTJdID0gKHVpbnQ4X3QpKHZpZGVvX3RyYW5zaXRp
b25zLT5TdGFydE9mQWN0aXZlT2RkPj44KSYweGZmOw0KCWJbMTNdID0gKHVpbnQ4X3QpdmlkZW9f
dHJhbnNpdGlvbnMtPkVuZE9mQWN0aXZlT2RkJjB4ZmY7DQoJYlsxNF0gPSAodWludDhfdCkodmlk
ZW9fdHJhbnNpdGlvbnMtPkVuZE9mQWN0aXZlT2RkPj44KSYweGZmOw0KDQoJYlsxNV0gPSAodWlu
dDhfdCl2aWRlb190cmFuc2l0aW9ucy0+U3RhcnRPZkFjdGl2ZUV2ZW4mMHhmZjsNCgliWzE2XSA9
ICh1aW50OF90KSh2aWRlb190cmFuc2l0aW9ucy0+U3RhcnRPZkFjdGl2ZUV2ZW4+PjgpJjB4ZmY7
DQoJYlsxN10gPSAodWludDhfdCl2aWRlb190cmFuc2l0aW9ucy0+RW5kT2ZBY3RpdmVFdmVuJjB4
ZmY7DQoJYlsxOF0gPSAodWludDhfdCkodmlkZW9fdHJhbnNpdGlvbnMtPkVuZE9mQWN0aXZlRXZl
bj4+OCkmMHhmZjsNCg0KDQoJYlsxOV0gPSAoKHVpbnQ4X3QpdmlkZW9fdHJhbnNpdGlvbnMtPlRv
dGFsTnVtYmVyT2ZMaW5lcykmMHhmZjsNCgliWzIwXSA9ICgodWludDhfdCkodmlkZW9fdHJhbnNp
dGlvbnMtPlRvdGFsTnVtYmVyT2ZMaW5lcz4+OCkpJjB4ZmY7DQoNCglkYmdwbCgmZGliMDcwMF9k
YmcsICJkYXRhIGZvciBzY2FsaW5nOiAlMnggJTJ4ICUyeCAlMnggJTJ4ICUyeCAlMnggJTJ4ICUy
eCAlMnggJTJ4ICUyeCAlMnggJTJ4ICUyeCAlMnggJTJ4ICUyeCAlMnggJTJ4ICUyeCIsYlswXSxi
WzFdLCBiWzJdLCBiWzNdLCBiWzRdLCBiWzVdLCBiWzZdLCBiWzddLCBiWzhdLCBiWzldLCBiWzEw
XSwgYlsxMV0sIGJbMTJdLCBiWzEzXSwgYlsxNF0sIGJbMTVdLCBiWzE2XSwgYlsxN10sIGJbMThd
LCBiWzE5XSwgYlsyMF0pOw0KDQoJcmV0dXJuIGRpYjA3MDBfY3RybF93cml0ZShzdGF0ZSwgUkVR
VUVTVF9TRVRfQU5BX01PREUsIGIsIDIxKTsNCn0NCg0KLyogYW5kIHRoZSBjYWxscyB0byBzZXRf
c2NhbGluZyAqLw0KDQpzdGF0aWMgdm9pZCBzZXR1cF9ob29rX2FuYWxvZ192aWRlb19jb25maWco
c3RydWN0IGRpYkJvYXJkICpib2FyZCwgaW50IG51bV9vZl9saW5lcywgaW50IHVzZV9ob29rX2xp
bmVfbnVtYmVyaW5nKQ0Kew0KCXN0cnVjdCBkaWJWaWRlb0NvbmZpZyAgICAgIGNmZzsNCglzdHJ1
Y3QgZGliVmlkZW9UcmFuc2l0aW9ucyB0cmFuczsNCglzdHJ1Y3QgZGliVmlkZW9GcmFtaW5nICAg
ICBmcmFtaW5nOw0KCXVpbnQxNl90IG51bV9hY3RpdmVfbGluZXM7DQoNCglpZiAobnVtX29mX2xp
bmVzICE9IDUyNSAmJiBudW1fb2ZfbGluZXMgIT0gNjI1KQ0KCQlyZXR1cm47DQoNCgkvKiBUT0RP
IGNvcnJlY3QgZm9yIHNjYWxpbmcgKi8NCgludW1fYWN0aXZlX2xpbmVzID0gbnVtX29mX2xpbmVz
ID09IDUyNSA/IDQ4MCA6IDU3NjsNCg0KCWNmZy5Id1ZpZGVvTGluZVNpemUgPSAxNDQwOw0KCWNm
Zy5Id05iQWN0aXZlTGluZXMgPSBudW1fYWN0aXZlX2xpbmVzOw0KCWNmZy5Id1ZiaUxpbmVTaXpl
ICAgPSAxNDQwOw0KCWNmZy5TdGFuZGFyZCAgICAgICAgPSBudW1fb2ZfbGluZXM7DQoNCglpZiAo
bnVtX29mX2xpbmVzID09IDUyNSkgew0KCQl1aW50MzJfdCBOYlJlYWxBY3RpdmVMaW5lczsNCgkJ
ZGVidWdfcHJpbnRmKCItRC0gIE5UU0NcbiIpOw0KCQlpZiAoY2ZnLkh3TmJBY3RpdmVMaW5lcyA9
PSA0ODApDQoJCQlOYlJlYWxBY3RpdmVMaW5lcyA9IDQ4NzsNCgkJZWxzZQ0KCQkJTmJSZWFsQWN0
aXZlTGluZXMgPSAyNDM7DQoNCgkJdHJhbnMuU3RhcnRPZk9kZEZpZWxkICAgID0gNDsNCgkJdHJh
bnMuU3RhcnRPZkFjdGl2ZU9kZCAgID0gMjE7DQoJCXRyYW5zLkVuZE9mQWN0aXZlT2RkICAgICA9
IHRyYW5zLlN0YXJ0T2ZBY3RpdmVPZGQgKyBOYlJlYWxBY3RpdmVMaW5lcy8yOyAvLzI2NQ0KCQl0
cmFucy5TdGFydE9mRXZlbkZpZWxkICAgPSB0cmFucy5FbmRPZkFjdGl2ZU9kZCArIDI7IC8vMjY2
DQoJCXRyYW5zLlN0YXJ0T2ZBY3RpdmVFdmVuICA9IHRyYW5zLlN0YXJ0T2ZFdmVuRmllbGQgKyAx
ODsgLy8yODMNCgkJdHJhbnMuRW5kT2ZBY3RpdmVFdmVuICAgID0gdHJhbnMuU3RhcnRPZkFjdGl2
ZUV2ZW4gKyBOYlJlYWxBY3RpdmVMaW5lcy8yOyAvLzUyNQ0KCQl0cmFucy5Ub3RhbE51bWJlck9m
TGluZXMgPSB0cmFucy5FbmRPZkFjdGl2ZUV2ZW47IC8vNTI1DQoNCgkJZnJhbWluZy5WYmlMaW5l
cyAgICA9IDEyOw0KCQlmcmFtaW5nLlZiaUYwU3RhcnQgID0gOTsNCgkJZnJhbWluZy5WYmlGMFN0
b3AgICA9IDIwOw0KCQlmcmFtaW5nLlZiaUYxU3RhcnQgID0gdHJhbnMuU3RhcnRPZkV2ZW5GaWVs
ZCArIDU7Ly8yNzM7DQoJCWZyYW1pbmcuVmJpRjFTdG9wICAgPSBmcmFtaW5nLlZiaUYxU3RhcnQg
KzExOy8vMjg0Ow0KDQoJCWZyYW1pbmcuVmlkZW9GMFN0YXJ0PSB0cmFucy5TdGFydE9mQWN0aXZl
T2RkOw0KCQlmcmFtaW5nLlZpZGVvRjBTdG9wID0gZnJhbWluZy5WaWRlb0YwU3RhcnQgKyBudW1f
YWN0aXZlX2xpbmVzLzItMTsgLy8yNjEgICAgICAvLyAyNDAgbGluZXMgKDI2MSBpbmNsdWRlZCkN
CgkJZnJhbWluZy5WaWRlb0YxU3RhcnQ9IHRyYW5zLlN0YXJ0T2ZBY3RpdmVFdmVuOy8vMjg1Ow0K
CQlmcmFtaW5nLlZpZGVvRjFTdG9wID0gZnJhbWluZy5WaWRlb0YxU3RhcnQgKyBudW1fYWN0aXZl
X2xpbmVzLzIgLTEgOy8vNTI0Ow0KDQoJfSBlbHNlIHsNCgkJZGVidWdfcHJpbnRmKCItRC0gIFBB
TC9TRUNBTVxuIik7DQojaWYgMDENCgkJdHJhbnMuU3RhcnRPZk9kZEZpZWxkICAgID0gMTsNCgkJ
dHJhbnMuU3RhcnRPZkFjdGl2ZU9kZCAgID0gMjM7DQoJCXRyYW5zLkVuZE9mQWN0aXZlT2RkICAg
ICA9IHRyYW5zLlN0YXJ0T2ZBY3RpdmVPZGQgKyBudW1fYWN0aXZlX2xpbmVzLzI7IC8vMzExDQoJ
CXRyYW5zLlN0YXJ0T2ZFdmVuRmllbGQgICA9IHRyYW5zLkVuZE9mQWN0aXZlT2RkICsgMjsgLy8z
MTINCgkJdHJhbnMuU3RhcnRPZkFjdGl2ZUV2ZW4gID0gdHJhbnMuU3RhcnRPZkV2ZW5GaWVsZCAr
IDIzOyAvLzMzNQ0KCQl0cmFucy5FbmRPZkFjdGl2ZUV2ZW4gICAgPSB0cmFucy5TdGFydE9mQWN0
aXZlRXZlbiArIG51bV9hY3RpdmVfbGluZXMvMjsgLy82MjMNCgkJdHJhbnMuVG90YWxOdW1iZXJP
ZkxpbmVzID0gdHJhbnMuRW5kT2ZBY3RpdmVFdmVuICsgMjsgLy82MjUNCg0KI2Vsc2UNCgkJdHJh
bnMuU3RhcnRPZk9kZEZpZWxkICAgID0gMTsNCgkJdHJhbnMuU3RhcnRPZkFjdGl2ZU9kZCAgID0g
MTAwOw0KCQl0cmFucy5FbmRPZkFjdGl2ZU9kZCAgICAgPSA0MDA7Ly90cmFucy5TdGFydE9mQWN0
aXZlT2RkICsgbnVtX2FjdGl2ZV9saW5lcy8yOyAvLzMxMQ0KCQl0cmFucy5TdGFydE9mRXZlbkZp
ZWxkICAgPSA1MDA7IC8vdHJhbnMuRW5kT2ZBY3RpdmVPZGQgKyAyOyAvLzMxMg0KCQl0cmFucy5T
dGFydE9mQWN0aXZlRXZlbiAgPSA2MDA7IC8vdHJhbnMuU3RhcnRPZkV2ZW5GaWVsZCArIDIzOyAv
LzMzNQ0KCQl0cmFucy5FbmRPZkFjdGl2ZUV2ZW4gICAgPSA5MDA7IC8vdHJhbnMuU3RhcnRPZkFj
dGl2ZUV2ZW4gKyBudW1fYWN0aXZlX2xpbmVzLzI7IC8vNjIzDQoJCXRyYW5zLlRvdGFsTnVtYmVy
T2ZMaW5lcyA9IDEwMDA7IC8vNjI1DQojZW5kaWYNCg0KCQlmcmFtaW5nLlZiaUxpbmVzICAgID0g
MTc7DQoJCWZyYW1pbmcuVmJpRjBTdGFydCAgPSA2Ow0KCQlmcmFtaW5nLlZiaUYwU3RvcCAgID0g
MjI7DQoJCWZyYW1pbmcuVmlkZW9GMFN0YXJ0PSB0cmFucy5TdGFydE9mQWN0aXZlT2RkIDsgICAg
ICAgLy8gQ2xpcCBmaXJzdCAxLzIgbGluZQ0KCQlmcmFtaW5nLlZpZGVvRjBTdG9wID0gdHJhbnMu
RW5kT2ZBY3RpdmVPZGQgLTE7IC8vMzEwDQoJCWZyYW1pbmcuVmJpRjFTdGFydCAgPSB0cmFucy5T
dGFydE9mRXZlbkZpZWxkICsgNjsgLy8zMTkNCgkJZnJhbWluZy5WYmlGMVN0b3AgICA9IGZyYW1p
bmcuVmJpRjFTdGFydCArIDE2OyAvLzMzNQ0KCQlmcmFtaW5nLlZpZGVvRjFTdGFydD0gdHJhbnMu
U3RhcnRPZkFjdGl2ZUV2ZW47IC8vMzM2DQoJCWZyYW1pbmcuVmlkZW9GMVN0b3AgPSB0cmFucy5F
bmRPZkFjdGl2ZUV2ZW4tMTsgLy82MjMNCgl9DQoJZGVidWdfcHJpbnRmKCItRC0gIEZyYW1pbmc6
ICAgICVkLCAlZCwgJWQsICVkLCAlZCwgJWQsICVkLCAlZCwgJWRcbiIsIGZyYW1pbmcuVmJpTGlu
ZXMsZnJhbWluZy5WYmlGMFN0YXJ0ICxmcmFtaW5nLlZiaUYwU3RvcCwNCgkJZnJhbWluZy5WaWRl
b0YwU3RhcnQsZnJhbWluZy5WaWRlb0YwU3RvcCAsZnJhbWluZy5WYmlGMVN0YXJ0ICAsZnJhbWlu
Zy5WYmlGMVN0b3AgLGZyYW1pbmcuVmlkZW9GMVN0YXJ0LGZyYW1pbmcuVmlkZW9GMVN0b3ApOw0K
CWRlYnVnX3ByaW50ZigiLUQtICBUcmFuc2l0aW9uOiAlZCwgJWQsICVkLCAlZCwgJWQsICVkLCAl
ZFxuIiwgdHJhbnMuU3RhcnRPZk9kZEZpZWxkLCB0cmFucy5TdGFydE9mRXZlbkZpZWxkLCB0cmFu
cy5TdGFydE9mQWN0aXZlT2RkLA0KCQl0cmFucy5FbmRPZkFjdGl2ZU9kZCwgdHJhbnMuU3RhcnRP
ZkFjdGl2ZUV2ZW4sIHRyYW5zLkVuZE9mQWN0aXZlRXZlbiwgdHJhbnMuVG90YWxOdW1iZXJPZkxp
bmVzKTsNCglkZWJ1Z19wcmludGYoIi1ELSAgQ29uZmlnOiAgICAgJWQsICVkLCAlZCwgJWRcbiIs
IGNmZy5Id1ZiaUxpbmVTaXplLCBjZmcuSHdWaWRlb0xpbmVTaXplLCBjZmcuSHdOYkFjdGl2ZUxp
bmVzLCBjZmcuU3RhbmRhcmQpOw0KDQoJYm9hcmRfc2V0X3NjYWxpbmcoYm9hcmQsICZjZmcsICZ0
cmFucyk7DQp9DQoNCg==
------=_Part_38119_30427390.1219351495518
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_38119_30427390.1219351495518--
