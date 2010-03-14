Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:48758 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0CNRpz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 13:45:55 -0400
Received: from kabelnet-193-38.juropnet.hu ([91.147.193.38])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NqrsT-0004qF-Kv
	for linux-media@vger.kernel.org; Sun, 14 Mar 2010 18:45:52 +0100
Message-ID: <4B9D21F3.8090902@mailbox.hu>
Date: Sun, 14 Mar 2010 18:50:43 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu>	 <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu>	 <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu>	 <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu>	 <4B7C303B.2040807@mailbox.hu> <4B7C80F5.5060405@redhat.com> <829197381002171559k10b692dcu99a3adc2f613437f@mail.gmail.com> <4B7C84F3.4080708@redhat.com>
In-Reply-To: <4B7C84F3.4080708@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, so should I write a new xc4000.c/h from scratch and sign that off ?

On 02/18/2010 01:08 AM, Mauro Carvalho Chehab wrote:

> Devin Heitmueller wrote:
>> On Wed, Feb 17, 2010 at 6:51 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Hi Istvan,
>>>
>>> istvan_v@mailbox.hu wrote:
>>>> The attached new patches contain all the previous changes merged, and
>>>> are against the latest v4l-dvb revision.
>>> Please provide your Signed-off-by. This is a basic requirement for your
>>> driver to be accepted. Please read:
>>>        http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches
>>>
>>> for instructions on how to submit a patch.
>>
>> Hi Mauro,
>>
>> I would hate to come across as a jerk here, but he cannot provide his
>> SOB for this patch, as I wrote about 95% of the code here.  It's
>> derived from a tree I have been working on for the PCTV 340e:
>>
>> http://kernellabs.com/hg/~dheitmueller/pctv-340e-2/
>>
>> I know that istvan wants to see the support merged, but he is going to
>> have to wait a bit longer since he is not the author or maintainer of
>> the driver in question.
> 
> OK. Then, I need your SOB for the 95% of the code, and his SOB for the
> remaining ;)
