Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n28.bullet.mail.ukl.yahoo.com ([87.248.110.145])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JZQ8A-0003KH-Jc
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 13:32:32 +0100
Date: Wed, 12 Mar 2008 07:47:53 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <000f01c8842b$a899efe0$f9cdcfa0$@com>
	<abf3e5070803120331h5f31e5c2nf3d1b6493b6f98ab@mail.gmail.com>
	<001a01c8842c$dfcb28c0$9f617a40$@com>
In-Reply-To: <001a01c8842c$dfcb28c0$9f617a40$@com> (from ben@bbackx.com on
	Wed Mar 12 06:36:04 2008)
Message-Id: <1205322473l.5684l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  Implementing support for multi-channel
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

On 03/12/2008 06:36:04 AM, Ben Backx wrote:
> 
> 
> > -----Original Message-----
> > From: Jarryd Beck [mailto:jarro.2783@gmail.com]
> > Sent: 12 March 2008 11:32
> > To: Ben Backx
> > Cc: linux-dvb@linuxtv.org
> > Subject: Re: [linux-dvb] Implementing support for multi-channel
> > 
> > 2008/3/12 Ben Backx <ben@bbackx.com>:
> > >
> > >
> > >
> > > Hello,
> > >
> > > I was wondering if there's some info to find on how to implement
> (and
> > test)
> > > multi-channel receiving?
> > >
> > > It's possible, because dvb uses streams and the driver is
> currently
> > capable
> > > to filter one channel, but how can I implement the support of
> multi-
> > channel
> > > filtering?
> > >
> > > Is there perhaps an open-source driver supporting this that I can
> > have a
> > > look at?
> > >
> > 
> > AFAIK tuners can already receive from multiple channels as long as
> they
> > are on the same transponder (I think that's the right word). So in
> > Australia
> > you can receive channel 7 and the channel 7 guide because they are
> > broadcast together. But I don't think you can do anymore than that.
> > 
> > I think mythtv is capable of doing it so you could have a look at
> that.
> > 
> > Jarryd.
> 
> 
> The tuner-part is no problem indeed (as you said: as long as the
> channels
> are on the same transponder).
> But for the moment: the driver-part is the problem, I don't think my
> driver
> supports the filtering of more than one channel at a time.
> So my question is: which (existing) driver does support multi-channel
> filtering? So I can have a look and see what modifications have to be
> made
> to my driver to implement multi-channel filtering.
> 

What is done for now is that some (all?) drivers can send the full 
stream and userspace apps do the demux of one or several channels 
themselves. Mythtv is doing just that, I guess vdr also.
HTH
Bye
Manu 





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
