Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1Kc1GI-0008TF-5k
	for linux-dvb@linuxtv.org; Sat, 06 Sep 2008 19:07:51 +0200
Date: Sat, 6 Sep 2008 19:07:12 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Martin Dauskardt <martin.dauskardt@gmx.de>
In-Reply-To: <alpine.LRH.1.10.0809011646570.3828@pub6.ifh.de>
Message-ID: <alpine.LRH.1.10.0809061905510.6645@pub5.ifh.de>
References: <200808241510.48819@orion.escape-edv.de>
	<200809011337.39753.martin.dauskardt@gmx.de>
	<alpine.LRH.1.10.0809011646570.3828@pub6.ifh.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Cablestar DVB-C (Flexcop + stv0297) broken since
 changeset 7fb12d754061 (7469)
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

Hi again,

I just pushed patch to my hg repository which fixes the s5h1420-support 
for other cards than the flexcop-based ones.

I will ask Mauro to pull right now.

Patrick.

On Mon, 1 Sep 2008, Patrick Boettcher wrote:

> On Mon, 1 Sep 2008, Martin Dauskardt wrote:
>> So we have broken support for at least three cards now. (Technotrend 2400 and
>> Hauppauge Noba-S-SE with s5h1420 frontend doesn`t work any longer ,too. See
>> http://linuxtv.org/pipermail/linux-dvb/2008-August/028249.html)
>>
>> In my opinion it is not acceptable to break support for three cards in the
>> v4l-dvb main tree to get one other card supported.
>>
>> I strongly request to revert the changeset until a working solution for all
>> cards has been tested.
>
> We need to separate the things:
>
> 1) breakage of stv0297-based cards
>
> This was a mistake - I'm still trying to see which atomic modification
> causes that.... Should be a 3-liner to fix it, but where...
>
> 2) s5h1420-based cards
>
> I modified it to support a new card - right. I published the patch and ask
> for owners of the NOVA-S SE to test it. After not receiving a comment from
> anyone Mauro agreed to integrate it and wait if it breaks for someone. I
> agree this is not the smoothest/nicest way, but what else could I have
> done to move forward?
>
> Blindly reverting now would push me back where I was 6 months ago :(. But
> I totally agree with this idea when someone of you NOVA-S SE owners gives
> me a hand in order to test a possibly fixed patch. ;)
>
> Patrick.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
