Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <meysam.hariri@gmail.com>) id 1KlA4d-0003nW-VV
	for linux-dvb@linuxtv.org; Thu, 02 Oct 2008 00:21:36 +0200
Received: by ug-out-1314.google.com with SMTP id 39so2852602ugf.16
	for <linux-dvb@linuxtv.org>; Wed, 01 Oct 2008 15:21:32 -0700 (PDT)
Message-ID: <1a18e9e80810011521o35f59ba5k658ab5f2c70cbfeb@mail.gmail.com>
Date: Thu, 2 Oct 2008 01:51:32 +0330
From: "Meysam Hariri" <meysam.hariri@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <1a18e9e80810011520k439bf72cqb8bb679588c79d8c@mail.gmail.com>
MIME-Version: 1.0
References: <c74595dc0809290713i7ca11bdfw3424c8347e9a6d9e@mail.gmail.com>
	<909452.76198.qm@web23201.mail.ird.yahoo.com>
	<c74595dc0809300248i12241125ia77a788f3094bc75@mail.gmail.com>
	<c74595dc0810010728j7de23c62h87a36a2c8705d977@mail.gmail.com>
	<1a18e9e80810011520k439bf72cqb8bb679588c79d8c@mail.gmail.com>
Subject: [linux-dvb]  Re : Re : TT S2-3200 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1046822155=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1046822155==
Content-Type: multipart/alternative;
	boundary="----=_Part_6762_20199680.1222899692403"

------=_Part_6762_20199680.1222899692403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

thanks for your update. i used a TT-3200 device and here's the results:
- i couldn't lock on some S2 channels or those 'bad' channels, although i
could get unstable lock on these channels using the unpatched version, but
resulting in corrupted data. so the unpatched version still works a bit
better.
- the lock on QPSK S2 channels is fast and stable as it was with the
unpatched version
- locking on dvb-s channels is also fast and stable

i'm ready to test any further updates.

Regards,


2008/10/1 Alex Betis <alex.betis@gmail.com>

Hi all,
>
> My description of the solution is here:
> http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html
>
> I've also attaching the patches to this thread.
>
> Several people reported better lock on DVB-S channels.
>
> Just to clarify it, the changes mostly affect DVB-S channels scanning, it
> doesn't help with DVB-S2 locking problem since the code is totally differ=
ent
> for S and S2 signal search.
>
> I've increased a timer for S2 signal search and decreased the search step=
,
> this helps to lock on "good" S2 channels that were locked anyway with
> several attempts, but this time it locks from first attempt. The "bad"
> channels finds the signal, but the FEC is unable to lock.
> Since searching of S2 channels is done in the card and not in the driver,
> its pretty hard to know what is going on there.
>
> Can't say what happens with the lock on "good" channels since I don't hav=
e
> any S2 FTA in my sight.
>
> If anyone has any progress with S2 lock, let me know, I'd like to join th=
e
> forces.
>
>
>
> On Tue, Sep 30, 2008 at 12:48 PM, Alex Betis <alex.betis@gmail.com> wrote=
:
>
>> I'll send the patches to the list as soon as I'll finish some more
>> debugging and clean the code from all the garbage I've added there.
>>
>> Meanwhile I'd also like to wait for few people responses who test those
>> patches. So far one person with Twinhan 1041 card confirmed that the cha=
nges
>> "improved a lot" the locking. Waiting for few more people with TT S2-320=
0 to
>> confirm it.
>>
>>
>> On Tue, Sep 30, 2008 at 12:35 PM, Newsy Paper <
>> newspaperman_germany@yahoo.com> wrote:
>>
>>> Hi Alex!
>>>
>>> This souds like good news!
>>> Hope you could help us with a patch from you.
>>>
>>> kind regards
>>>
>>>
>>> Newsy
>>>
>>>
>>> --- Alex Betis <alex.betis@gmail.com> schrieb am Mo, 29.9.2008:
>>>
>>> > Von: Alex Betis <alex.betis@gmail.com>
>>> > Betreff: Re: [linux-dvb] Re : Re : TT S2-3200 driver
>>> > An: "Jelle De Loecker" <skerit@kipdola.com>
>>> > CC: "linux-dvb" <linux-dvb@linuxtv.org>
>>> > Datum: Montag, 29. September 2008, 16:13
>>> > Does that card use stb0899 drivers as Twinhan 1041?
>>> >
>>> > I've done some changes to the algorithm that provide
>>> > constant lock.
>>> >
>>> > 2008/9/29 Jelle De Loecker <skerit@kipdola.com>
>>> >
>>> > >
>>> > > manu schreef:
>>> > >
>>> > > Le 13.09.2008 19:10:31, Manu Abraham a =E9crit :
>>> > >
>>> > >
>>> > >  manu wrote:
>>> > >
>>> > >
>>> > >  I forgot the logs...
>>> > >
>>> > >
>>> > >  Taking a look at it. Please do note that, i will have
>>> > to go through
>>> > > it
>>> > > very patiently.
>>> > >
>>> > > Thanks for the logs.
>>> > >
>>> > >
>>> > >
>>> > >  You're more than welcome. I tried to put some
>>> > printk's but the only
>>> > > thing I got is that even when the carrier is correctly
>>> > detected, the
>>> > > driver does not detect the data (could that be related
>>> > to the different
>>> > > FEC?).
>>> > > Anyway let me know if you need more testing.
>>> > > Bye
>>> > > Manu
>>> > >
>>> > >
>>> > > I'm unable to scan the channels on the Astra 23,5
>>> > satellite
>>> > > Frequency 11856000
>>> > > Symbol rate 27500000
>>> > > Vertical polarisation
>>> > > FEC 5/6
>>> > >
>>> > > Is this because of the same bug? I should be getting
>>> > Discovery Channel HD,
>>> > > National Geographic Channel HD, Brava HDTV and Voom HD
>>> > International, but
>>> > > I'm only getting a time out.
>>> > >
>>> > >
>>> > > *Met vriendelijke groeten,*
>>> > >
>>> > > *Jelle De Loecker*
>>> > > Kipdola Studios - Tomberg
>>> > >
>>> > >
>>> > >
>>> > > _______________________________________________
>>> > > linux-dvb mailing list
>>> > > linux-dvb@linuxtv.org
>>> > >
>>> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>> > >
>>> > _______________________________________________
>>> > linux-dvb mailing list
>>> > linux-dvb@linuxtv.org
>>> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>>
>>>
>>>
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>
>>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_6762_20199680.1222899692403
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><div class=3D"gmail_quote">Hi,<br><div dir=3D"ltr"><br>tha=
nks for your update. i used a TT-3200 device and here&#39;s the results:<br=
>- i couldn&#39;t lock on some S2 channels or those &#39;bad&#39; channels,=
 although i could get unstable lock on these channels using the unpatched v=
ersion, but resulting in corrupted data. so the unpatched version still wor=
ks a bit better.<br>

- the lock on QPSK S2 channels is fast and stable as it was with the unpatc=
hed version<br>- locking on dvb-s channels is also fast and stable<br><br>i=
&#39;m ready to test any further updates.<br><br>Regards,<br><br><br><div c=
lass=3D"gmail_quote">

2008/10/1 Alex Betis <span dir=3D"ltr">&lt;<a href=3D"mailto:alex.betis@gma=
il.com" target=3D"_blank">alex.betis@gmail.com</a>&gt;</span><div><div></di=
v><div class=3D"Wj3C7c"><br><blockquote class=3D"gmail_quote" style=3D"bord=
er-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-l=
eft: 1ex;">

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
oin the forces.<div><div></div><div><br><br><br><div class=3D"gmail_quote">=
On Tue, Sep 30, 2008 at 12:48 PM, Alex Betis <span dir=3D"ltr">&lt;<a href=
=3D"mailto:alex.betis@gmail.com" target=3D"_blank">alex.betis@gmail.com</a>=
&gt;</span> wrote:<br>




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
</blockquote></div><br></div></div></div>
<br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank">linux-dvb@linuxt=
v.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br></blockquote></div></div></div><br></div>
</div><br></div>

------=_Part_6762_20199680.1222899692403--


--===============1046822155==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1046822155==--
