Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dsl-202-173-134-75.nsw.westnet.com.au ([202.173.134.75]
	helo=mail.lemonrind.net) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex@receptiveit.com.au>) id 1Kk3qL-0002j3-Ro
	for linux-dvb@linuxtv.org; Sun, 28 Sep 2008 23:30:19 +0200
Message-Id: <03391629-289E-4635-B6D6-2E72E1C8206A@receptiveit.com.au>
From: Alex Ferrara <alex@receptiveit.com.au>
To: Alex Ferrara <alex@receptiveit.com.au>
In-Reply-To: <6894A2D0-2EC8-4C49-8D63-FA66CCA16E01@receptiveit.com.au>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Mon, 29 Sep 2008 07:29:37 +1000
References: <20080921104125.3218916429C@ws1-4.us4.outblaze.com>
	<6894A2D0-2EC8-4C49-8D63-FA66CCA16E01@receptiveit.com.au>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Dvico dual digital express - Poor tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0681570117=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0681570117==
Content-Type: multipart/alternative; boundary=Apple-Mail-40--482957906


--Apple-Mail-40--482957906
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit


On 26/09/2008, at 8:19 AM, Alex Ferrara wrote:

> On 21/09/2008, at 8:41 PM, stev391@email.com wrote:
>
>>> On Sun, Sep 21, 2008 at 3:35 PM, Alex Ferrara <alex@receptiveit.com.au 
>>> > wrote:
>>>> I am currently seeing inconsistent performance with the dvico dual
>>>> digital express. Some channels tune just fine, and others have the
>>>> impression of a very low signal strength.
>>>
>>> I have the same card in regional Australia, i had a similar problem
>>> problem, its working fine now though.
>>>
>>> One of my issue was that i had not scanned the channels properly,  
>>> did
>>> you generate your initial-tuning-data yourself and use scan to
>>> generate the channels.conf, or use somebody elses initial-tuning- 
>>> data
>>> ?
>>>
>>> It could be that the frequency in your channels.conf isnt accurate
>>> enough, from what ive experienced if you set the frequency in the
>>> channels.conf to be the center frequency of channel + 125kHz you
>>> should be ok.
>>>
>>> Also, there is an app called femon from dvb-apps package which will
>>> display the signal strength of the currently tunned channel, i just
>>> started that going and moved my indoor digital antenna around till i
>>> got max strength.
>>>
>>>
>>> Glenn
>>
>> Alex,
>>
>> Does this also happen in windows?
>> If so another possible solution is to either turn down your  
>> distribution amplifier or install attenuators on the RF input into  
>> the card.
>> In my mates setup I had to install a 12db attenuator inline to  
>> reduce the signal enough to within the cards dynamic range (An  
>> analogy of this is if you are at a rock concert next to the  
>> speakers it sounds sh!t due to the high volume however if you move  
>> away or muffle the sound slightly it will sound a lot better).
>> His older TV cards needed this higher strength signal to operate,  
>> if it didn't I would have just gotten rid of his distribution  
>> amplifier.
>>
>> I hope this helps.
>> (I have set up a total of 5 of these cards in linux so far and this  
>> has been the only issue with the current set of drivers. [Location  
>> is Melbourne]).
>>
>> Stephen.
>>
>>
>> -- 
>> Be Yourself @ mail.com!
>> Choose From 200+ Email Addresses
>> Get a Free Account at www.mail.com
>>
>
>
> I have had some time to test this fully. Using "dirty" Windows Vista  
> I am able to tune all channels with perfect quality. On the same  
> computer, with nothing changes except for the OS, I can tune most  
> channels and only watch some. I am using Mythbuntu 8.04.1 with the  
> current v4l-dvb mercurial drivers and the extracted firmware using  
> the perl script in the kernel documentation directory. Kernel is  
> 2.6.24 incidentally.
>
> There must be something going on in the driver or the firmware is  
> not quite right. One of my friends in Canberra also has one of these  
> dual express cards, and he is having very similar issues to me.
>
> I also tested a Dvico Dual Digital 4 PCI card, and found that it  
> worked perfectly. I believe mine is a v2 card, but I am not 100%  
> sure on that one.
>
> Regards
> Alex Ferrara
>
> Director
> Receptive IT Solutions
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


Does anyone have any ideas or similar experiences?

Regards
Alex Ferrara

Director
Receptive IT Solutions


--Apple-Mail-40--482957906
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><br><div><div>On 26/09/2008, at =
8:19 AM, Alex Ferrara wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><div =
style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><div><div><div>On 21/09/2008, =
at 8:41 PM, <a href=3D"mailto:stev391@email.com">stev391@email.com</a> =
wrote:</div><br class=3D"Apple-interchange-newline"><blockquote =
type=3D"cite"><div><blockquote type=3D"cite">On Sun, Sep 21, 2008 at =
3:35 PM, Alex Ferrara &lt;<a =
href=3D"mailto:alex@receptiveit.com.au">alex@receptiveit.com.au</a>> =
wrote:<br></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">I am currently seeing inconsistent performance with the =
dvico dual<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">digital express. Some channels =
tune just fine, and others have =
the<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">impression of a very low signal =
strength.<br></blockquote></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">I have the same =
card in regional Australia, i had a similar =
problem<br></blockquote><blockquote type=3D"cite">problem, its working =
fine now though.<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">One of my issue =
was that i had not scanned the channels properly, =
did<br></blockquote><blockquote type=3D"cite">you generate your =
initial-tuning-data yourself and use scan to<br></blockquote><blockquote =
type=3D"cite">generate the channels.conf, or use somebody elses =
initial-tuning-data<br></blockquote><blockquote =
type=3D"cite">?<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">It could be =
that the frequency in your channels.conf isnt =
accurate<br></blockquote><blockquote type=3D"cite">enough, from what ive =
experienced if you set the frequency in the<br></blockquote><blockquote =
type=3D"cite">channels.conf to be the center frequency of channel + =
125kHz you<br></blockquote><blockquote type=3D"cite">should be =
ok.<br></blockquote><blockquote type=3D"cite"><br></blockquote><blockquote=
 type=3D"cite">Also, there is an app called femon from dvb-apps package =
which will<br></blockquote><blockquote type=3D"cite">display the signal =
strength of the currently tunned channel, i =
just<br></blockquote><blockquote type=3D"cite">started that going and =
moved my indoor digital antenna around till =
i<br></blockquote><blockquote type=3D"cite">got max =
strength.<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">Glenn<br></blockquote><br>Alex,<br><br>Does this also =
happen in windows?<br>If so another possible solution is to either turn =
down your distribution amplifier or install attenuators on the RF input =
into the card. <br>In my mates setup I had to install a 12db attenuator =
inline to reduce the signal enough to within the cards dynamic range (An =
analogy of this is if you are at a rock concert next to the speakers it =
sounds sh!t due to the high volume however if you move away or muffle =
the sound slightly it will sound a lot better).<br>His older TV cards =
needed this higher strength signal to operate, if it didn't I would have =
just gotten rid of his distribution amplifier.<br><br>I hope this =
helps.<br>(I have set up a total of 5 of these cards in linux so far and =
this has been the only issue with the current set of drivers. [Location =
is Melbourne]).<br><br>Stephen.<br><br><br>-- <br>Be Yourself @ =
mail.com!<br>Choose =46rom 200+ Email Addresses<br>Get a Free Account at =
<a =
href=3D"http://www.mail.com">www.mail.com</a><br><br></div></blockquote></=
div><div><br></div>I have had some time to test this fully. Using =
"dirty" Windows Vista I am able to tune all channels with perfect =
quality. On the same computer, with nothing changes except for the OS, I =
can tune most channels and only watch some. I am using Mythbuntu 8.04.1 =
with the current v4l-dvb mercurial drivers and the extracted firmware =
using the perl script in the kernel documentation directory. Kernel is =
2.6.24 incidentally.</div><div><br></div><div>There must be something =
going on in the driver or the firmware is not quite right. One of my =
friends in Canberra also has one of these dual express cards, and he is =
having very similar issues to me.</div><div><br></div><div>I also tested =
a Dvico Dual Digital 4 PCI card, and found that it worked perfectly. I =
believe mine is a v2 card, but I am not 100% sure on that =
one.</div><div><br></div><div><div> <span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0; "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; "><div>Regards</div><div>Alex =
Ferrara</div><div><br></div><div>Director</div><div>Receptive IT =
Solutions</div></div></span> =
</div><br></div></div>_______________________________________________<br>l=
inux-dvb mailing list<br><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://=
www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></blockquote></div><=
div><br></div>Does anyone have any ideas or similar =
experiences?<div><br><div> <span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0; "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; "><div>Regards</div><div>Alex =
Ferrara</div><div><br></div><div>Director</div><div>Receptive IT =
Solutions</div></div></span> </div><br></div></body></html>=

--Apple-Mail-40--482957906--


--===============0681570117==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0681570117==--
