Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1019.yellis.net ([213.246.41.159] helo=vds19s01.yellis.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1K6mpP-0007yL-JE
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 15:27:00 +0200
Message-ID: <48512411.6000900@anevia.com>
Date: Thu, 12 Jun 2008 15:26:41 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: Vladimir Prudnikov <vpr@krastelcom.ru>
References: <20B2C1F8-9DFE-43C1-BACD-22DC74AE9136@krastelcom.ru>	<485100C3.2090908@sttcr.org>
	<B582543D-F8CE-48ED-81B9-18665F49EEB6@krastelcom.ru>
In-Reply-To: <B582543D-F8CE-48ED-81B9-18665F49EEB6@krastelcom.ru>
Cc: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Smit CAM problems
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

Did you try to contact SMIT support ?

Vladimir Prudnikov a =E9crit :
> Didn't try Aston CAMs with mpeg4. But they do up to 12 channels of  =

> mpeg2 perfectly well. With no problems at all. SMiTs that are for 8  =

> services can do only 3 to 4 for me.
> I think it's some kind of a driver bug because it begins working after  =

> reinitialisation. Doesn't get hot. I have tried to call Aston as well  =

> but with no success yet.
> =

> Regards,
> Vladimir
> =

> On Jun 12, 2008, at 2:56 PM, dan.lita@sttcr.org wrote:
> =

>> Dear Vladimir,
>>
>> I read your post on linux-dvb list. We have an Aston Viaccess  =

>> Professional 2.15 CAM .
>> I read that you also use Aston CAMS.  My question is whether your  =

>> Aston Viaccess cam can descramble H264  feeds or not?
>> We have tried on a PACE HDTV receiver and a Tandberg unit and it  =

>> does not descramble the H264 video pid. (black screen)
>> This does not happen with Viaccess RED cam.
>>
>> On older Common interface adapters from Technotrend, the one for TT  =

>> Premium DVB-S card, there was a jumper for 3V or 5V cam operation.
>> I assume the new CI adapter does not have such jumper. If it still  =

>> exist maybe it will be a good idea to switch from one voltage to the  =

>> other.
>> Another solution is to test whether it works or not for Irdeto to  =

>> use an Alphacrypt Classic CAM which, at least in theory, according  =

>> to MASCOM, supports Irdeto.
>> The third thing is to notice whether the SMIT cam gets hot in  =

>> operation. If it gets too hot maybe a fan similar to the one for  =

>> graphics card must be put near the Common interface adapter.
>>
>> BTW. Do you have any e-mail address from Aston? I have tried to  =

>> contact  them but there is no e-mail address in their website.
>>
>> Best regards,
>> Dan Lita
>>
>>
>> Vladimir Prudnikov wrote:
>>> Hello!
>>>
>>> I'm using SMIT cams to descramble channels on TT S-1500 and TT-  =

>>> S2-3200. After some time of normal operation SMIT cams drop out  =

>>> and  stop decrypting the stream. It needs to be removed from the CI  =

>>> slot  and reinserted to resume normal operation. Aston CAMs have no  =

>>> such  problems, but they don't support 0x652 Irdeto.
>>> I'm streaming with vlc. Tried many SMITs (Viaccess and Irdeto).  =

>>> Same  problem everywhere.
>>>
>>> Regards,
>>> Vladimir
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>>
>>>
> =

> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> =



-- =

CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
