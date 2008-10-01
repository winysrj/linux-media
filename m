Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1Kl2gg-0005yE-S0
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 16:28:23 +0200
Received: by qw-out-2122.google.com with SMTP id 9so118730qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 01 Oct 2008 07:28:18 -0700 (PDT)
Message-ID: <c74595dc0810010728j7de23c62h87a36a2c8705d977@mail.gmail.com>
Date: Wed, 1 Oct 2008 17:28:18 +0300
From: "Alex Betis" <alex.betis@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <c74595dc0809300248i12241125ia77a788f3094bc75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_29463_837078.1222871298716"
References: <c74595dc0809290713i7ca11bdfw3424c8347e9a6d9e@mail.gmail.com>
	<909452.76198.qm@web23201.mail.ird.yahoo.com>
	<c74595dc0809300248i12241125ia77a788f3094bc75@mail.gmail.com>
Cc: skerit@kipdola.com, subbotin222@mail.ru
Subject: Re: [linux-dvb] Re : Re : TT S2-3200 driver
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

------=_Part_29463_837078.1222871298716
Content-Type: multipart/alternative;
	boundary="----=_Part_29464_3564934.1222871298717"

------=_Part_29464_3564934.1222871298717
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,

My description of the solution is here:
http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html

I've also attaching the patches to this thread.

Several people reported better lock on DVB-S channels.

Just to clarify it, the changes mostly affect DVB-S channels scanning, it
doesn't help with DVB-S2 locking problem since the code is totally differen=
t
for S and S2 signal search.

I've increased a timer for S2 signal search and decreased the search step,
this helps to lock on "good" S2 channels that were locked anyway with
several attempts, but this time it locks from first attempt. The "bad"
channels finds the signal, but the FEC is unable to lock.
Since searching of S2 channels is done in the card and not in the driver,
its pretty hard to know what is going on there.

Can't say what happens with the lock on "good" channels since I don't have
any S2 FTA in my sight.

If anyone has any progress with S2 lock, let me know, I'd like to join the
forces.


On Tue, Sep 30, 2008 at 12:48 PM, Alex Betis <alex.betis@gmail.com> wrote:

> I'll send the patches to the list as soon as I'll finish some more
> debugging and clean the code from all the garbage I've added there.
>
> Meanwhile I'd also like to wait for few people responses who test those
> patches. So far one person with Twinhan 1041 card confirmed that the chan=
ges
> "improved a lot" the locking. Waiting for few more people with TT S2-3200=
 to
> confirm it.
>
>
> On Tue, Sep 30, 2008 at 12:35 PM, Newsy Paper <
> newspaperman_germany@yahoo.com> wrote:
>
>> Hi Alex!
>>
>> This souds like good news!
>> Hope you could help us with a patch from you.
>>
>> kind regards
>>
>>
>> Newsy
>>
>>
>> --- Alex Betis <alex.betis@gmail.com> schrieb am Mo, 29.9.2008:
>>
>> > Von: Alex Betis <alex.betis@gmail.com>
>> > Betreff: Re: [linux-dvb] Re : Re : TT S2-3200 driver
>> > An: "Jelle De Loecker" <skerit@kipdola.com>
>> > CC: "linux-dvb" <linux-dvb@linuxtv.org>
>> > Datum: Montag, 29. September 2008, 16:13
>> > Does that card use stb0899 drivers as Twinhan 1041?
>> >
>> > I've done some changes to the algorithm that provide
>> > constant lock.
>> >
>> > 2008/9/29 Jelle De Loecker <skerit@kipdola.com>
>> >
>> > >
>> > > manu schreef:
>> > >
>> > > Le 13.09.2008 19:10:31, Manu Abraham a =E9crit :
>> > >
>> > >
>> > >  manu wrote:
>> > >
>> > >
>> > >  I forgot the logs...
>> > >
>> > >
>> > >  Taking a look at it. Please do note that, i will have
>> > to go through
>> > > it
>> > > very patiently.
>> > >
>> > > Thanks for the logs.
>> > >
>> > >
>> > >
>> > >  You're more than welcome. I tried to put some
>> > printk's but the only
>> > > thing I got is that even when the carrier is correctly
>> > detected, the
>> > > driver does not detect the data (could that be related
>> > to the different
>> > > FEC?).
>> > > Anyway let me know if you need more testing.
>> > > Bye
>> > > Manu
>> > >
>> > >
>> > > I'm unable to scan the channels on the Astra 23,5
>> > satellite
>> > > Frequency 11856000
>> > > Symbol rate 27500000
>> > > Vertical polarisation
>> > > FEC 5/6
>> > >
>> > > Is this because of the same bug? I should be getting
>> > Discovery Channel HD,
>> > > National Geographic Channel HD, Brava HDTV and Voom HD
>> > International, but
>> > > I'm only getting a time out.
>> > >
>> > >
>> > > *Met vriendelijke groeten,*
>> > >
>> > > *Jelle De Loecker*
>> > > Kipdola Studios - Tomberg
>> > >
>> > >
>> > >
>> > > _______________________________________________
>> > > linux-dvb mailing list
>> > > linux-dvb@linuxtv.org
>> > >
>> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>> > >
>> > _______________________________________________
>> > linux-dvb mailing list
>> > linux-dvb@linuxtv.org
>> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>
>>
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
>

------=_Part_29464_3564934.1222871298717
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">Hi all,<br><br>My description of the solution is here:<br>=
<a href=3D"http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361=
.html" target=3D"_blank">http://www.linuxtv.org/pipermail/linux-dvb/2008-Se=
ptember/029361.html</a><br>


<br>I&#39;ve also attaching the patches to this thread.<br><br>Several peop=
le reported better lock on DVB-S channels.<br><br>Just to
clarify it, the changes mostly affect DVB-S channels scanning, it
doesn&#39;t help with DVB-S2 locking problem since the code is totally
different for S and S2 signal search.<br>


<br>I&#39;ve increased a timer for S2 signal search and decreased the
search step, this helps to lock on &quot;good&quot; S2 channels that were l=
ocked
anyway with several attempts, but this time it locks from first
attempt. The &quot;bad&quot; channels finds the signal, but the FEC is unab=
le to
lock. <br>


Since searching of S2 channels is done in the card and not in the driver, i=
ts pretty hard to know what is going on there.<br><br>Can&#39;t say what ha=
ppens with the lock on &quot;good&quot; channels since I don&#39;t have any=
 S2 FTA in my sight.<br>




<br>If anyone has any progress with S2 lock, let me know, I&#39;d like to j=
oin the forces.<br><br><br><div class=3D"gmail_quote">On Tue, Sep 30, 2008 =
at 12:48 PM, Alex Betis <span dir=3D"ltr">&lt;<a href=3D"mailto:alex.betis@=
gmail.com" target=3D"_blank">alex.betis@gmail.com</a>&gt;</span> wrote:<br>


<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div dir=3D"ltr">=
I&#39;ll send the patches to the list as soon as I&#39;ll finish some more =
debugging and clean the code from all the garbage I&#39;ve added there.<br>


<br>Meanwhile I&#39;d also like to wait for few people responses who test t=
hose patches. So far one person with Twinhan 1041 card confirmed that the c=
hanges &quot;improved a lot&quot; the locking. Waiting for few more people =
with TT S2-3200 to confirm it.<div>


<div></div><div><br>
<br><div class=3D"gmail_quote">On Tue, Sep 30, 2008 at 12:35 PM, Newsy Pape=
r <span dir=3D"ltr">&lt;<a href=3D"mailto:newspaperman_germany@yahoo.com" t=
arget=3D"_blank">newspaperman_germany@yahoo.com</a>&gt;</span> wrote:<br><b=
lockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 20=
4, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">



Hi Alex!<br>
<br>
This souds like good news!<br>
Hope you could help us with a patch from you.<br>
<br>
kind regards<br>
<br>
<br>
Newsy<br>
<br>
<br>
--- Alex Betis &lt;<a href=3D"mailto:alex.betis@gmail.com" target=3D"_blank=
">alex.betis@gmail.com</a>&gt; schrieb am Mo, 29.9.2008:<br>
<br>
&gt; Von: Alex Betis &lt;<a href=3D"mailto:alex.betis@gmail.com" target=3D"=
_blank">alex.betis@gmail.com</a>&gt;<br>
&gt; Betreff: Re: [linux-dvb] Re : Re : TT S2-3200 driver<br>
&gt; An: &quot;Jelle De Loecker&quot; &lt;<a href=3D"mailto:skerit@kipdola.=
com" target=3D"_blank">skerit@kipdola.com</a>&gt;<br>
&gt; CC: &quot;linux-dvb&quot; &lt;<a href=3D"mailto:linux-dvb@linuxtv.org"=
 target=3D"_blank">linux-dvb@linuxtv.org</a>&gt;<br>
&gt; Datum: Montag, 29. September 2008, 16:13<br>
<div><div></div><div>&gt; Does that card use stb0899 drivers as Twinhan 104=
1?<br>
&gt;<br>
&gt; I&#39;ve done some changes to the algorithm that provide<br>
&gt; constant lock.<br>
&gt;<br>
&gt; 2008/9/29 Jelle De Loecker &lt;<a href=3D"mailto:skerit@kipdola.com" t=
arget=3D"_blank">skerit@kipdola.com</a>&gt;<br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt; manu schreef:<br>
&gt; &gt;<br>
&gt; &gt; Le 13.09.2008 19:10:31, Manu Abraham a =E9crit :<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &nbsp;manu wrote:<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &nbsp;I forgot the logs...<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &nbsp;Taking a look at it. Please do note that, i will have<br>
&gt; to go through<br>
&gt; &gt; it<br>
&gt; &gt; very patiently.<br>
&gt; &gt;<br>
&gt; &gt; Thanks for the logs.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &nbsp;You&#39;re more than welcome. I tried to put some<br>
&gt; printk&#39;s but the only<br>
&gt; &gt; thing I got is that even when the carrier is correctly<br>
&gt; detected, the<br>
&gt; &gt; driver does not detect the data (could that be related<br>
&gt; to the different<br>
&gt; &gt; FEC?).<br>
&gt; &gt; Anyway let me know if you need more testing.<br>
&gt; &gt; Bye<br>
&gt; &gt; Manu<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; I&#39;m unable to scan the channels on the Astra 23,5<br>
&gt; satellite<br>
&gt; &gt; Frequency 11856000<br>
&gt; &gt; Symbol rate 27500000<br>
&gt; &gt; Vertical polarisation<br>
&gt; &gt; FEC 5/6<br>
&gt; &gt;<br>
&gt; &gt; Is this because of the same bug? I should be getting<br>
&gt; Discovery Channel HD,<br>
&gt; &gt; National Geographic Channel HD, Brava HDTV and Voom HD<br>
&gt; International, but<br>
&gt; &gt; I&#39;m only getting a time out.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; *Met vriendelijke groeten,*<br>
&gt; &gt;<br>
&gt; &gt; *Jelle De Loecker*<br>
&gt; &gt; Kipdola Studios - Tomberg<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; _______________________________________________<br>
&gt; &gt; linux-dvb mailing list<br>
&gt; &gt; <a href=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank">linux-=
dvb@linuxtv.org</a><br>
&gt; &gt;<br>
&gt; <a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb=
</a><br>
&gt; &gt;<br>
&gt; _______________________________________________<br>
&gt; linux-dvb mailing list<br>
&gt; <a href=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank">linux-dvb@l=
inuxtv.org</a><br>
&gt; <a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb=
</a><br>
<br>
<br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank">linux-dvb@linuxt=
v.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</div></div></blockquote></div><br></div></div></div>
</blockquote></div><br></div>

------=_Part_29464_3564934.1222871298717--

------=_Part_29463_837078.1222871298716
Content-Type: application/octet-stream; name=stb0899_drv.c.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fls1ylry0
Content-Disposition: attachment; filename=stb0899_drv.c.diff

LS0tIC9tZWRpYS9zdG9yYWdlL0Rvd25sb2FkL2R2Yi9tYW50aXMtMzAzYjFkMjlkNzM1L2xpbnV4
L2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9zdGIwODk5X2Rydi5jCTIwMDgtMDktMjEgMTg6
NDE6MDAuMDAwMDAwMDAwICswMzAwCisrKyBzdGIwODk5X2Rydi5jCTIwMDgtMTAtMDEgMTY6Mzg6
NDMuMDAwMDAwMDAwICswMzAwCkBAIC0zMSw3ICszMSw3IEBACiAjaW5jbHVkZSAic3RiMDg5OV9w
cml2LmgiCiAjaW5jbHVkZSAic3RiMDg5OV9yZWcuaCIKIAotc3RhdGljIHVuc2lnbmVkIGludCB2
ZXJib3NlID0gMDsvLzE7CitzdGF0aWMgdW5zaWduZWQgaW50IHZlcmJvc2UgPSAwOyAvLyBjaGFu
Z2UgYmFjayB0byAwCiBtb2R1bGVfcGFyYW0odmVyYm9zZSwgaW50LCAwNjQ0KTsKIAogLyogQy9O
IGluIGRCLzEwLCBOSVJNL05JUkwgKi8KQEAgLTE2MzAsNyArMTYzMCw4IEBACiAJCQkgKgkgICAg
MTAlIG9mIHRoZSBzeW1ib2wgcmF0ZQogCQkJICovCiAJCQlpbnRlcm5hbC0+c3JjaF9yYW5nZQk9
IFNlYXJjaFJhbmdlICsgMTUwMDAwMCArIChpX3BhcmFtcy0+c3JhdGUgLyA1KTsKLQkJCWludGVy
bmFsLT5kZXJvdF9wZXJjZW50CT0gMzA7CisJCQkvLyBBbGV4OiBjaGFuZ2VkIGZyb20gMzAKKwkJ
CWludGVybmFsLT5kZXJvdF9wZXJjZW50CT0gMjA7CiAKIAkJCS8qIFdoYXQgdG8gZG8gZm9yIHR1
bmVycyBoYXZpbmcgbm8gYmFuZHdpZHRoIHNldHVwID8JKi8KIAkJCS8qIGVuYWJsZSB0dW5lciBJ
L08gKi8K
------=_Part_29463_837078.1222871298716
Content-Type: application/octet-stream; name=stb0899_algo.c.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fls1yny31
Content-Disposition: attachment; filename=stb0899_algo.c.diff

LS0tIC9tZWRpYS9zdG9yYWdlL0Rvd25sb2FkL2R2Yi9tYW50aXMtMzAzYjFkMjlkNzM1L2xpbnV4
L2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9zdGIwODk5X2FsZ28uYwkyMDA4LTA5LTIxIDE4
OjQxOjAwLjAwMDAwMDAwMCArMDMwMAorKysgc3RiMDg5OV9hbGdvLmMJMjAwOC0xMC0wMSAxNjo1
MTozMy4wMDAwMDAwMDAgKzAzMDAKQEAgLTIwNywxOCArMjA3LDM3IEBACiAKIAlzaG9ydCBpbnQg
ZGVyb3Rfc3RlcCwgZGVyb3RfZnJlcSA9IDAsIGRlcm90X2xpbWl0LCBuZXh0X2xvb3AgPSAzOwog
CWludCBpbmRleCA9IDA7CisJaW50IGludGVybmFsX2luZGV4ID0gLTE7CisJaW50IG51bU9mSW50
ZXJuYWxMb29wcyA9IDM7CiAJdTggY2ZyWzJdOwogCiAJaW50ZXJuYWwtPnN0YXR1cyA9IE5PVElN
SU5HOwogCiAJLyogdGltaW5nIGxvb3AgY29tcHV0YXRpb24gJiBzeW1ib2wgcmF0ZSBvcHRpbWlz
YXRpb24JKi8KIAlkZXJvdF9saW1pdCA9IChpbnRlcm5hbC0+c3ViX3JhbmdlIC8gMkwpIC8gaW50
ZXJuYWwtPm1jbGs7Ci0JZGVyb3Rfc3RlcCA9IChwYXJhbXMtPnNyYXRlIC8gMkwpIC8gaW50ZXJu
YWwtPm1jbGs7CisJLy8gQWxleDogdXNlIHByZWNhbGN1bGF0ZWQgc3RlcAorCWRlcm90X3N0ZXAg
PSBpbnRlcm5hbC0+ZGVyb3Rfc3RlcCAqIDQ7CisJLy9kZXJvdF9zdGVwID0gKHBhcmFtcy0+c3Jh
dGUgLyAzMkwpIC8gaW50ZXJuYWwtPm1jbGs7CisKKwlkcHJpbnRrKHN0YXRlLT52ZXJib3NlLCBG
RV9ERUJVRywgMSwgImxpbWl0ID0gJWQsIHN0ZXAgPSAlZCwgbWNsayA9ICVkIiwgCisJCWRlcm90
X2xpbWl0LCBkZXJvdF9zdGVwLCBpbnRlcm5hbC0+bWNsayk7CiAKIAl3aGlsZSAoKHN0YjA4OTlf
Y2hlY2tfdG1nKHN0YXRlKSAhPSBUSU1JTkdPSykgJiYgbmV4dF9sb29wKSB7CisJCS8vIEFsZXg6
IExvb3Agb24gdGhlIHNhbWUgZnJlcSBmZXcgaW50ZXJhdGlvbnMJCQorCQlpbnRlcm5hbF9pbmRl
eCsrOworCQlpbnRlcm5hbF9pbmRleCAlPSBudW1PZkludGVybmFsTG9vcHM7CisJCQorCQlpZihp
bnRlcm5hbF9pbmRleCA9PSAwKSB7CiAJCWluZGV4Kys7CisKIAkJZGVyb3RfZnJlcSArPSBpbmRl
eCAqIGludGVybmFsLT5kaXJlY3Rpb24gKiBkZXJvdF9zdGVwOwkvKiBuZXh0IGRlcm90IHppZyB6
YWcgcG9zaXRpb24JKi8KIAorCQkJaW50ZXJuYWwtPmRpcmVjdGlvbiA9IC1pbnRlcm5hbC0+ZGly
ZWN0aW9uOwkvKiBDaGFuZ2UgemlnemFnIGRpcmVjdGlvbgkJKi8KKwkJfQorCisJCWRwcmludGso
c3RhdGUtPnZlcmJvc2UsIEZFX0RFQlVHLCAxLCAiaW5kZXggPSAlZCwgZGVyb3RfZnJlcSA9ICVk
LCBsaW1pdCA9ICVkLCBkaXJlY3Rpb24gPSAlZCwgc3RlcCA9ICVkIiwgCisJCWluZGV4LCBkZXJv
dF9mcmVxLCBkZXJvdF9saW1pdCwgaW50ZXJuYWwtPmRpcmVjdGlvbiwgZGVyb3Rfc3RlcCk7CisJ
CiAJCWlmIChBQlMoZGVyb3RfZnJlcSkgPiBkZXJvdF9saW1pdCkKIAkJCW5leHRfbG9vcC0tOwog
CkBAIC0yMjcsNyArMjQ2LDcgQEAKIAkJCVNUQjA4OTlfU0VURklFTERfVkFMKENGUkwsIGNmclsx
XSwgTFNCKHN0YXRlLT5jb25maWctPmludmVyc2lvbiAqIGRlcm90X2ZyZXEpKTsKIAkJCXN0YjA4
OTlfd3JpdGVfcmVncyhzdGF0ZSwgU1RCMDg5OV9DRlJNLCBjZnIsIDIpOyAvKiBkZXJvdGF0b3Ig
ZnJlcXVlbmN5CQkqLwogCQl9Ci0JCWludGVybmFsLT5kaXJlY3Rpb24gPSAtaW50ZXJuYWwtPmRp
cmVjdGlvbjsJLyogQ2hhbmdlIHppZ3phZyBkaXJlY3Rpb24JCSovCisKIAl9CiAKIAlpZiAoaW50
ZXJuYWwtPnN0YXR1cyA9PSBUSU1JTkdPSykgewpAQCAtMjc1LDE0ICsyOTQsMjMgQEAKIHsKIAlz
dHJ1Y3Qgc3RiMDg5OV9pbnRlcm5hbCAqaW50ZXJuYWwgPSAmc3RhdGUtPmludGVybmFsOwogCi0J
c2hvcnQgaW50IGRlcm90X2ZyZXEgPSAwLCBsYXN0X2Rlcm90X2ZyZXEgPSAwLCBkZXJvdF9saW1p
dCwgbmV4dF9sb29wID0gMzsKKwlzaG9ydCBpbnQgZGVyb3RfZnJlcSA9IDAsIGxhc3RfZGVyb3Rf
ZnJlcSA9IDAsIGRlcm90X2xpbWl0LCBkZXJvdF9zdGVwLCBuZXh0X2xvb3AgPSAzOwogCWludCBp
bmRleCA9IDA7CisJaW50IGludGVybmFsX2luZGV4ID0gLTE7CisJaW50IG51bU9mSW50ZXJuYWxM
b29wcyA9IDM7CisJaW50IGJhc2VfZnJlcTsKIAl1OCBjZnJbMl07CiAJdTggcmVnOwogCiAJaW50
ZXJuYWwtPnN0YXR1cyA9IE5PQ0FSUklFUjsKIAlkZXJvdF9saW1pdCA9IChpbnRlcm5hbC0+c3Vi
X3JhbmdlIC8gMkwpIC8gaW50ZXJuYWwtPm1jbGs7CiAJZGVyb3RfZnJlcSA9IGludGVybmFsLT5k
ZXJvdF9mcmVxOworCWRlcm90X3N0ZXAgPSBpbnRlcm5hbC0+ZGVyb3Rfc3RlcCAqIDI7CisJbGFz
dF9kZXJvdF9mcmVxID0gaW50ZXJuYWwtPmRlcm90X2ZyZXE7CisJYmFzZV9mcmVxID0gaW50ZXJu
YWwtPmRlcm90X2ZyZXE7CisKKwlkcHJpbnRrKHN0YXRlLT52ZXJib3NlLCBGRV9ERUJVRywgMSwg
ImZyZXEgPSAlZCwgbGltaXQgPSAlZCwgc3RlcCA9ICVkLCBtY2xrID0gJWQiLCAKKwkJZGVyb3Rf
ZnJlcSwgZGVyb3RfbGltaXQsIGRlcm90X3N0ZXAsIGludGVybmFsLT5tY2xrKTsKIAogCXJlZyA9
IHN0YjA4OTlfcmVhZF9yZWcoc3RhdGUsIFNUQjA4OTlfQ0ZEKTsKIAlTVEIwODk5X1NFVEZJRUxE
X1ZBTChDRkRfT04sIHJlZywgMSk7CkBAIC0yOTEsMTEgKzMxOSwyNCBAQAogCWRvIHsKIAkJZHBy
aW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEsICJEZXJvdCBGcmVxPSVkLCBtY2xrPSVk
IiwgZGVyb3RfZnJlcSwgaW50ZXJuYWwtPm1jbGspOwogCQlpZiAoc3RiMDg5OV9jaGVja19jYXJy
aWVyKHN0YXRlKSA9PSBOT0NBUlJJRVIpIHsKKwkJCS8vIEFsZXg6IExvb3Agb24gdGhlIHNhbWUg
ZnJlcSBmZXcgaW50ZXJhdGlvbnMJCQorCQkJaW50ZXJuYWxfaW5kZXgrKzsKKwkJCWludGVybmFs
X2luZGV4ICU9IG51bU9mSW50ZXJuYWxMb29wczsKKwkJCisJCQlpZihpbnRlcm5hbF9pbmRleCA9
PSAwKSB7CiAJCQlpbmRleCsrOworCiAJCQlsYXN0X2Rlcm90X2ZyZXEgPSBkZXJvdF9mcmVxOwot
CQkJZGVyb3RfZnJlcSArPSBpbmRleCAqIGludGVybmFsLT5kaXJlY3Rpb24gKiBpbnRlcm5hbC0+
ZGVyb3Rfc3RlcDsgLyogbmV4dCB6aWcgemFnIGRlcm90YXRvciBwb3NpdGlvbgkqLworCQkJCWRl
cm90X2ZyZXEgKz0gaW5kZXggKiBpbnRlcm5hbC0+ZGlyZWN0aW9uICogZGVyb3Rfc3RlcDsgLyog
bmV4dCB6aWcgemFnIGRlcm90YXRvciBwb3NpdGlvbgkqLwogCi0JCQlpZihBQlMoZGVyb3RfZnJl
cSkgPiBkZXJvdF9saW1pdCkKKwkJCQlpbnRlcm5hbC0+ZGlyZWN0aW9uID0gLWludGVybmFsLT5k
aXJlY3Rpb247IC8qIENoYW5nZSB6aWd6YWcgZGlyZWN0aW9uCSovCisJCQl9CisKKwkJCWRwcmlu
dGsoc3RhdGUtPnZlcmJvc2UsIEZFX0RFQlVHLCAxLCAiaW5kZXggPSAlZCwgZGVyb3RfZnJlcSA9
ICVkLCBsaW1pdCA9ICVkLCBzdGVwID0gJWQiLCAKKwkJaW5kZXgsIGRlcm90X2ZyZXEsIGRlcm90
X2xpbWl0LCBkZXJvdF9zdGVwKTsKKworCQkJLy8gQWxleDogc2hvdWxkIGxpbWl0IGJhc2VkIG9u
IGluaXRpYWwgYmFzZSBmcmVxCisJCQlpZihkZXJvdF9mcmVxID4gYmFzZV9mcmVxICsgZGVyb3Rf
bGltaXQgfHwgZGVyb3RfZnJlcSA8IGJhc2VfZnJlcSAtIGRlcm90X2xpbWl0KQogCQkJCW5leHRf
bG9vcC0tOwogCiAJCQlpZiAobmV4dF9sb29wKSB7CkBAIC0zMDgsOCArMzQ5LDYgQEAKIAkJCQlz
dGIwODk5X3dyaXRlX3JlZ3Moc3RhdGUsIFNUQjA4OTlfQ0ZSTSwgY2ZyLCAyKTsgLyogZGVyb3Rh
dG9yIGZyZXF1ZW5jeQkqLwogCQkJfQogCQl9Ci0KLQkJaW50ZXJuYWwtPmRpcmVjdGlvbiA9IC1p
bnRlcm5hbC0+ZGlyZWN0aW9uOyAvKiBDaGFuZ2UgemlnemFnIGRpcmVjdGlvbgkqLwogCX0gd2hp
bGUgKChpbnRlcm5hbC0+c3RhdHVzICE9IENBUlJJRVJPSykgJiYgbmV4dF9sb29wKTsKIAogCWlm
IChpbnRlcm5hbC0+c3RhdHVzID09IENBUlJJRVJPSykgewpAQCAtMzM1LDE2ICszNzQsMjIgQEAK
IAlpbnQgbG9jayA9IDAsIGluZGV4ID0gMCwgZGF0YVRpbWUgPSA1MDAsIGxvb3A7CiAJdTggcmVn
OwogCisJLy8gQWxleDogYWRkZWQgc2xlZXAgNSBtU2VjCisJbXNsZWVwKDUpOworCiAJaW50ZXJu
YWwtPnN0YXR1cyA9IE5PREFUQTsKIAogCS8qIFJFU0VUIEZFQwkqLwogCXJlZyA9IHN0YjA4OTlf
cmVhZF9yZWcoc3RhdGUsIFNUQjA4OTlfVFNUUkVTKTsKIAlTVEIwODk5X1NFVEZJRUxEX1ZBTChG
UkVTQUNTLCByZWcsIDEpOwogCXN0YjA4OTlfd3JpdGVfcmVnKHN0YXRlLCBTVEIwODk5X1RTVFJF
UywgcmVnKTsKLQltc2xlZXAoMSk7CisJLy8gQWxleDogY2hhbmdlZCBmcm9tIDEgdG8gNSBtU2Vj
CisJbXNsZWVwKDUpOwogCXJlZyA9IHN0YjA4OTlfcmVhZF9yZWcoc3RhdGUsIFNUQjA4OTlfVFNU
UkVTKTsKIAlTVEIwODk5X1NFVEZJRUxEX1ZBTChGUkVTQUNTLCByZWcsIDApOwogCXN0YjA4OTlf
d3JpdGVfcmVnKHN0YXRlLCBTVEIwODk5X1RTVFJFUywgcmVnKTsKKwkvLyBBbGV4OiBhZGRlZCA1
IG1TZWMKKwltc2xlZXAoNSk7CiAKIAlpZiAocGFyYW1zLT5zcmF0ZSA8PSAyMDAwMDAwKQogCQlk
YXRhVGltZSA9IDIwMDA7CkBAIC0zNTcsNiArNDAyLDkgQEAKIAogCXN0YjA4OTlfd3JpdGVfcmVn
KHN0YXRlLCBTVEIwODk5X0RTVEFUVVMyLCAweDAwKTsgLyogZm9yY2Ugc2VhcmNoIGxvb3AJKi8K
IAl3aGlsZSAoMSkgeworCQkvLyBBbGV4OiBhZGRlZCAxIG1TZWMKKwkJbXNsZWVwKDEpOworCiAJ
CS8qIFdBUk5JTkchIFZJVCBMT0NLRUQgaGFzIHRvIGJlIHRlc3RlZCBiZWZvcmUgVklUX0VORF9M
T09PUAkqLwogCQlyZWcgPSBzdGIwODk5X3JlYWRfcmVnKHN0YXRlLCBTVEIwODk5X1ZTVEFUVVMp
OwogCQlsb2NrID0gU1RCMDg5OV9HRVRGSUVMRChWU1RBVFVTX0xPQ0tFRFZJVCwgcmVnKTsKQEAg
LTM4NCwyMCArNDMyLDQzIEBACiAJc2hvcnQgaW50IGRlcm90X2ZyZXEsIGRlcm90X3N0ZXAsIGRl
cm90X2xpbWl0LCBuZXh0X2xvb3AgPSAzOwogCXU4IGNmclsyXTsKIAl1OCByZWc7Ci0JaW50IGlu
ZGV4ID0gMTsKKwlpbnQgaW5kZXggPSAwOworCWludCBpbnRlcm5hbF9pbmRleCA9IC0xOworCWlu
dCBudW1PZkludGVybmFsTG9vcHMgPSAzOworCWludCBiYXNlX2ZyZXE7CiAKIAlzdHJ1Y3Qgc3Ri
MDg5OV9pbnRlcm5hbCAqaW50ZXJuYWwgPSAmc3RhdGUtPmludGVybmFsOwogCXN0cnVjdCBzdGIw
ODk5X3BhcmFtcyAqcGFyYW1zID0gJnN0YXRlLT5wYXJhbXM7CiAKLQlkZXJvdF9zdGVwID0gKHBh
cmFtcy0+c3JhdGUgLyA0TCkgLyBpbnRlcm5hbC0+bWNsazsKKwkvLyBBbGV4OiB1c2UgcHJlY2Fs
Y3VsYXRlZCBzdGVwCisJZGVyb3Rfc3RlcCA9IGludGVybmFsLT5kZXJvdF9zdGVwOworCS8vZGVy
b3Rfc3RlcCA9IChwYXJhbXMtPnNyYXRlIC8gMTI4TCkgLyBpbnRlcm5hbC0+bWNsazsKIAlkZXJv
dF9saW1pdCA9IChpbnRlcm5hbC0+c3ViX3JhbmdlIC8gMkwpIC8gaW50ZXJuYWwtPm1jbGs7CiAJ
ZGVyb3RfZnJlcSA9IGludGVybmFsLT5kZXJvdF9mcmVxOworCWJhc2VfZnJlcSA9IGludGVybmFs
LT5kZXJvdF9mcmVxOworCisJZHByaW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEsICJs
aW1pdCA9ICVkLCBzdGVwID0gJWQsIG1jbGsgPSAlZCIsIAorCQlkZXJvdF9saW1pdCwgZGVyb3Rf
c3RlcCwgaW50ZXJuYWwtPm1jbGspOwogCiAJZG8gewogCQlpZiAoKGludGVybmFsLT5zdGF0dXMg
IT0gQ0FSUklFUk9LKSB8fCAoc3RiMDg5OV9jaGVja19kYXRhKHN0YXRlKSAhPSBEQVRBT0spKSB7
CisJCQkvLyBBbGV4OiBMb29wIG9uIHRoZSBzYW1lIGZyZXEgZmV3IGludGVyYXRpb25zCQkKKwkJ
CWludGVybmFsX2luZGV4Kys7CisJCQlpbnRlcm5hbF9pbmRleCAlPSBudW1PZkludGVybmFsTG9v
cHM7CisJCQorCQkJaWYoaW50ZXJuYWxfaW5kZXggPT0gMCkgeworCQkJCWluZGV4Kys7CiAKIAkJ
CWRlcm90X2ZyZXEgKz0gaW5kZXggKiBpbnRlcm5hbC0+ZGlyZWN0aW9uICogZGVyb3Rfc3RlcDsJ
LyogbmV4dCB6aWcgemFnIGRlcm90YXRvciBwb3NpdGlvbgkqLwotCQkJaWYgKEFCUyhkZXJvdF9m
cmVxKSA+IGRlcm90X2xpbWl0KQorCisJCQkJaW50ZXJuYWwtPmRpcmVjdGlvbiA9IC1pbnRlcm5h
bC0+ZGlyZWN0aW9uOyAvKiBjaGFuZ2UgemlnIHphZyBkaXJlY3Rpb24JCSovCisJCQl9CisKKwkJ
CWRwcmludGsoc3RhdGUtPnZlcmJvc2UsIEZFX0RFQlVHLCAxLCAiaW5kZXggPSAlZCwgZGVyb3Rf
ZnJlcSA9ICVkLCBsaW1pdCA9ICVkLCBkaXJlY3Rpb24gPSAlZCwgc3RlcCA9ICVkIiwgCisJCQlp
bmRleCwgZGVyb3RfZnJlcSwgZGVyb3RfbGltaXQsIGludGVybmFsLT5kaXJlY3Rpb24sIGRlcm90
X3N0ZXApOworCisJCQkvLyBBbGV4OiBzaG91bGQgbGltaXQgYmFzZWQgb24gaW5pdGlhbCBiYXNl
IGZyZXEKKwkJCWlmKGRlcm90X2ZyZXEgPiBiYXNlX2ZyZXEgKyBkZXJvdF9saW1pdCB8fCBkZXJv
dF9mcmVxIDwgYmFzZV9mcmVxIC0gZGVyb3RfbGltaXQpCiAJCQkJbmV4dF9sb29wLS07CiAKIAkJ
CWlmIChuZXh0X2xvb3ApIHsKQEAgLTQxMSwxMCArNDgyLDggQEAKIAkJCQlzdGIwODk5X3dyaXRl
X3JlZ3Moc3RhdGUsIFNUQjA4OTlfQ0ZSTSwgY2ZyLCAyKTsgLyogZGVyb3RhdG9yIGZyZXF1ZW5j
eQkqLwogCiAJCQkJc3RiMDg5OV9jaGVja19jYXJyaWVyKHN0YXRlKTsKLQkJCQlpbmRleCsrOwog
CQkJfQogCQl9Ci0JCWludGVybmFsLT5kaXJlY3Rpb24gPSAtaW50ZXJuYWwtPmRpcmVjdGlvbjsg
LyogY2hhbmdlIHppZyB6YWcgZGlyZWN0aW9uCQkqLwogCX0gd2hpbGUgKChpbnRlcm5hbC0+c3Rh
dHVzICE9IERBVEFPSykgJiYgbmV4dF9sb29wKTsKIAogCWlmIChpbnRlcm5hbC0+c3RhdHVzID09
IERBVEFPSykgewpAQCAtNTUxLDYgKzYyMCwxMCBAQAogCiAJLyogSW5pdGlhbCBjYWxjdWxhdGlv
bnMJKi8KIAlpbnRlcm5hbC0+ZGVyb3Rfc3RlcCA9IGludGVybmFsLT5kZXJvdF9wZXJjZW50ICog
KHBhcmFtcy0+c3JhdGUgLyAxMDAwTCkgLyBpbnRlcm5hbC0+bWNsazsgLyogRGVyb3RTdGVwLzEw
MDAgKiBGc3ltYm9sCSovCisKKwlkcHJpbnRrKHN0YXRlLT52ZXJib3NlLCBGRV9ERUJVRywgMSwg
IkRlcm90IHN0ZXA9JWQiLAorCQlpbnRlcm5hbC0+ZGVyb3Rfc3RlcCk7CisKIAlpbnRlcm5hbC0+
dF9kZXJvdCA9IHN0YjA4OTlfY2FsY19kZXJvdF90aW1lKHBhcmFtcy0+c3JhdGUpOwogCWludGVy
bmFsLT50X2RhdGEgPSA1MDA7CiAKQEAgLTg0NCw2ICs5MTcsOCBAQAogCWRlY19yYXRpbyA9IChk
ZWNfcmF0aW8gPT0gMCkgPyAxIDogZGVjX3JhdGlvOwogCWRlY19yYXRlID0gTG9nMkludChkZWNf
cmF0aW8pOwogCisJZHByaW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEsICJkZWNfcmF0
aW8gJWQsIGRlY19yYXRlICVkIiwgZGVjX3JhdGlvLCBkZWNfcmF0ZSk7CisKIAl3aW5fc2VsID0g
MDsKIAlpZiAoZGVjX3JhdGUgPj0gNSkKIAkJd2luX3NlbCA9IGRlY19yYXRlIC0gNDsKQEAgLTg1
Nyw2ICs5MzIsOCBAQAogCWVsc2UKIAkJYmFuZF9saW0gPSAwOwkvKiBiYW5kIGxpbWl0IHNpZ25h
bCBnb2luZyBpbnRvIGJ0ciBibG9jayovCiAKKwlkcHJpbnRrKHN0YXRlLT52ZXJib3NlLCBGRV9E
RUJVRywgMSwgImRlY2ltICVkLCBmX3N5bSAlZCwgbWFzdGVyX2NsayAlZCwgc3JhdGUgJWQsIGJh
bmRfbGltICVkIiwgZGVjaW0sIGZfc3ltLCBpbnRlcm5hbC0+bWFzdGVyX2NsaywgaW50ZXJuYWwt
PnNyYXRlLCBiYW5kX2xpbSk7CisKIAlkZWNpbV9jbnRybCA9ICgod2luX3NlbCA8PCAzKSAmIDB4
MTgpICsgKChiYW5kX2xpbSA8PCA1KSAmIDB4MjApICsgKGRlY19yYXRlICYgMHg3KTsKIAlzdGIw
ODk5X3dyaXRlX3MycmVnKHN0YXRlLCBTVEIwODk5X1MyREVNT0QsIFNUQjA4OTlfQkFTRV9ERUNJ
TV9DTlRSTCwgU1RCMDg5OV9PRkYwX0RFQ0lNX0NOVFJMLCBkZWNpbV9jbnRybCk7CiAKQEAgLTg2
Nyw2ICs5NDQsOCBAQAogCWVsc2UKIAkJYW50aV9hbGlhcyA9IDI7CiAKKwlkcHJpbnRrKHN0YXRl
LT52ZXJib3NlLCBGRV9ERUJVRywgMSwgImFudGlfYWxpYXMgJWQiLCBhbnRpX2FsaWFzKTsKKwog
CXN0YjA4OTlfd3JpdGVfczJyZWcoc3RhdGUsIFNUQjA4OTlfUzJERU1PRCwgU1RCMDg5OV9CQVNF
X0FOVElfQUxJQVNfU0VMLCBTVEIwODk5X09GRjBfQU5USV9BTElBU19TRUwsIGFudGlfYWxpYXMp
OwogCWJ0cl9ub21fZnJlcSA9IHN0YjA4OTlfZHZiczJfY2FsY19zcmF0ZShzdGF0ZSk7CiAJc3Ri
MDg5OV93cml0ZV9zMnJlZyhzdGF0ZSwgU1RCMDg5OV9TMkRFTU9ELCBTVEIwODk5X0JBU0VfQlRS
X05PTV9GUkVRLCBTVEIwODk5X09GRjBfQlRSX05PTV9GUkVRLCBidHJfbm9tX2ZyZXEpOwpAQCAt
ODc5LDYgKzk1OCw5IEBACiAJLyogc2NhbGUgVVdQK0NTTSBmcmVxdWVuY3kgdG8gc2FtcGxlIHJh
dGUqLwogCWZyZXFfYWRqID0gIGludGVybmFsLT5zcmF0ZSAvIChpbnRlcm5hbC0+bWFzdGVyX2Ns
ayAvIDQwOTYpOwogCXN0YjA4OTlfd3JpdGVfczJyZWcoc3RhdGUsIFNUQjA4OTlfUzJERU1PRCwg
U1RCMDg5OV9CQVNFX0ZSRVFfQURKX1NDQUxFLCBTVEIwODk5X09GRjBfRlJFUV9BREpfU0NBTEUs
IGZyZXFfYWRqKTsKKworCWRwcmludGsoc3RhdGUtPnZlcmJvc2UsIEZFX0RFQlVHLCAxLCAiYnRy
X25vbV9mcmVxICVkLCBjb3JyZWN0aW9uICVkLCBmcmVxX2FkaiAlZCIsIGJ0cl9ub21fZnJlcSwg
Y29ycmVjdGlvbiwgZnJlcV9hZGopOworCiB9CiAKIC8qCkBAIC05ODUsNyArMTA2NywxMiBAQAog
CWVsc2UKIAkJc3RlcF9zaXplID0gKDEgPDwgMTcpIC8gNDsKIAotCXJhbmdlID0gaW50ZXJuYWwt
PnNyY2hfcmFuZ2UgLyAxMDAwMDAwOworCS8vIEFsZXg6IG1ha2Ugc21hbGxlciBzdGVwcworCXN0
ZXBfc2l6ZSA9IDI1MDsKKworCWRwcmludGsoc3RhdGUtPnZlcmJvc2UsIEZFX0RFQlVHLCAxLCAi
c3RlcCBzaXplICVkIiwgc3RlcF9zaXplKTsKKworCXJhbmdlID0gNDsvL0FsZXg6IHJldHVybiB0
bzogaW50ZXJuYWwtPnNyY2hfcmFuZ2UgLyAxMDAwMDAwOwogCXN0ZXBzID0gKDEwICogcmFuZ2Ug
KiAoMSA8PCAxNykpIC8gKHN0ZXBfc2l6ZSAqIChpbnRlcm5hbC0+c3JhdGUgLyAxMDAwMDAwKSk7
CiAJc3RlcHMgPSAoc3RlcHMgKyA2KSAvIDEwOwogCXN0ZXBzID0gKHN0ZXBzID09IDApID8gMSA6
IHN0ZXBzOwpAQCAtOTk2LDYgKzEwODMsOCBAQAogCWVsc2UKIAkJc3RiMDg5OV9kdmJzMl9zZXRf
Y2Fycl9mcmVxKHN0YXRlLCBpbnRlcm5hbC0+Y2VudGVyX2ZyZXEsIChpbnRlcm5hbC0+bWFzdGVy
X2NsaykgLyAxMDAwMDAwKTsKIAorCWRwcmludGsoc3RhdGUtPnZlcmJvc2UsIEZFX0RFQlVHLCAx
LCAicmFuZ2UgJWQsIHN0ZXBzICVkIiwgcmFuZ2UsIHN0ZXBzKTsKKwogCS8qU2V0IENhcnJpZXIg
U2VhcmNoIHBhcmFtcyAoemlnemFnLCBudW0gc3RlcHMgYW5kIGZyZXEgc3RlcCBzaXplKi8KIAly
ZWcgPSBTVEIwODk5X1JFQURfUzJSRUcoU1RCMDg5OV9TMkRFTU9ELCBBQ1FfQ05UUkwyKTsKIAlT
VEIwODk5X1NFVEZJRUxEX1ZBTChaSUdaQUcsIHJlZywgMSk7CkBAIC0xMDg0LDYgKzExNzMsOCBA
QAogCWludCB0aW1lID0gLTEwLCBsb2NrID0gMCwgdXdwLCBjc207CiAJdTMyIHJlZzsKIAorCWRw
cmludGsoc3RhdGUtPnZlcmJvc2UsIEZFX0RFQlVHLCAxLCAidGltZW91dCA9ICVkIG1TZWMiLCB0
aW1lb3V0KTsKKwogCWRvIHsKIAkJcmVnID0gU1RCMDg5OV9SRUFEX1MyUkVHKFNUQjA4OTlfUzJE
RU1PRCwgRE1EX1NUQVRVUyk7CiAJCWRwcmludGsoc3RhdGUtPnZlcmJvc2UsIEZFX0RFQlVHLCAx
LCAiRE1EX1NUQVRVUz1bMHglMDJ4XSIsIHJlZyk7CkBAIC0xMTM2LDYgKzEyMjcsOCBAQAogewog
CWludCB0aW1lID0gMCwgTG9ja2VkOwogCisJZHByaW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVfREVC
VUcsIDEsICJ0aW1lb3V0ID0gJWQiLCB0aW1lb3V0KTsKKwogCWRvIHsKIAkJTG9ja2VkID0gc3Ri
MDg5OV9kdmJzMl9nZXRfZGF0YV9sb2NrKHN0YXRlLCAxKTsKIAkJdGltZSsrOwpAQCAtMTM0Miw2
ICsxNDM0LDEyIEBACiAJCUZlY0xvY2tUaW1lCT0gMjA7CS8qIDIwIG1zIG1heCB0aW1lIHRvIGxv
Y2sgRkVDLCAyME1iczwgU1lNQiA8PSAyNU1icwkJKi8KIAl9CiAKKwkvLyBBbGV4OiB0aW1lb3V0
cyBzZWVtcyB0byBiZSB0b28gc21hbGwKKwlzZWFyY2hUaW1lICo9IDEwOworCUZlY0xvY2tUaW1l
ICo9IDEwOworCisJZHByaW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEsICJzcmF0ZSA9
ICVkLCBzZWFyY2hUaW1lID0gJWQsIEZlY0xvY2tUaW1lID0gJWQiLCBpbnRlcm5hbC0+c3JhdGUs
IHNlYXJjaFRpbWUsIEZlY0xvY2tUaW1lKTsKKwogCS8qIE1haW50YWluIFN0cmVhbSBNZXJnZXIg
aW4gcmVzZXQgZHVyaW5nIGFjcXVpc2l0aW9uCSovCiAJcmVnID0gc3RiMDg5OV9yZWFkX3JlZyhz
dGF0ZSwgU1RCMDg5OV9UU1RSRVMpOwogCVNUQjA4OTlfU0VURklFTERfVkFMKEZSRVNSUywgcmVn
LCAxKTsKQEAgLTE0MDEsMTIgKzE0OTksMTggQEAKIAkJCS8qCVJlYWQgdGhlIGZyZXF1ZW5jeSBv
ZmZzZXQqLwogCQkJb2Zmc2V0ZnJlcSA9IFNUQjA4OTlfUkVBRF9TMlJFRyhTVEIwODk5X1MyREVN
T0QsIENSTF9GUkVRKTsKIAorCQkJZHByaW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEs
ICIxOiBpID0gJWQsIG9mZnNldGZyZXEgPSAlZCIsIGksIG9mZnNldGZyZXEpOworCiAJCQkvKiBT
ZXQgdGhlIE5vbWluYWwgZnJlcXVlbmN5IHRvIHRoZSBmb3VuZCBmcmVxdWVuY3kgb2Zmc2V0IGZv
ciB0aGUgbmV4dCByZWFjcXVpcmUqLwogCQkJcmVnID0gU1RCMDg5OV9SRUFEX1MyUkVHKFNUQjA4
OTlfUzJERU1PRCwgQ1JMX05PTV9GUkVRKTsKIAkJCVNUQjA4OTlfU0VURklFTERfVkFMKENSTF9O
T01fRlJFUSwgcmVnLCBvZmZzZXRmcmVxKTsKIAkJCXN0YjA4OTlfd3JpdGVfczJyZWcoc3RhdGUs
IFNUQjA4OTlfUzJERU1PRCwgU1RCMDg5OV9CQVNFX0NSTF9OT01fRlJFUSwgU1RCMDg5OV9PRkYw
X0NSTF9OT01fRlJFUSwgcmVnKTsKIAkJCXN0YjA4OTlfZHZiczJfcmVhY3F1aXJlKHN0YXRlKTsK
KworCQkJbXNsZWVwKDEwKTsKKwogCQkJaW50ZXJuYWwtPnN0YXR1cyA9IHN0YjA4OTlfZHZiczJf
Z2V0X2ZlY19zdGF0dXMoc3RhdGUsIHNlYXJjaFRpbWUpOworCiAJCQlpKys7CiAJCX0KIAl9CkBA
IC0xNDEyLDEyICsxNTE2LDE5IEBACiAJfQogCiAJaWYgKGludGVybmFsLT5zdGF0dXMgIT0gRFZC
UzJfRkVDX0xPQ0spIHsKKwkJZHByaW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEsICJz
dGlsbCBubyBsb2NrLCBpbnZlcnNpb24gPSAlZCIsIGludGVybmFsLT5pbnZlcnNpb24pOworCiAJ
CWlmIChpbnRlcm5hbC0+aW52ZXJzaW9uID09IElRX1NXQVBfQVVUTykgeworCQkJZHByaW50ayhz
dGF0ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEsICJpbnZlcnNpb24gPSBJUV9TV0FQX0FVVE8iKTsK
KwogCQkJcmVnID0gU1RCMDg5OV9SRUFEX1MyUkVHKFNUQjA4OTlfUzJERU1PRCwgRE1EX0NOVFJM
Mik7CiAJCQlpcVNwZWN0cnVtID0gU1RCMDg5OV9HRVRGSUVMRChTUEVDVFJVTV9JTlZFUlQsIHJl
Zyk7CiAJCQkvKiBJUSBTcGVjdHJ1bSBJbnZlcnNpb24JKi8KIAkJCVNUQjA4OTlfU0VURklFTERf
VkFMKFNQRUNUUlVNX0lOVkVSVCwgcmVnLCAhaXFTcGVjdHJ1bSk7CiAJCQlzdGIwODk5X3dyaXRl
X3MycmVnKHN0YXRlLCBTVEIwODk5X1MyREVNT0QsIFNUQjA4OTlfQkFTRV9ETURfQ05UUkwyLCBT
VEIwODk5X09GRjBfRE1EX0NOVFJMMiwgcmVnKTsKKworCQkJbXNsZWVwKDEwKTsKKwogCQkJLyog
c3RhcnQgYWNxdWlzdGlvbiBwcm9jZXNzCSovCiAJCQlzdGIwODk5X2R2YnMyX3JlYWNxdWlyZShz
dGF0ZSk7CiAKQEAgLTE0MzIsMTMgKzE1NDQsMTkgQEAKIAkJCQkJLyoJUmVhZCB0aGUgZnJlcXVl
bmN5IG9mZnNldCovCiAJCQkJCW9mZnNldGZyZXEgPSBTVEIwODk5X1JFQURfUzJSRUcoU1RCMDg5
OV9TMkRFTU9ELCBDUkxfRlJFUSk7CiAKKwkJCQkJZHByaW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVf
REVCVUcsIDEsICIyOiBpID0gJWQsIG9mZnNldGZyZXEgPSAlZCIsIGksIG9mZnNldGZyZXEpOwor
CiAJCQkJCS8qIFNldCB0aGUgTm9taW5hbCBmcmVxdWVuY3kgdG8gdGhlIGZvdW5kIGZyZXF1ZW5j
eSBvZmZzZXQgZm9yIHRoZSBuZXh0IHJlYWNxdWlyZSovCiAJCQkJCXJlZyA9IFNUQjA4OTlfUkVB
RF9TMlJFRyhTVEIwODk5X1MyREVNT0QsIENSTF9OT01fRlJFUSk7CiAJCQkJCVNUQjA4OTlfU0VU
RklFTERfVkFMKENSTF9OT01fRlJFUSwgcmVnLCBvZmZzZXRmcmVxKTsKIAkJCQkJc3RiMDg5OV93
cml0ZV9zMnJlZyhzdGF0ZSwgU1RCMDg5OV9TMkRFTU9ELCBTVEIwODk5X0JBU0VfQ1JMX05PTV9G
UkVRLCBTVEIwODk5X09GRjBfQ1JMX05PTV9GUkVRLCByZWcpOwogCisJCQkJCW1zbGVlcCgxMCk7
CisKIAkJCQkJc3RiMDg5OV9kdmJzMl9yZWFjcXVpcmUoc3RhdGUpOworCiAJCQkJCWludGVybmFs
LT5zdGF0dXMgPSBzdGIwODk5X2R2YnMyX2dldF9mZWNfc3RhdHVzKHN0YXRlLCBzZWFyY2hUaW1l
KTsKKwogCQkJCQlpKys7CiAJCQkJfQogCQkJfQpAQCAtMTQ2NCwxMyArMTU4MiwyMSBAQAogCiAJ
CQlpID0gMDsKIAkJCXdoaWxlICgoaW50ZXJuYWwtPnN0YXR1cyAhPSBEVkJTMl9GRUNfTE9DSykg
JiYgKGkgPCAzKSkgeworCisJCQkJZHByaW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEs
ICIzOiBpID0gJWQiLCBpKTsKKwogCQkJCWNzbTEgPSBTVEIwODk5X1JFQURfUzJSRUcoU1RCMDg5
OV9TMkRFTU9ELCBDU01fQ05UUkwxKTsKIAkJCQlTVEIwODk5X1NFVEZJRUxEX1ZBTChDU01fVFdP
X1BBU1MsIGNzbTEsIDEpOwogCQkJCXN0YjA4OTlfd3JpdGVfczJyZWcoc3RhdGUsIFNUQjA4OTlf
UzJERU1PRCwgU1RCMDg5OV9CQVNFX0NTTV9DTlRSTDEsIFNUQjA4OTlfT0ZGMF9DU01fQ05UUkwx
LCBjc20xKTsKKworCQkJCW1zbGVlcCgxMCk7CisKIAkJCQljc20xID0gU1RCMDg5OV9SRUFEX1My
UkVHKFNUQjA4OTlfUzJERU1PRCwgQ1NNX0NOVFJMMSk7CiAJCQkJU1RCMDg5OV9TRVRGSUVMRF9W
QUwoQ1NNX1RXT19QQVNTLCBjc20xLCAwKTsKIAkJCQlzdGIwODk5X3dyaXRlX3MycmVnKHN0YXRl
LCBTVEIwODk5X1MyREVNT0QsIFNUQjA4OTlfQkFTRV9DU01fQ05UUkwxLCBTVEIwODk5X09GRjBf
Q1NNX0NOVFJMMSwgY3NtMSk7CiAKKwkJCQltc2xlZXAoMTApOworCiAJCQkJaW50ZXJuYWwtPnN0
YXR1cyA9IHN0YjA4OTlfZHZiczJfZ2V0X2ZlY19zdGF0dXMoc3RhdGUsIEZlY0xvY2tUaW1lKTsK
IAkJCQlpKys7CiAJCQl9CkBAIC0xNDgwLDYgKzE2MDYsOCBAQAogCQkgICAgICAoSU5SQU5HRShT
VEIwODk5X1FQU0tfMTIsIG1vZGNvZCwgU1RCMDg5OV9RUFNLXzM1KSkgJiYKIAkJICAgICAgKHBp
bG90cyA9PSAxKSkgewogCisgIAkJCWRwcmludGsoc3RhdGUtPnZlcmJvc2UsIEZFX0RFQlVHLCAx
LCAiRXF1YWxpemVyIGRpc2FibGUgdXBkYXRlIik7CisKIAkJCS8qIEVxdWFsaXplciBEaXNhYmxl
IHVwZGF0ZQkgKi8KIAkJCXJlZyA9IFNUQjA4OTlfUkVBRF9TMlJFRyhTVEIwODk5X1MyREVNT0Qs
IEVRX0NOVFJMKTsKIAkJCVNUQjA4OTlfU0VURklFTERfVkFMKEVRX0RJU0FCTEVfVVBEQVRFLCBy
ZWcsIDEpOwpAQCAtMTQ5MSwxOCArMTYxOSwyNiBAQAogCQlTVEIwODk5X1NFVEZJRUxEX1ZBTChF
UV9TSElGVCwgcmVnLCAweDAyKTsKIAkJc3RiMDg5OV93cml0ZV9zMnJlZyhzdGF0ZSwgU1RCMDg5
OV9TMkRFTU9ELCBTVEIwODk5X0JBU0VfRVFfQ05UUkwsIFNUQjA4OTlfT0ZGMF9FUV9DTlRSTCwg
cmVnKTsKIAorCQltc2xlZXAoMTApOworCiAJCS8qIFN0b3JlIHNpZ25hbCBwYXJhbWV0ZXJzCSov
CiAJCW9mZnNldGZyZXEgPSBTVEIwODk5X1JFQURfUzJSRUcoU1RCMDg5OV9TMkRFTU9ELCBDUkxf
RlJFUSk7CiAKKwkJZHByaW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEsICJvZmZzZXRm
cmVxIGZyb20gcmVnID0gJWQiLCBvZmZzZXRmcmVxKTsKKwogCQlvZmZzZXRmcmVxID0gb2Zmc2V0
ZnJlcSAvICgoMSA8PCAzMCkgLyAxMDAwKTsKIAkJb2Zmc2V0ZnJlcSAqPSAoaW50ZXJuYWwtPm1h
c3Rlcl9jbGsgLyAxMDAwMDAwKTsKIAkJcmVnID0gU1RCMDg5OV9SRUFEX1MyUkVHKFNUQjA4OTlf
UzJERU1PRCwgRE1EX0NOVFJMMik7CiAJCWlmIChTVEIwODk5X0dFVEZJRUxEKFNQRUNUUlVNX0lO
VkVSVCwgcmVnKSkKIAkJCW9mZnNldGZyZXEgKj0gLTE7CiAKKwkJZHByaW50ayhzdGF0ZS0+dmVy
Ym9zZSwgRkVfREVCVUcsIDEsICJvZmZzZXRmcmVxIGFmdGVyIGNhbGMgPSAlZCIsIG9mZnNldGZy
ZXEpOworCiAJCWludGVybmFsLT5mcmVxID0gaW50ZXJuYWwtPmZyZXEgLSBvZmZzZXRmcmVxOwog
CQlpbnRlcm5hbC0+c3JhdGUgPSBzdGIwODk5X2R2YnMyX2dldF9zcmF0ZShzdGF0ZSk7CiAKKwkJ
ZHByaW50ayhzdGF0ZS0+dmVyYm9zZSwgRkVfREVCVUcsIDEsICJmcmVxID0gJWQsIHNyYXRlID0g
JWQiLCBpbnRlcm5hbC0+ZnJlcSwgaW50ZXJuYWwtPnNyYXRlKTsKKwogCQlyZWcgPSBTVEIwODk5
X1JFQURfUzJSRUcoU1RCMDg5OV9TMkRFTU9ELCBVV1BfU1RBVDIpOwogCQlpbnRlcm5hbC0+bW9k
Y29kID0gU1RCMDg5OV9HRVRGSUVMRChVV1BfREVDT0RFX01PRCwgcmVnKSA+PiAyOwogCQlpbnRl
cm5hbC0+cGlsb3RzID0gU1RCMDg5OV9HRVRGSUVMRChVV1BfREVDT0RFX01PRCwgcmVnKSAmIDB4
MDE7Cg==
------=_Part_29463_837078.1222871298716
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_29463_837078.1222871298716--
