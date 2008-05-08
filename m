Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+17c1689894fd1245efac+1719+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1Ju8SD-0005fn-D7
	for linux-dvb@linuxtv.org; Thu, 08 May 2008 17:54:45 +0200
Date: Thu, 8 May 2008 12:54:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <20080508125409.5efd7762@gaivota>
In-Reply-To: <200805081500.17454.zzam@gentoo.org>
References: <200804301421.04598.zzam@gentoo.org>
	<200805070939.29694.zzam@gentoo.org>
	<20080507171342.3479dbc8@gaivota>
	<200805081500.17454.zzam@gentoo.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] mt312: Prefix functions only with mt312_,
 Add zl10313 to kconfig description
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

On Thu, 8 May 2008 15:00:16 +0200
Matthias Schwarzott <zzam@gentoo.org> wrote:

> On Wednesday 07 May 2008, you wrote:
> > Hi Mathias,
> >
> > On Wed, 7 May 2008 09:39:27 +0200
> >
> > Matthias Schwarzott <zzam@gentoo.org> wrote:
> > > On Mittwoch, 30. April 2008, Matthias Schwarzott wrote:
> > > > Hi list!
> > > >
> > > > This patch does some small cleanup to mt312.
> > > > It changes kconfig description to also list the ZL10313.
> > > >
> > > > It does change some strange symbol names to be consistent with
> > > > module name mt312 and naming of all other functions in there.
> > > > * vp310_mt312_ops -> mt312_ops
> > > > * vp310_mt312_attach -> mt312_attach
> > > >
> > > > It adds me to MODULE_AUTHOR
> > >
> > > Mauro!
> > >
> > > May I ask you to pull this patch?
> >
> > I got your first request.
> >
> Fine!
> 
> > I took a few days off last week. During this short period, my Inbox
> > exploded with lots of emails. I'm still handling my backlog.
> 
> No problem, just sometimes it looks like some patches just get lost.
> 
> >
> > In the case of this patch, I'd like to have Obi's ack, due to the
> > "MODULE_AUTHOR" addition, since he is the original author of the driver.
> >
> > I've already sent him an email about that. Hopefully, he'll answer soon
> > about it.
> 
> Well, I corresponded with him some time ago (around december, januar). So last 
> mail I got from him was on 30.01.2008.
> 
> There he asked, if I want to get over the maintainership of mt312. But he did 
> not respond to any further mails. :(
> 
> So I hope he will respond at least to your ack-request.

He agreed with this addition, so, I've already committed the patch.

Thanks,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
