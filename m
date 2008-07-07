Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bangui.magic.fr ([195.154.194.245])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <aconrad.tlv@magic.fr>) id 1KFmhj-0003gw-Oz
	for linux-dvb@linuxtv.org; Mon, 07 Jul 2008 11:08:16 +0200
Received: from [127.0.0.1] (ppp-76.net11.magic.fr [195.154.129.76])
	by bangui.magic.fr (8.13.1/8.13.1) with ESMTP id m679889H012325
	for <linux-dvb@linuxtv.org>; Mon, 7 Jul 2008 11:08:09 +0200
Message-ID: <4871DCFA.7010202@magic.fr>
Date: Mon, 07 Jul 2008 11:08:10 +0200
From: Alexandre Conrad <aconrad.tlv@magic.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <485F8A72.5010305@magic.fr> <485FB15F.8050000@magic.fr>
	<485FEB01.60809@magic.fr> <200807060354.53328@orion.escape-edv.de>
In-Reply-To: <200807060354.53328@orion.escape-edv.de>
Subject: Re: [linux-dvb] S-1401: low signal (szap)
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

Hi,

Oliver Endriss wrote:
> Alexandre Conrad wrote:
>>>>I just recieved a new DVB card TT S-1401 as remplacement for the 
>>>>Skystar2 2.8A which no longer works under linux.
>>>>
>>>>As I was afraid of, I have a low signal strength when I use szap. What 
>>>>could be the cause and what's the fix if there's one?
>>>
>>>Let me add that the usual signal strenght I get is around "e246" with 
>>>the TT S-1500 and I'm getting around "8585" with the TT S-1401.
>>
>>Any clues anyone? I haven't found any obvious ressources anywhere...
> 
> Do you have any reception problems?

Well, I haven't had much problem. As I'm only doing DVB-ip reception (no 
TV) I think it's been ok for now. Although, I'm worried to see signal 
strenght problems.

> Please note that you must not compare signal strength values from
> different tuner types. The values reported are very inaccurate.

Is there any accurate way of seeing what's the signal strenght? I'm 
asking this because we're installing these cards on multiple 
set-top-boxes around the country. And having the signal strenght value 
would be a very good point for us as we could easely report the value 
and check if all is good with the antenna's installation.

If the signal varies between tuners, maybe is there some kind of table 
referencing, per card, what is a good signal?

Thanks for the info!

Regards,
-- 
Alexandre CONRAD


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
