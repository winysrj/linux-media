Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KgZkV-0000vw-KB
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 08:45:53 +0200
Received: by yw-out-2324.google.com with SMTP id 3so49035ywj.41
	for <linux-dvb@linuxtv.org>; Thu, 18 Sep 2008 23:45:47 -0700 (PDT)
Message-ID: <d9def9db0809182345n45ac0fdck6165e0f4d3b48b0b@mail.gmail.com>
Date: Fri, 19 Sep 2008 08:45:46 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Patrick Boettcher" <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0809190830370.8673@pub1.ifh.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <alpine.LRH.1.10.0809190830370.8673@pub1.ifh.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [RFC] cinergyT2 rework final review
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

On Fri, Sep 19, 2008 at 8:35 AM, Patrick Boettcher
<patrick.boettcher@desy.de> wrote:
> Hi Thierry,
>
> On Fri, 19 Sep 2008, Thierry Merle wrote:
>
>> Hello all,
>> About the rework from Tomi Orava I stored here:
>> http://linuxtv.org/hg/~tmerle/cinergyT2
>>
>> since there seems to be no bug declared with this driver by testers (I
>> tested this driver on AMD/Intel/ARM platforms for months), it is time for
>> action.
>> If I receive no problem report before 19th of October (in one month), I
>> will push this driver into mainline.
>
> Are you really sure you want to wait until October 19 with that? You heard
> Jonathan this morning, he is expecting a new release every day now, so the
> merge window will start quite soon. Maybe it would be better to shorten
> your deadline in favour of having the driver in-tree for 2.6.28. When it
> is inside it is still possible for at least 1.5 months to fix occuring
> problems.
>
>> This modification uses the dvb-usb framework, this is
>>
>> To give you an idea of the code benefit, here is a diffstat of the
>> cinergyT2 rework patch:
>> linux/drivers/media/dvb/cinergyT2/Kconfig        |   85 -
>> linux/drivers/media/dvb/cinergyT2/Makefile       |    3
>> linux/drivers/media/dvb/cinergyT2/cinergyT2.c    | 1150
>> ---------------------
>> linux/drivers/media/dvb/dvb-usb/cinergyT2-core.c |  230 ++++
>> linux/drivers/media/dvb/dvb-usb/cinergyT2-fe.c   |  351 ++++++
>> linux/drivers/media/dvb/dvb-usb/cinergyT2.h      |   95 +
>> linux/drivers/media/dvb/Kconfig                    |    1
>> linux/drivers/media/dvb/dvb-usb/Kconfig            |    8
>> linux/drivers/media/dvb/dvb-usb/Makefile           |    4
>> 9 files changed, 688 insertions(+), 1239 deletions(-)
>
> Impressive. It means there are currently around 600 lines boilerplate code
> in the cinergyT2-driver (I like this word ;) )
>

there was an intention to redesign the dvb framework (make a v3) with
that driver so it duplicated
alot code from the core.

Markus

> Patrick.
>
> --
>   Mail: patrick.boettcher@desy.de
>   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
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
