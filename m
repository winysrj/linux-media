Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <orgler@gmail.com>) id 1KQ07q-0005xB-GK
	for linux-dvb@linuxtv.org; Mon, 04 Aug 2008 15:29:29 +0200
Received: by yx-out-2324.google.com with SMTP id 8so114133yxg.41
	for <linux-dvb@linuxtv.org>; Mon, 04 Aug 2008 06:29:21 -0700 (PDT)
Message-ID: <619be8660808040629r1d523e6cn843ee52a5325e19b@mail.gmail.com>
Date: Mon, 4 Aug 2008 15:29:21 +0200
From: "Johannes Michler" <orgler@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Problems using DISEQC with TBS 8920 DVB-S2 card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0082902188=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0082902188==
Content-Type: multipart/alternative;
	boundary="----=_Part_36781_12435448.1217856561151"

------=_Part_36781_12435448.1217856561151
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I recently got an TBS 8920 DVB-S2 card and I'm now trying to get it work
using Ubuntu 8.04.
Since the card wasn't automatcially detected and the list appearing when
loading the cx88xx driver doesn't contain the card I downloaded the drivers
from here: http://www.tbsdtv.com/english/product/PCIDVBS2.html
I compiled and installed the drivers as descripted, and after a reboot the
card was propely detected.
My satelitte configuration is as follows: I've got a monoblock LNB, with
Hotbird13 on "A" and Astra19 on "B"
doing a "scan /usr/share/doc/dvb-utils/examples/scan/dvb-s/Hotbird" reports
me a lot of channels. But the diseq signal is being ignored, when doing
"scan -s 1 Hotbird" I get the same channels and doing "scan -s 1 Astra"
gives me no channels (scan is aborted after a view seconds, saying it cannot
do initial tuning)
dmesg tells someting about sending 18V and 13V, but this seems to be
informative messages only.
Did someone here succeed in getting this card to work? Or is there another
card which is "equal" to this card. I don't now unfortunately what TBS
changed in there linux driver, this doesn't seem to be documented. The
cx88-cards.h entry for my card is as follows:


[CX88_BOARD_TBS8920] = {

.name = "TBS DVB-S/S2",

.tuner_type = TUNER_ABSENT,

.radio_type = UNSET,

.tuner_addr = ADDR_UNSET,

.radio_addr = ADDR_UNSET,

.input = {{

.type = CX88_VMUX_DVB,

.vmux = 0,

},{

.type = CX88_VMUX_COMPOSITE1,

.vmux = 1,

}},

.mpeg = CX88_MPEG_DVB,

},

Any help would be appreciated,

best regards
Johannes

------=_Part_36781_12435448.1217856561151
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div>Hi,</div>
<div>&nbsp;</div>
<div>I recently got an TBS 8920 DVB-S2 card and I&#39;m now trying to get it work using Ubuntu 8.04.</div>
<div>Since the card wasn&#39;t automatcially detected and the list appearing when loading the cx88xx driver doesn&#39;t contain the card I downloaded the drivers from here: <a href="http://www.tbsdtv.com/english/product/PCIDVBS2.html">http://www.tbsdtv.com/english/product/PCIDVBS2.html</a></div>

<div>I compiled and installed the drivers as descripted, and after a reboot the card was propely detected.</div>
<div>My satelitte configuration is as follows: I&#39;ve got a monoblock LNB, with Hotbird13 on &quot;A&quot; and Astra19 on &quot;B&quot;</div>
<div>doing a &quot;scan /usr/share/doc/dvb-utils/examples/scan/dvb-s/Hotbird&quot; reports me a lot of channels. But the diseq signal is being ignored, when doing &quot;scan -s 1 Hotbird&quot; I get the same channels and doing &quot;scan -s 1 Astra&quot; gives me no channels (scan is aborted after a view seconds, saying it cannot do initial tuning)</div>

<div>dmesg tells someting about sending 18V and 13V, but this seems to be informative messages only.</div>
<div>Did someone here succeed in getting this card to work? Or is there another card which is &quot;equal&quot; to this card. I don&#39;t now unfortunately what TBS changed in there linux driver, this doesn&#39;t seem to be documented. The cx88-cards.h entry for my card is as follows:</div>

<div>&nbsp;</div><span lang="DE">
<p>[CX88_BOARD_TBS8920] = {</p>
<p>.name = &quot;TBS DVB-S/S2&quot;,</p>
<p>.tuner_type = TUNER_ABSENT,</p>
<p>.radio_type = UNSET,</p>
<p>.tuner_addr = ADDR_UNSET,</p>
<p>.radio_addr = ADDR_UNSET,</p>
<p>.input = {{</p>
<p>.type = CX88_VMUX_DVB,</p>
<p>.vmux = 0,</p>
<p>},{</p>
<p>.type = CX88_VMUX_COMPOSITE1,</p>
<p>.vmux = 1,</p>
<p>}},</p>
<p>.mpeg = CX88_MPEG_DVB,</p>
<p>},</p></span>
<div>&nbsp;</div>
<div>Any help would be appreciated,</div>
<div>&nbsp;</div>
<div>best regards</div>
<div>Johannes</div></div>

------=_Part_36781_12435448.1217856561151--


--===============0082902188==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0082902188==--
