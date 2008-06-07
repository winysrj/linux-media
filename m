Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bsmtp.bon.at ([213.33.87.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.schoeller@schoeller-soft.net>)
	id 1K4uy7-0008TD-LD
	for linux-dvb@linuxtv.org; Sat, 07 Jun 2008 11:44:17 +0200
Message-ID: <484A584B.9010901@schoeller-soft.net>
Date: Sat, 07 Jun 2008 11:43:39 +0200
From: =?ISO-8859-15?Q?Michael_Sch=F6ller?=
	<michael.schoeller@schoeller-soft.net>
MIME-Version: 1.0
To: Dominik Kuhlen <dkuhlen@gmx.net>
References: <484709F3.7020003@schoeller-soft.net>	<854d46170806060249h1aec73e4s645462a123371c29@mail.gmail.com>	<48497340.3050602@schoeller-soft.net>
	<200806070018.16103.dkuhlen@gmx.net>
In-Reply-To: <200806070018.16103.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to get a PCTV Sat HDTC Pro USB (452e) running?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1310590855=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1310590855==
Content-Type: multipart/alternative;
 boundary="------------010900010001020807090404"

This is a multi-part message in MIME format.
--------------010900010001020807090404
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Dominik Kuhlen schrieb:
> Hi,
>
> On Friday 06 June 2008, Michael Sch=F6ller wrote:
>  =20
>> Well that worked! I was able to compile the drivers. :)
>>
>> And the bad news. I wasn't able to compile dvb-apps. Or to be more=20
>> specific I followed the instructions for patching dvb-apps to work wit=
h=20
>> multiproto. (
>>
>> http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025222.html)
>>
>> As I understand the instructions I copied the source code of scan to t=
he dvb-apps/util/scan directory and applied the patch on it. After a litt=
le extra change for the includes (changed them to point to the ones of mu=
ltiproto). I was able to compile the hole stuff without errors. However s=
can always gives me an DVBFE_SET_PARAMS ioctl fail with "Invalid argument=
".
>>    =20
> are you sure you have unloaded all old dvb modules?
>  =20
Well I not sure with anything. Since /dev/dvb is only showing up after=20
compile the new modules I think so. I do not really have a clue to=20
verify it. I'm playing around with the trial and error system.
>  =20
>> After some time I give up on and tried to patch szap. Well szap seems =
to be a wrong version since even used structures in the source code has d=
ifferent names than the ones in the patch file. I got dvb-apps with hg fr=
om linuxtv.org.
>>
>> I'm really down now my hope to get this damn thing running before the =
first EM match is now not present. Good by HDTV quality games hello PAL..=
.
>>    =20
> could you please try whether the simpledvbtune application from=20
> http://linuxtv.org/pipermail/linux-dvb/2008-April/025535.html
> works.
>
> ---snip---
>  =20
I will try that after reinstalling YDL6. Currently I switch between=20
Fedora9 and YDL6 to see what distribution gives lesser headache.
>  =20
>>>> make[2]: Leaving directory `/usr/src/ps3-linux'
>>>>        =20
> Are you running this on a PS3?=20
>
>
>  Dominik
>
>  =20
Well yes. *g* My Ps3 is my Multimedia center ^^. Ok its not so Media=20
center at the moment but it will be...
So all files for me has to be compiled for PPC/PPC64 architecture.

Ok I can tell that my problem is Distribution independent=20
</search?hl=3Dde&sa=3DX&oi=3Dspell&resnum=3D0&ct=3Dresult&cd=3D1&q=3Dinde=
pendent&spell=3D1>.=20
On Fedora it's a bit harder to get multiproto running (/dev/dvb appears)=20
but the error with scan and szap is the same ("ioctl DVBFE_GET_INFO=20
failed: Invalid Argument").

This time I tried these steps (based on the hints in previous posts)
1. hg clone http://www.jusst.de/hg/multiproto
2. cd into multiproto and run "patch -p1 <=20
patch_add_pctv452e_tt_s2_36x0.diff" (the fixed one from Jens Message at=20
22:09) -> no errors
3. run "make" and "make install" -> well gives compile errors so I=20
followed Faruks instructions
3b) cd to multiproto/linux/drivers/media/video
 and rename the Makefile to like Makefile_
after this i won't compile any analog drivers and it will compile dvb
and radio drivers.
3c) 3. run "make clean", "make" and "make install" ->works now
4. hg clone http://linuxtv.org/hg/dvb-apps
5. cd into dvb-apps and run "patch -p1 < patch_sca_szap.diff" (attached=20
in the message) -> no errors
 6. copy version.h and frontend.h -> Well that one was tricky I found=20
out that the place where the include files are in /usr/include/linux/dvb=20
is that correct. However after copy them to this location make in the=20
scan and szap directory works. And make in the dvb-apps now gives an=20
error that Fields are already defined. Well however thats not in the=20
steps so I do..
7. cd into dvb-apps/util/<scan,szap> and run "make" -> well that=20
works....to compile
ioctl DVBFE_GET_INFO failed: Invalid Argument...I'm starting to hate=20
that words...

What I did not try at the moment:

Hmm i really don't know, anyway here is my copy already been patched
and compiled. If the binary scan doesn't work run "make clean" and
then "make"
http://www.zshare.net/download/1322006118c9c70a/

Faruk
-------------------------------------------
Well and the one I'm not sure about if that is really nesecary when apply=
ing the patch from step 5.

I'm glad it worked out for you. The dvb-apps scan never worked with=20
multiproto there is another version for multiproto you can download it=20
from here. http://jusst.de/manu/scan.tar.bz2

Michael

--------------010900010001020807090404
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content=3D"text/html;charset=3DISO-8859-15"
 http-equiv=3D"Content-Type">
  <title></title>
</head>
<body bgcolor=3D"#ffffff" text=3D"#000000">
Dominik Kuhlen schrieb:
<blockquote cite=3D"mid:200806070018.16103.dkuhlen@gmx.net" type=3D"cite"=
>
  <pre wrap=3D"">Hi,

On Friday 06 June 2008, Michael Sch=F6ller wrote:
  </pre>
  <blockquote type=3D"cite">
    <pre wrap=3D"">Well that worked! I was able to compile the drivers. :=
)

And the bad news. I wasn't able to compile dvb-apps. Or to be more=20
specific I followed the instructions for patching dvb-apps to work with=20
multiproto. (

<a class=3D"moz-txt-link-freetext" href=3D"http://www.linuxtv.org/piperma=
il/linux-dvb/2008-April/025222.html">http://www.linuxtv.org/pipermail/lin=
ux-dvb/2008-April/025222.html</a>)

As I understand the instructions I copied the source code of scan to the =
dvb-apps/util/scan directory and applied the patch on it. After a little =
extra change for the includes (changed them to point to the ones of multi=
proto). I was able to compile the hole stuff without errors. However scan=
 always gives me an DVBFE_SET_PARAMS ioctl fail with "Invalid argument".
    </pre>
  </blockquote>
  <pre wrap=3D""><!---->are you sure you have unloaded all old dvb module=
s?
  </pre>
</blockquote>
Well I not sure with anything. Since /dev/dvb is only showing up after
compile the new modules I think so. I do not really have a clue to
verify it. I'm playing around with the trial and error system.<br>
<blockquote cite=3D"mid:200806070018.16103.dkuhlen@gmx.net" type=3D"cite"=
>
  <pre wrap=3D"">
  </pre>
  <blockquote type=3D"cite">
    <pre wrap=3D"">After some time I give up on and tried to patch szap. =
Well szap seems to be a wrong version since even used structures in the s=
ource code has different names than the ones in the patch file. I got dvb=
-apps with hg from linuxtv.org.

I'm really down now my hope to get this damn thing running before the fir=
st EM match is now not present. Good by HDTV quality games hello PAL...
    </pre>
  </blockquote>
  <pre wrap=3D""><!---->could you please try whether the simpledvbtune ap=
plication from=20
<a class=3D"moz-txt-link-freetext" href=3D"http://linuxtv.org/pipermail/l=
inux-dvb/2008-April/025535.html">http://linuxtv.org/pipermail/linux-dvb/2=
008-April/025535.html</a>
works.

---snip---
  </pre>
</blockquote>
I will try that after reinstalling YDL6. Currently I switch between
Fedora9 and YDL6 to see what distribution gives lesser headache.<br>
<blockquote cite=3D"mid:200806070018.16103.dkuhlen@gmx.net" type=3D"cite"=
>
  <pre wrap=3D"">
  </pre>
  <blockquote type=3D"cite">
    <blockquote type=3D"cite">
      <blockquote type=3D"cite">
        <pre wrap=3D"">make[2]: Leaving directory `/usr/src/ps3-linux'
        </pre>
      </blockquote>
    </blockquote>
  </blockquote>
  <pre wrap=3D""><!---->Are you running this on a PS3?=20


 Dominik

  </pre>
</blockquote>
Well yes. *g* My Ps3 is my Multimedia center ^^. Ok its not so Media
center at the moment but it will be...<br>
So all files for me has to be compiled for PPC/PPC64 architecture.<br>
<br>
Ok I can tell that my problem is Distribution <a class=3D"p"
 href=3D"/search?hl=3Dde&amp;sa=3DX&amp;oi=3Dspell&amp;resnum=3D0&amp;ct=3D=
result&amp;cd=3D1&amp;q=3Dindependent&amp;spell=3D1">independent</a>.
On Fedora it's a bit harder to get multiproto running (/dev/dvb
appears) but the error with scan and szap is the same ("ioctl
DVBFE_GET_INFO failed: Invalid Argument").<br>
<br>
This time I tried these steps (based on the hints in previous posts)<br>
1. hg clone <a href=3D"http://www.jusst.de/hg/multiproto">http://www.juss=
t.de/hg/multiproto</a>
<br>
2. cd into multiproto and run "patch -p1 &lt;
patch_add_pctv452e_tt_s2_36x0.diff" (the fixed one from Jens Message at
22:09)
-&gt; no errors<br>
3. run "make" and "make install"
-&gt; well gives compile errors so I followed Faruks instructions<br>
3b) cd to multiproto/linux/drivers/media/video<span
 class=3D"moz-txt-citetags"><br>
=A0</span>and rename the Makefile to like Makefile_<span
 class=3D"moz-txt-citetags"><br>
</span>after this i won't compile any analog drivers and it will
compile dvb<span class=3D"moz-txt-citetags"><br>
</span>and radio drivers.<br>
3c) 3. run "make clean", "make" and "make install" -&gt;works now<br>
4. hg clone <a href=3D"http://linuxtv.org/hg/dvb-apps">http://linuxtv.org=
/hg/dvb-apps</a>
<br>
5. cd into dvb-apps and run "patch -p1 &lt; patch_sca_szap.diff"
(attached in the message) -&gt; no errors<br>
=A06. copy version.h and frontend.h
-&gt; Well that one was tricky I found out that the place where the
include files are in /usr/include/linux/dvb is that correct. However
after copy them to this location make in the scan and szap directory
works. And make in the dvb-apps now gives an error that Fields are
already defined. Well however thats not in the steps so I do..<br>
7. cd into dvb-apps/util/&lt;scan,szap&gt; and run "make"
-&gt; well that works....to compile<br>
ioctl DVBFE_GET_INFO failed: Invalid Argument...I'm starting to hate
that words...<br>
<br>
What I did not try at the moment:<br>
<pre wrap=3D"">Hmm i really don't know, anyway here is my copy already be=
en patched
and compiled. If the binary scan doesn't work run "make clean" and
then "make"
<a class=3D"moz-txt-link-freetext"
 href=3D"http://www.zshare.net/download/1322006118c9c70a/">http://www.zsh=
are.net/download/1322006118c9c70a/</a>

Faruk
-------------------------------------------
Well and the one I'm not sure about if that is really nesecary when apply=
ing the patch from step 5.
</pre>
I'm glad it worked out for you. The dvb-apps scan never worked with<span
 class=3D"moz-txt-citetags"> </span>multiproto <span
 class=3D"moz-txt-citetags"></span>there is another version for
multiproto you can download it from here. <span
 class=3D"moz-txt-citetags"></span><a class=3D"moz-txt-link-freetext"
 href=3D"http://jusst.de/manu/scan.tar.bz2">http://jusst.de/manu/scan.tar=
.bz2</a><br>
<br>
Michael<br>
</body>
</html>

--------------010900010001020807090404--


--===============1310590855==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1310590855==--
