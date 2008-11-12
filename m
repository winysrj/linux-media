Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L0LQy-0007EW-6e
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 20:31:25 +0100
Received: by qw-out-2122.google.com with SMTP id 9so381091qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 11:31:20 -0800 (PST)
Message-ID: <c74595dc0811121131k2a6f35dfm9da8de305dfd199b@mail.gmail.com>
Date: Wed, 12 Nov 2008 21:31:20 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <c74595dc0810301510t5ae3df6fg28c6a62e999aed83@mail.gmail.com>
MIME-Version: 1.0
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<b42fca4d0810280227n44d53f03hfaa8237793fc1db9@mail.gmail.com>
	<c74595dc0810281223j25d78c9eqbcbed70a1b495b43@mail.gmail.com>
	<b42fca4d0810281305l6e741c25ia25e1f3f348761d5@mail.gmail.com>
	<c74595dc0810281320r9ef1a1cw172a36738c8a4e8@mail.gmail.com>
	<c74595dc0810301510t5ae3df6fg28c6a62e999aed83@mail.gmail.com>
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0893499310=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0893499310==
Content-Type: multipart/alternative;
	boundary="----=_Part_12011_22802236.1226518280089"

------=_Part_12011_22802236.1226518280089
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Some more updates for scan-s2:
- Fixed skip count specified by "-k" option (skipped one message less than
specified).
- Removed dumping (null) provider name.
- Fixed DVB-T tuning. Thanks to Hans Werner.
- Fixed some network ID output problems. Thanks to Oleg Roitburd.
- Added options to specify "S1" and "S2" entries in frequency file that will
use DVB-S and DVB-S2 scan modes respectively.
- Added "-D" option to disable scanning of some modes. "-D S1" will disable
DVB-S scan, "-D S2" will disable DVB-S2 scan.
- Added 3/5 and 9/10 FEC options. Thanks to Michael Verbraak.

In my TODO list so far:
- Revise and add diseqc motor support patch from Hans Werner.
- Revise and add few more patches sent by different people.
- Revise NIT message parsing to figure out why it doesn't add transponders
with correct delivery system.
- Add UTF-8 channels encoding support.

Please test the latest version of scan-s2 from:
http://mercurial.intuxication.org/hg/scan-s2/

Let me know if something doesn't work as it should.

Thanks.
Alex.


On Fri, Oct 31, 2008 at 12:10 AM, Alex Betis <alex.betis@gmail.com> wrote:

> Hi all,
>
> Some updates for scan-s2:
> - Frequency files parameters that can specify AUTO are now optional, not
> required to appear in the file. See README.
> - Added ROLLOFF and modulation specification for DVB-S format. See README.
> - Fixed usage of -n (network search) switch. NIT messages will not add new
> transponders by default now, so add -n if you really want it.
> - NIT messages will not update existing transponders any more. After seeing
> several bad NIT messages that caused to miss channels I think that will be
> better that way.
> - Added dumping of modulation and rolloff to VDR format file. The program
> queries the driver after successful tuning to get real parameters of the
> channel. Currently the driver do not return real values except for FEC, so
> if you specify AUTO values the output file will not have the real rolloff
> and modulation values. Igor said he will look at it.
> - Added CAID dump to VDR file format, see "-x -2" switch.
> - "-x XXX" switch opeation is fixed. Don't know who might want to use it
> after real CAID dump (option -2) and dump zeroes to CAID (option -1) is
> available.
>
>
> Currently my TODO list include UTF channel names encoding. If you think of
> something else, please let me know and I'll try to add.
>
> Please test the latest version of scan-s2 from:
> http://mercurial.intuxication.org/hg/scan-s2/
>
> Enjoy,
> Alex.
>
>
>
>
> On Tue, Oct 28, 2008 at 10:20 PM, Alex Betis <alex.betis@gmail.com> wrote:
>
>>
>>
>> On Tue, Oct 28, 2008 at 10:05 PM, oleg roitburd <oroitburd@gmail.com>wrote:
>>
>>>
>>> Small snipet from VDR/channels.c
>>> -------------------------------snip------------------------------
>>> const tChannelParameterMap ModulationValues[] = {
>>>  {  16, QAM_16,   "QAM16" },
>>>  {  32, QAM_32,   "QAM32" },
>>>  {  64, QAM_64,   "QAM64" },
>>>  { 128, QAM_128,  "QAM128" },
>>>  { 256, QAM_256,  "QAM256" },
>>>  {   2, QPSK,     "QPSK" },
>>>  {   5, PSK_8,    "8PSK" },
>>>  {   6, APSK_16,  "16APSK" },
>>>  {  10, VSB_8,    "VSB8" },
>>>  {  11, VSB_16,   "VSB16" },
>>>  { 998, QAM_AUTO, "QAMAUTO" },
>>>  { -1 }
>>>  };
>>>
>>> -------------------------------------------snap----------------------------
>>
>> Thanks. I'll use it in the dump.
>>
>>
>>>
>>> >
>>> > FEC you can specify in the frequency file as "AUTO", "1/3", "2/3" and
>>> so on.
>>> > I'll update README to make it clear. All frequency files samples show
>>> that
>>> > option.
>>>
>>> i have seen, that FEC will be set if FEC is in initial file.
>>> If transponder was found via NIT it will be not set
>>
>> Yeah, it was my change since I saw NIT specifying incorrect FEC for a
>> channel that was in my frequency list already!
>> I'll probably change it so NIT will be considered as the correct info
>> unless frequency list include non-AUTO value.
>> This way it will be possible to overwrite values or rely on network
>> announcements if you want full automatic behavior.
>>
>>
>>
>

------=_Part_12011_22802236.1226518280089
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Some more updates for scan-s2:<br>- Fixed skip count specified by &quot;-k&quot; option (skipped one message less than specified).<br>- Removed dumping (null) provider name.<br>- Fixed DVB-T tuning. Thanks to Hans Werner.<br>

- Fixed some network ID output problems. Thanks to Oleg Roitburd.<br>- Added options to specify &quot;S1&quot; and &quot;S2&quot; entries in frequency file that will use DVB-S and DVB-S2 scan modes respectively.<br>- Added &quot;-D&quot; option to disable scanning of some modes. &quot;-D S1&quot; will disable DVB-S scan, &quot;-D S2&quot; will disable DVB-S2 scan.<br>

- Added 3/5 and 9/10 FEC options. Thanks to Michael Verbraak.<br><br>In my TODO list so far:<br>- Revise and add diseqc motor support patch from Hans Werner.<br>- Revise and add few more patches sent by different people.<br>
- Revise NIT message parsing to figure out why it doesn&#39;t add transponders with correct delivery system.<br>- Add UTF-8 channels encoding support.<br><br>Please test the latest version of scan-s2 from: <br>
<a href="http://mercurial.intuxication.org/hg/scan-s2/" target="_blank">http://mercurial.intuxication.org/hg/scan-s2/</a><br><br>Let me know if something doesn&#39;t work as it should.<br><br>Thanks.<br>Alex.<br><br><br>
<div class="gmail_quote">
On Fri, Oct 31, 2008 at 12:10 AM, Alex Betis <span dir="ltr">&lt;<a href="mailto:alex.betis@gmail.com" target="_blank">alex.betis@gmail.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

<div dir="ltr">Hi all,<br><br>Some updates for scan-s2:<br>- Frequency files parameters that can specify AUTO are now optional, not required to appear in the file. See README.<br>- Added ROLLOFF and modulation specification for DVB-S format. See README.<br>


- Fixed usage of -n (network search) switch. NIT messages will not add new transponders by default now, so add -n if you really want it.<br>- NIT messages will not update existing transponders any more. After seeing several bad NIT messages that caused to miss channels I think that will be better that way.<br>


- Added dumping of modulation and rolloff to VDR format file. The program queries the driver after successful tuning to get real parameters of the channel. Currently the driver do not return real values except for FEC, so if you specify AUTO values the output file will not have the real rolloff and modulation values. Igor said he will look at it.<br>


- Added CAID dump to VDR file format, see &quot;-x -2&quot; switch.<br>- &quot;-x XXX&quot; switch opeation is fixed. Don&#39;t know who might want to use it after real CAID dump (option -2) and dump zeroes to CAID (option -1) is available.<br>


<br><br>Currently my TODO list include UTF channel names encoding. If you think of something else, please let me know and I&#39;ll try to add.<br><br>Please test the latest version of scan-s2 from: <br><div>
<a href="http://mercurial.intuxication.org/hg/scan-s2/" target="_blank">http://mercurial.intuxication.org/hg/scan-s2/</a><br>
<br></div>Enjoy,<br><font color="#888888">Alex.</font><div><div></div><div><br><br><br><br><div class="gmail_quote">On Tue, Oct 28, 2008 at 10:20 PM, Alex Betis <span dir="ltr">&lt;<a href="mailto:alex.betis@gmail.com" target="_blank">alex.betis@gmail.com</a>&gt;</span> wrote:<br>

<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div dir="ltr"><br><br><div class="gmail_quote"><div>On Tue, Oct 28, 2008 at 10:05 PM, oleg roitburd <span dir="ltr">&lt;<a href="mailto:oroitburd@gmail.com" target="_blank">oroitburd@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
Small snipet from VDR/channels.c<br>
-------------------------------snip------------------------------<br>
const tChannelParameterMap ModulationValues[] = {<br>
 &nbsp;{ &nbsp;16, QAM_16, &nbsp; &quot;QAM16&quot; },<br>
 &nbsp;{ &nbsp;32, QAM_32, &nbsp; &quot;QAM32&quot; },<br>
 &nbsp;{ &nbsp;64, QAM_64, &nbsp; &quot;QAM64&quot; },<br>
 &nbsp;{ 128, QAM_128, &nbsp;&quot;QAM128&quot; },<br>
 &nbsp;{ 256, QAM_256, &nbsp;&quot;QAM256&quot; },<br>
 &nbsp;{ &nbsp; 2, QPSK, &nbsp; &nbsp; &quot;QPSK&quot; },<br>
 &nbsp;{ &nbsp; 5, PSK_8, &nbsp; &nbsp;&quot;8PSK&quot; },<br>
 &nbsp;{ &nbsp; 6, APSK_16, &nbsp;&quot;16APSK&quot; },<br>
 &nbsp;{ &nbsp;10, VSB_8, &nbsp; &nbsp;&quot;VSB8&quot; },<br>
 &nbsp;{ &nbsp;11, VSB_16, &nbsp; &quot;VSB16&quot; },<br>
 &nbsp;{ 998, QAM_AUTO, &quot;QAMAUTO&quot; },<br>
 &nbsp;{ -1 }<br>
 &nbsp;};<br>
-------------------------------------------snap----------------------------</blockquote></div><div>Thanks. I&#39;ll use it in the dump.<br>&nbsp;<br></div><div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">



<br>
<div>&gt;<br>
&gt; FEC you can specify in the frequency file as &quot;AUTO&quot;, &quot;1/3&quot;, &quot;2/3&quot; and so on.<br>
&gt; I&#39;ll update README to make it clear. All frequency files samples show that<br>
&gt; option.<br>
<br>
</div>i have seen, that FEC will be set if FEC is in initial file.<br>
If transponder was found via NIT it will be not set</blockquote></div><div>Yeah, it was my change since I saw NIT specifying incorrect FEC for a channel that was in my frequency list already!<br>I&#39;ll probably change it so NIT will be considered as the correct info unless frequency list include non-AUTO value.<br>



This way it will be possible to overwrite values or rely on network announcements if you want full automatic behavior.<br>&nbsp;<br></div></div><br></div>
</blockquote></div><br></div></div></div>
</blockquote></div><br></div>

------=_Part_12011_22802236.1226518280089--


--===============0893499310==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0893499310==--
