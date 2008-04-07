Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jifoc-0006Sf-0m
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 03:06:31 +0200
Message-ID: <47F97374.80902@iki.fi>
Date: Mon, 07 Apr 2008 04:05:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linuxcbon <linuxcbon@yahoo.fr>
References: <778001.81401.qm@web26115.mail.ukl.yahoo.com>
In-Reply-To: <778001.81401.qm@web26115.mail.ukl.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] RE : Re:  Which DVB-T USB tuner  on linux ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

linuxcbon wrote:
> Thanks for your answer Antti,
> =

> ARTEC T14BR =

> Chip DiB0700
> Is the firmware downloaded automaticaly by the kernel ?

It is loaded automatically as it is done always. There is no drivers =

that needs firmware loaded manually. Everyone driver will load firmware =

automatically.
But if you mean that if firmware is coming from kernel - answer is =

almost 100% no. Firmware is almost always needed to install manually =

from somewhere on the net or from via package manager depending on your =

distribution. Installing firmware is not big issue and it is needed only =

once. Installing drivers from source is more work...

> Does the remote work with it too ?

No idea :)

> AVERMEDIA AVERTV DVB-T VOLAR X
> Chip DiB0700
> Seems the same as above, I dont know for the remote.
> =

> PINNACLE PCTV DVB-T STICK
> There are different models (eMPIA, DiB7070PB, Pinnacle...)
> I leave it, I dont want to take the risk to buy the wrong product.
> =

> There is also the PINNACLE PCTV DVB-T STICK ULTIMATE
> Chip empiatech  ? It seems good.

Maybe good, but will need also compiling drivers from source.

> Which chip has best reception ?

Thats not easy to say because it depends so many things.

> BR, linuxcbon

I haven't looked kernel sources but I have feeling that Artec T14BR =

could be in the recent kernel. So my opinion as that take Artec and =

probably you don't need to compile drivers from source.

/antti

> =

> --- Antti Palosaari <crope@iki.fi> a =E9crit :
> =

>> linuxcbon wrote:
>>> Hi all,
>>>
>>> I am planning to buy a DVB-T USB tuner but I am a little lost :-(.
>>> I am interested in following products :
>>> ARTEC T14BR
>> works
>>
>>> AVERMEDIA AVERTV DVB-T VOLAR X
>> no idea
>>
>>> PINNACLE PCTV DVB-T STICK
>> there is many PCTV versions, most are working. You should look if it is =

>> e71, e72, e73 etc. I think mentioned ones are working.
>>
>>> I dont know if they work OK on linux.
>> Some of those works with recent kernels, others needs compiling drivers =

>> from v4l-dvb-master or -devel trees.
>>
>>> Which tuner would you recomment for linux ?
>>>
>>> Thanks and BR, linuxcbon
>> regards
>> Antti
>> -- =

>> http://palosaari.fi/
> =

> =

> =

> =

> =

> =

>      =

> _________________________________________________________________________=
____
> =

> Envoyez avec Yahoo! Mail. Une boite mail plus intelligente http://mail.ya=
hoo.fr
> =

> =

>       ___________________________________________________________________=
__________ =

> Envoyez avec Yahoo! Mail. Une boite mail plus intelligente http://mail.ya=
hoo.fr
> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- =

http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
