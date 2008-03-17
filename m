Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+1cd71b2b73eff9a3aa1a+1667+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JbGln-00057U-BQ
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 15:56:59 +0100
Date: Mon, 17 Mar 2008 11:56:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
Message-ID: <20080317115607.2b9984c9@gaivota>
In-Reply-To: <47DC4C77.2020201@h-i-s.nl>
References: <1203538678.8313.12.camel@srv-roden.vogelwikke.nl>
	<47BCAC32.9050601@h-i-s.nl> <47BCB371.2020809@h-i-s.nl>
	<20080227075056.34a80abd@areia> <47D462DD.5080500@h-i-s.nl>
	<20080312180321.6a6800a1@gaivota> <47DAED1E.4030002@h-i-s.nl>
	<20080315112427.6b6c55a4@gaivota> <47DC4C77.2020201@h-i-s.nl>
Mime-Version: 1.0
Cc: Barnaby Shearer <Barnaby@EchelonL.com>, bWare <bWare@iWare.co.uk>,
	H Me <ugm6hr@hotmail.com>, linux-dvb@linuxtv.org,
	Stephan Zorn <szorn@gmx.at>, Thomas Munro <munro@ip9.org>,
	Stuart Langridge <sil@kryogenix.org>, tiwag <tiwag@gmx.at>,
	stefan@hlustik.net, tiwag <tiwag.cb@gmail.com>,
	david@reynoldsfamily.org.uk, achasper@gmail.com,
	stealth banana <stealth.banana@gmail.com>
Subject: Re: [linux-dvb] First patch for Freecom DVB-T (with RTL2831U,
	usb id 14aa:0160)
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

On Sat, 15 Mar 2008 23:23:51 +0100
Jan Hoogenraad <jan-conceptronic@h-i-s.nl> wrote:

> > Due to several issues I've noticed at the driver, I opted, for now, to add it
> > as a separate tree. This way, we can fix things there, without affecting the
> > staging tree. I've made it available at:
> > 	http://linuxtv.org/hg/~mchehab/rtl2831
> Thanks a lot. This way, the people involved have a place to focus on.
> Now, I need to find a way to synchronise my tree with this directory.
> I'll do some reading on the mercurial.

Kdiff3 has a very nice algorithm to see the differences on a code with
different CodingStyles. Anyway, this could be a pain.

> I have some scripts to convert things I receive from Realtek.
> I'll add the new directory names and Lindent at least.

> > Also, I noticed that nobody, on RealTek signed it. It would be interesting if
> > someone there could send us a SOB for the first changeset:
> > 	http://linuxtv.org/hg/~mchehab/rtl2831/rev/bb7749446173
> Please explain the abbrreviation SOB, and if possible send the text.

SOB - Signed-off-by:

It should be useful for you to take a look on README.patches [1].

[1] http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches

> Would you like to have a paper copy, or is e-mail confirmation to you 
> sufficient ?
Just an e-mail with their SOBs.

> The text I added in the header is vetted by people from Realtek.

They can change the text. The only requirement is that the code should be
licensed with GPLv2.

> They are eager to work together, and willing to learn.

This is very good! With time we will learn how to cope together.

> Unfortunately, I myself am completely new to linux development.

It shouldn't take much time to learn ;) It is a completely different
environment than what you'll have inside a company, since it is a
community-driven work. So, all members of the community are freed to cope,
comment and help with your work, sending you newer patches. Also, since kernel
internal API's change, we need to handle patches that will change the API,
testing they.

> I'll add those specific cases to my import script;
> I think that script should (due to the nature of the driver) get a 
> central role, as to keep updates automated.

Yes, this seems to be the easiest way.

> > 3) Name convention. Names are generally in lower case. Since we try to have all
> > lines with maxsize=80, the better is trying to have shorter names. 
> > 
> > I don't think that it would be a good idea to replace all names inside the driver,
> > since this will make your life harder, when receiving patches from Realtek.
> > Anyway, please consider this if you need to touch on some var name. 
> > 
> > There are other comments I want to do, about the integration with the tree. I
> > intend to do it later, after having a better understanding on how the driver
> > works and what can be done to avoid code duplication with dvb core and to allow
> > the usage of the tuners by other drivers.
> Some of us have studied this already, and communicated with Realtek on 
> this, For example, they have an improved handling of the mt2060 tuner.
> Decoupling the front end, setting this temporatily up as a new driver 
> (would the naming there be something like mt2060_for_rtl2831 ?) and then 
> integration have been on our wish list already.

We did this kind of things already (for example, with saa711x). While this is
not the ideal way, we can handle this. 

I suspect, however, that it is too late to merge the driver for 2.6.26 (the
window for newer drivers should be opening soon, and the driver reviewing
should happen before the opening of the windows). Considering this, we'll have
a timeframe of about 8-10 weeks before the next merge window (for 2.6.27).
Maybe this timeframe is enough to merge the required newer features on mt2060
and reuse it, instead of adding a newer one. My suggestion is to work with the
separate tree and see the progress.

> > Also, I'll need help from other developers on this large task ;)
> I at least have a lot of people interested already for testing.
> I've cc-ed them.

Great. There are also the other guys from DVB ML that could also help on this.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
