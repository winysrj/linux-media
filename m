Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
MIME-Version: 1.0
In-Reply-To: <49DE9016.3090306@linuxtv.org>
References: <8de7a23f0904090007x3905ee7dp817efe67044b8223@mail.gmail.com>
	<49DE0044.10700@linuxtv.org>
	<8de7a23f0904091518t72643426ub77855d43bab9631@mail.gmail.com>
	<49DE9016.3090306@linuxtv.org>
Date: Mon, 13 Apr 2009 15:19:35 +1200
Message-ID: <8de7a23f0904122019r2a4c88beud00831e1700a7071@mail.gmail.com>
From: Alastair Bain <bainorama@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] HVR-1700 - can't open or scan
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1202469192=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1202469192==
Content-Type: multipart/alternative; boundary=000e0cd1560608df120467672fa1

--000e0cd1560608df120467672fa1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Thanks for the quick replies, the problem seems to be in the version of
dvbscan I've got (was built from repository). plain old scan worked fine,
tzap also worked correctly once I had the channel configs.

Alastair


2009/4/10 Steven Toth <stoth@linuxtv.org>

> Alastair Bain wrote:
>
>>
>>
>> 2009/4/10 Steven Toth <stoth@linuxtv.org <mailto:stoth@linuxtv.org>>
>>
>>    Alastair Bain wrote:
>>
>>        I'm trying to get the Hauppauge HVR-1700 working on a Mythbuntu
>>        9.04 b install. Looks like the modules are all loading, firmware
>>        is being loaded, device appears in /dev etc, but I can't seem to
>>        do anything with it. dvbscan fails around ln 315,
>>
>>        dvbfe_get_info(fe, DVBFE_INFO_LOCKSTATUS, &feinfo,
>>                                       DVBFE_INFO_QUERYTYPE_IMMEDIATE, 0)
>>        returns DVBFE_INFO_QUERYTYPE_LOCKCHANGE
>>
>>        Anyone have any clues as to what I can do to fix this? Kernel
>>        trace is at http://pastebin.com/m7671e816.
>>
>>
>>    trace looks fine.
>>
>>    Try tzap then report back.
>>
>>    - Steve
>>    --
>>    To unsubscribe from this list: send the line "unsubscribe
>>    linux-media" in
>>    the body of a message to majordomo@vger.kernel.org
>>    <mailto:majordomo@vger.kernel.org>
>>    More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> I don't think I can use tzap until I have the results from dvbscan can I?
>>
>>
> Do not drop the CC for the mailing list, I was replying to the list - not
> directly to you.
>
> Find a channels.conf for your local transmitter, I used to use Crystal
> Palace for London. We have all of them already for the UK.
>
> - Steve
>
>

--000e0cd1560608df120467672fa1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks for the quick replies, the problem seems to be in the version of dvb=
scan I&#39;ve got (was built from repository). plain old scan worked fine, =
tzap also worked correctly once I had the channel configs. <br><br>Alastair=
<br>
<br><br><div class=3D"gmail_quote">2009/4/10 Steven Toth <span dir=3D"ltr">=
&lt;<a href=3D"mailto:stoth@linuxtv.org">stoth@linuxtv.org</a>&gt;</span><b=
r><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204=
, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Alastair Bain wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<br>
2009/4/10 Steven Toth &lt;<a href=3D"mailto:stoth@linuxtv.org" target=3D"_b=
lank">stoth@linuxtv.org</a> &lt;mailto:<a href=3D"mailto:stoth@linuxtv.org"=
 target=3D"_blank">stoth@linuxtv.org</a>&gt;&gt;<div class=3D"im"><br>
<br>
 =A0 =A0Alastair Bain wrote:<br>
<br>
 =A0 =A0 =A0 =A0I&#39;m trying to get the Hauppauge HVR-1700 working on a M=
ythbuntu<br>
 =A0 =A0 =A0 =A09.04 b install. Looks like the modules are all loading, fir=
mware<br>
 =A0 =A0 =A0 =A0is being loaded, device appears in /dev etc, but I can&#39;=
t seem to<br>
 =A0 =A0 =A0 =A0do anything with it. dvbscan fails around ln 315,<br>
<br>
 =A0 =A0 =A0 =A0dvbfe_get_info(fe, DVBFE_INFO_LOCKSTATUS, &amp;feinfo,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 DVBFE_INFO_QUERYTYPE_IMMEDIATE, 0)<br>
 =A0 =A0 =A0 =A0returns DVBFE_INFO_QUERYTYPE_LOCKCHANGE<br>
<br>
 =A0 =A0 =A0 =A0Anyone have any clues as to what I can do to fix this? Kern=
el<br>
 =A0 =A0 =A0 =A0trace is at <a href=3D"http://pastebin.com/m7671e816" targe=
t=3D"_blank">http://pastebin.com/m7671e816</a>.<br>
<br>
<br>
 =A0 =A0trace looks fine.<br>
<br>
 =A0 =A0Try tzap then report back.<br>
<br>
 =A0 =A0- Steve<br>
 =A0 =A0--<br>
 =A0 =A0To unsubscribe from this list: send the line &quot;unsubscribe<br>
 =A0 =A0linux-media&quot; in<br>
 =A0 =A0the body of a message to <a href=3D"mailto:majordomo@vger.kernel.or=
g" target=3D"_blank">majordomo@vger.kernel.org</a><br></div>
 =A0 =A0&lt;mailto:<a href=3D"mailto:majordomo@vger.kernel.org" target=3D"_=
blank">majordomo@vger.kernel.org</a>&gt;<div class=3D"im"><br>
 =A0 =A0More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordo=
mo-info.html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html<=
/a><br>
<br>
<br>
I don&#39;t think I can use tzap until I have the results from dvbscan can =
I?<br>
<br>
</div></blockquote>
<br>
Do not drop the CC for the mailing list, I was replying to the list - not d=
irectly to you.<br>
<br>
Find a channels.conf for your local transmitter, I used to use Crystal Pala=
ce for London. We have all of them already for the UK.<br>
<br>
- Steve<br>
<br>
</blockquote></div><br>

--000e0cd1560608df120467672fa1--


--===============1202469192==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1202469192==--
