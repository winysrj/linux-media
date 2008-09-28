Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Sun, 28 Sep 2008 02:30:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Paul Chubb <paulc@singlespoon.org.au>
Message-ID: <20080928023041.41de802f@mchehab.chehab.org>
In-Reply-To: <48D6C0BA.4090605@singlespoon.org.au>
References: <20080915213106.A786B164293@ws1-4.us4.outblaze.com>
	<48D6C0BA.4090605@singlespoon.org.au>
Mime-Version: 1.0
Cc: linux dvb <linux-dvb@linuxtv.org>, stev391@email.com
Subject: Re: [linux-dvb] xc3028 config issue. Re: Why I need to choose
 better Subject: headers [was: Re: Why (etc.)]
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

On Mon, 22 Sep 2008 07:46:34 +1000
Paul Chubb <paulc@singlespoon.org.au> wrote:

> Hi,
>        I have integrated all the advice give with some success. 
> Australia has five companies who transmit each having a number of 
> channels. I am finding that using scan, tzap and mplayer I can always 
> view all southern cross ten channels however HD is without sound. I can 
> view all SBS channels.
> 
> I have been playing with the offset Mauro suggested in generid_set_freq. 

Ok. I'm assuming that the patch were correct, so I'm applying it.

> 2) in xc2028_set_params in tuner_xc2028.c it adds 200khz to demod

This is needed by design on xc2028/3028. Hmm... xc3028XL has some differences
here, at the firmware... Maybe you have those newer tuners. If so, you'll need
firmware v3.6, instead of v2.7.

> 3) in generic_set_freq in the same file it has a -500khz offset which I 
> was playing with

This is something specific for Australia, based on some tests from one DVB
developer that used to live there.


Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
