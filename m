Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.246])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1KZ1W3-0001ro-QL
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 12:47:45 +0200
Received: by an-out-0708.google.com with SMTP id c18so127287anc.125
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 03:47:39 -0700 (PDT)
Message-ID: <bb72339d0808290347l7732b608idaabad895c2488d7@mail.gmail.com>
Date: Fri, 29 Aug 2008 20:47:39 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: "Wieslaw Kierbedz" <w.kier@farba.eu.org>
In-Reply-To: <48B7AB83.90802@farba.eu.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B59989.4080004@interia.pl>
	<bb72339d0808282125g59a24920o6af8b41ccfa1f15c@mail.gmail.com>
	<48B7AB83.90802@farba.eu.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7162. Aver saa7135 cards. User stupid questions.
	More or less.
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

2008/8/29 Wieslaw Kierbedz <w.kier@farba.eu.org>:
> Owen Townend nagli:
>>
>> 2008/8/28  <mincho@interia.pl>:
>>
>>>
>>> Hi.
>>> saa7162
>>> Maybe thats really stupid question, but I greped and googled very
>>> intensive and I am not sure.
>>> What is recent status of saa7162 driver?
>>> Am I wrong - work is frozen due to missing specs?
>>> So should I assume - that schmeltz will not work under linux for long
>>> time more?
>>>
>>> Aver DVB-T Hybrid+FM PCI A16D.
>>> I found (on wiki page), that this card is poor supported.
>>> But I did not found 777 A16A-C at all.
>>> I have A16A-C and it works excellent.
>>> What is recent status for Hybrid+FM PCI A16D?
>>>
>>> Regards
>>> --
>>> Wieslaw Kirbedz
>>>
>>
>> Hey,
>>  The wiki page for the AVerMedia DVB-T Hybrid+FM PCI (A16D) shows that
>> the card is actually well supported using the linuxtv repository. I
>> wrote/updated much of the A16D wiki section as I own one of these.
>>  Both digital and analogue work well (except for analogue audio under
>> Ubuntu - saa7134-alsa issues)
>>  I haven't yet tried to use the remote but there was a post earlier by
>> someone who is working on getting it mapped.
>>
>>  If you have a new type of card that is working could you please
>> create a page for it in the wiki, add as much info as you can and add
>> it to the table here[1].
>>
>> cheers,
>> Owen.
>>
>>
>
> I have got Aver DVB-T 777 A16A-C which is not present in
> http://www.linuxtv.org/wiki/index.php/DVB-T_PCI_Cards#AVerMedia table.
> I am not sure. Maybe it would be enough to add its designation  to A16AR?
> It  is autodetected as card=85, simply Aver 777.
> Works perfectly.
> If you think it should have separate record I can do that.
>
> P.S. Does anybody knows something about my first question?
>
> --
> WK
>

Hey,
 If it's detecting and working as the 777 A16AR then it would make
sense to add it to the existing page, similar to the A16AR/A16D
Hybrid+FM Page.
 As to the first question, the 7162 development seemed to be still
progressing as of last month:
 http://article.gmane.org/gmane.linux.drivers.dvb/43048

cheers,
Owen.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
