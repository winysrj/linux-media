Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.175])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <glemsom@gmail.com>) id 1LHfdi-00063N-GL
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 15:32:11 +0100
Received: by ug-out-1314.google.com with SMTP id x30so1042809ugc.16
	for <linux-dvb@linuxtv.org>; Tue, 30 Dec 2008 06:32:06 -0800 (PST)
Message-ID: <d65b1b150812300632u7f66c092le77e66acf888c691@mail.gmail.com>
Date: Tue, 30 Dec 2008 15:32:05 +0100
From: "Glenn Sommer" <glemsom@gmail.com>
To: "Ernst Persson" <ernstp@gmail.com>
In-Reply-To: <8e2e399f0812202343o2b88ab1ap4c92d0e99dd90af0@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <d65b1b150812170433j717c673ak4489cdbbc10c29a3@mail.gmail.com>
	<8e2e399f0812202343o2b88ab1ap4c92d0e99dd90af0@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT c-1501 getting timed out waiting for end of xfer
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

I just tested with kernel 2.6.28 and latest snapshot of v4l-dvb.
And I still get those timeouts!

The card seems to run fine though.
Occasionally I have problems locking on to channels... Though - I
don't think that's related to the drivers (I think it's a CAM issue).


2008/12/21 Ernst Persson <ernstp@gmail.com>:
> Hi,
> I'm thinking about buying one of those cards.
> Have you found any solution?
> Is it a problem?
> Does the card work fine otherwise?
>
> regards
> /Ernst
>
> On Wed, Dec 17, 2008 at 13:33, Glenn Sommer <glemsom@gmail.com> wrote:
>>
>> I'm using a TT c-1501 card on a asrock p43twin1600 mainbaord.
>>
>> I keep getting these messages: "saa7146 (0) saa7146_i2c_writeout
>> [irq]: timed out waiting for end of xfer"
>> As far as I can see it happens often during tuning to channels.
>>
>> Google tells me other people have seen this - but I'm unable to find a
>> solution... And I cannot quite figure out why it happens?
>>
>> (I've tried the latest snapshot of v4l-dvb.)
>>
>>
>> Regards
>> Glenn Sommer
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
