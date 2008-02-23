Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from edu.joroinen.fi ([194.89.68.130] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pasik@iki.fi>) id 1JSvse-0005uj-CC
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 16:01:36 +0100
Date: Sat, 23 Feb 2008 17:01:26 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Igor <goga777@bk.ru>
Message-ID: <20080223150126.GH21162@edu.joroinen.fi>
References: <2f8cbffc0802230359w2922f888s90ac43fcb68ad406@mail.gmail.com>
	<E1JStMf-000HLd-00.goga777-bk-ru@f142.mail.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E1JStMf-000HLd-00.goga777-bk-ru@f142.mail.ru>
Cc: Ian Bonham <ian.bonham@gmail.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR4000 Update?
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

On Sat, Feb 23, 2008 at 03:20:25PM +0300, Igor wrote:
> you have only two possibilities now
> 
> the latest multiproto from Manu Abrahamlinux-dvb@linuxtv.org
> http://jusst.de/hg/multiproto/
> +
> multiproto-hvr4k-2008-01-28.patch from  Holger Steinhaus
> http://linuxtv.org/pipermail/vdr/2008-January/015348.html
> 
> Or you can use Hauppauge diffs for v4l-dvb hg repository
> from http://dev.kewl.org/hauppauge/Hauppauge from Darron Broad
> 
> 
> Igor
> 

Hmm.. I haven't been following the multiproto discussion very closely, so
could someone give an update on it.. 

- Why it is not (yet) merged with the default/kernel dvb drivers? 
- What needs to be done to get it merged? Who's working on it?
- What's preventing the merge? 

Thanks!

-- Pasi

> 
> 
> 
> -----Original Message-----
> From: "Ian Bonham" <ian.bonham@gmail.com>
> To: linux-dvb@linuxtv.org
> Date: Sat, 23 Feb 2008 12:59:09 +0100
> Subject: [linux-dvb] HVR4000 Update?
> 
> > 
> > Hey All,
> > 
> > Well it still seems to me that the Multi-Proto mess is still impacting real
> > World use of cards such as the HVR4000. I'm currently using Ubuntu 7.10, and
> > have still not managed much from my HVR4k apart from the main DVB-S channels
> > on Astra 28.2e. I use Myth as my Media Server, and have no access to DVB-T
> > or DVB-S2 channels. I read there are patches to make this poss, but there is
> > such a muddle of info I am totally unsure what I should be doing to use the
> > features of the card properly.
> > 
> > Can anyone please make a clear guide on what I should do to get my HVR4k
> > going properly with Myth? If I can't get things going 'properly' just being
> > able to help beta stuff would be good. What SVN do I need to check-out? What
> > patches do I need to apply? What Myth do I need to check out? Then what
> > patches does that need?
> > 
> > Please guys, give us some pointers here so we can help with testing and
> > maybe help push this forwards. What distro is best for getting things
> > working? I'm on Ubuntu 7.10, but would SuSE better serve a solution? Fedora?
> > Which?!
> > 
> > Thanks,
> > 
> > Ian
> > 
> > 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
