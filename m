Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KpPUc-0004Xa-M0
	for linux-dvb@linuxtv.org; Mon, 13 Oct 2008 17:38:03 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8O00IE9OQA2OL0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 13 Oct 2008 11:37:24 -0400 (EDT)
Date: Mon, 13 Oct 2008 11:37:22 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20081011190015.175420@gmx.net>
To: Hans Werner <HWerner4@gmx.de>, darron@kewl.org, scarfoglio@arpacoop.it,
	fabbione@fabbione.net
Message-id: <48F36B32.5060006@linuxtv.org>
MIME-version: 1.0
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48CD87B1.5010702@linuxtv.org> <20080915121606.111520@gmx.net>
	<48CE7838.2060702@linuxtv.org> <23602.1221904652@kewl.org>
	<48D51000.3060006@linuxtv.org> <25577.1221924224@kewl.org>
	<20080921234339.18450@gmx.net> <8002.1222068668@kewl.org>
	<20080922124908.203800@gmx.net> <10822.1222089271@kewl.org>
	<48D7C15E.5060509@linuxtv.org> <20080922164108.203780@gmx.net>
	<20022.1222162539@kewl.org> <20080923142509.86330@gmx.net>
	<4025.1222264419@kewl.org> <4284.1222265835@kewl.org>
	<20080925145223.47290@gmx.net> <18599.1222354652@kewl.org>
	<Pine.LNX.4.64.0809261117150.21806@trider-g7>
	<21180.1223610119@kewl.org>
	<20081010132352.273810@gmx.net> <48EF7E78.6040102@linuxtv.org>
	<30863.1223711672@kewl.org> <48F0AA35.6020005@linuxtv.org>
	<773.1223732259@kewl.org> <48F0AEA3.50704@linuxtv.org>
	<989.1223733525@kewl.org> <48F0B6C5.5090505@linuxtv.org>
	<1506.1223737964@kewl.org> <48F0E516.303@linuxtv.org>
	<20081011190015.175420@gmx.net>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Multi-frontend patch merge (TESTERS FEEDBACK) was: Re:
 [PATCH] S2API: add multifrontend
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hans Werner wrote:
> -------- Original-Nachricht --------
>> Datum: Sat, 11 Oct 2008 13:40:38 -0400
>> Von: Steven Toth <stoth@linuxtv.org>
>> An: Darron Broad <darron@kewl.org>
>> CC: Hans Werner <HWerner4@gmx.de>, fabbione@fabbione.net, scarfoglio@arpacoop.it
>> Betreff: Re: [PATCH] S2API: add multifrontend
> 
>> Darron Broad wrote:
>>> In message <48F0B6C5.5090505@linuxtv.org>, Steven Toth wrote:
>>>
>>> hello
>>>
>>> <snip>
>>>
>>>> I have an OOPS loading the cx23885 driver, I'm fixing now. Carry on
>> with 
>>>> your stuff and I'll add this fix to the entire patchset as a
>> supplemental.
>>>> Just FYI
>>> okay Steve.
>>>
>>> I have created two new repos:
>>>
>>> http://hg.kewl.org/s2-mfe-new/
>>> and
>>> http://hg.kewl.org/s2-mfe-new-dev/
>>>
>>> the former is as http://hg.kewl.org/s2-mfe/ without any FM radio
>>> support but some preliminary setup which has no great impact.
>>>
>>> the later is where i will fix the radio as best can be done
>>> by mid-week. hopefully the MEX will be understood by then
>>> and any bad code in tvaudio sorted out (it needs evaluation).
>>>
>>> currently s2-mfe-new-dev is exactly the same as s2-mfe on
>>> hg.kewl.org with the exception of one additional comment so
>>> I don't see any omissions.
>>>
>>> Hopefully i have commited the MFE patches in new in a correct
>>> fashion. You are free to do as you will with it and I will
>>> not change anything in this repo.
>>>
>>> I have to go now for some time, but will return later. I 
>>> hope all is going well.
>> OK, I've made some changes and cleanup patches for various things. This 
>> fixes the cx23885 tree for MFE, it's working now.
>>
>> Also a massive checkpatch compliance changes for various drivers, 
>> including the cx24116.
>>
>> (checkpatch is automatically run durin Mauro's import and highlights 
>> kernel coding violations).
>>
>> I need you all to pull this tree and re-run your tests. We need to 
>> re-verify that everything works as expected.... I doubt anything ot 
>> broken, but it has been a lot of cleanup).
>>
>> As always, http://linuxtv.org/hg/~stoth/s2-mfe
>>
>> Regards,
>>
>> Steve
> 
> Hi guys,
> 
> thank you Steve and Darron for your work on the repositories today!
> 
> I have pulled the latest s2-mfe and retested with the HVR4000 on DVB-T, 
> DVB-S, DVB-S2 and analogue TV. 
> 
> No problems so far.

I'm mutating the subject thread, and cc'ing the public mailing list into 
this conversion. Now is the time to announce the intension to merge 
multi-frontend patches, and show that we have tested and are satisfied 
with it's reliability across many trees.

(For those of you not familiar with the patch set, it adds 
'multiple-frontends to a single transport bus' support for the HVR3000 
and HVR4000, and potentially another 7134 based design (the 6 way medion 
board?).

For my part, I was asked to test the cx23885 changes and I responded to 
that with a series of patches to fix some OOPS initialisation errors. 
The MFE patches work correctly with the cx23885 tree now.

Over time I've heard constant suggestions that the patches are ready for 
merge, the cx88 and saa7134 trees are working correctly. Now is the time 
that I need you all to announce this. I need you each in turn to 
describe you testing, and state whether you think the patches are ready 
for merge.

Hans Werner <HWerner4@gmx.de>
darron@kewl.org
scarfoglio@arpacoop.it
fabbione@fabbione.net

If you're not normally members of this list then please say so, I'll 
ensure your response is cc'd back to the list.

Thanks,

Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
