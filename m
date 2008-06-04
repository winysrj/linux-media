Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1K3tb7-0002BM-PC
	for linux-dvb@linuxtv.org; Wed, 04 Jun 2008 16:04:19 +0200
Message-ID: <4846A0B3.5000202@linuxtv.org>
Date: Wed, 04 Jun 2008 10:03:31 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Sigmund Augdal <sigmund@snap.tv>
References: <1212535332.32385.29.camel@pascal>	
	<1212584764.32385.36.camel@pascal>	
	<37219a840806040639q737327c7r9cab46cfdd88eaae@mail.gmail.com>	
	<48469C7A.1070607@linuxtv.org> <1212587661.32385.47.camel@pascal>
In-Reply-To: <1212587661.32385.47.camel@pascal>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Re: Ooops in tda827x.c
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

Sigmund Augdal wrote:
> On Wed, 2008-06-04 at 09:45 -0400, Michael Krufky wrote:
>   
>> Michael Krufky wrote:
>>     
>>>> On Wed, 2008-06-04 at 01:22 +0200, Sigmund Augdal wrote:
>>>>         
>>>>> changeset 49ba58715fe0 (7393) introduces an ooops in tda827x.c in
>>>>> tda827xa_lna_gain. The initialization of the "msg" variable accesses
>>>>> priv->cfg before the NULL check causing an oops when it is in fact
>>>>> NULL.
>>>>>
>>>>> Best regards
>>>>>
>>>>> Sigmund Augdal
>>>>>           
>>> 2008/6/4 Sigmund Augdal <sigmund@snap.tv>:
>>>       
>>>> Attached patch fixes the problem.
>>>>
>>>> Best regards
>>>>
>>>> Sigmund Augdal
>>>>
>>>>         
>>> Sigmund,
>>>
>>> The driver was only able to get into this function without priv->cfg
>>> being defined, because m920x passes in NULL as cfg.
>>>
>>> In my opinion, this is flawed by design, and m920x should pass in an
>>> empty structure rather than a NULL pointer, but I understand why
>>> people might disagree with that.
>>>
>>> With that said, your patch looks good and I see that it fixes the
>>> issue. Please provide a sign-off so that your fix can be integrated
>>> and you will receive credit for your work.
>>>
>>> Use the form:
>>>
>>> Signed-off-by: Your Name <email@addre.ss>
>>>
>>>       
>> Sigmund,
>>
>> Looking at the C-1501 patch that you sent in, here is the cause of your OOPS.
>>
>> if (dvb_attach(tda827x_attach, budget_ci->budget.dvb_frontend, 0x61,
>> +				       &budget_ci->budget.i2c_adap, 0) == NULL)
>>
>> You are passing "0" to the config structure of tda827x_attach.  First off, "0" is an illegal value.  This should be a pointer to a "struct tda827x_config"
>>
>> ...Please take a look at the tda827x_attach calls in saa7134-dvb.c for a better idea on what belongs there.
>>     
> The documentation in tda827x.h says that this parameter is optional.
> Furthermore there are other drivers that don't use it  (as you allready
> mentioned), and ever further the module used to work without crashing
> before the above-mentioned changeset. I think that applying a two line
> patch to fix a regression is worthwhile compared to having a number of
> drivers allocate structures to hold no useful information. I do however
> agree that I should have used NULL rather than 0.

I agree with you as well -- I just wanted to state the facts so that
this thread makes sense to other readers.

As stated in my prior email, your tda287x fix should definitely be
merged after you send in your sign-off.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
