Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+5c458d8712e04b812a42+1718+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1Jtq1r-0004rs-UD
	for linux-dvb@linuxtv.org; Wed, 07 May 2008 22:14:20 +0200
Date: Wed, 7 May 2008 17:13:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <20080507171342.3479dbc8@gaivota>
In-Reply-To: <200805070939.29694.zzam@gentoo.org>
References: <200804301421.04598.zzam@gentoo.org>
	<200805070939.29694.zzam@gentoo.org>
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

Hi Mathias,

On Wed, 7 May 2008 09:39:27 +0200
Matthias Schwarzott <zzam@gentoo.org> wrote:

> On Mittwoch, 30. April 2008, Matthias Schwarzott wrote:
> > Hi list!
> >
> > This patch does some small cleanup to mt312.
> > It changes kconfig description to also list the ZL10313.
> >
> > It does change some strange symbol names to be consistent with
> > module name mt312 and naming of all other functions in there.
> > * vp310_mt312_ops -> mt312_ops
> > * vp310_mt312_attach -> mt312_attach
> >
> > It adds me to MODULE_AUTHOR
> >
> 
> Mauro!
> 
> May I ask you to pull this patch?

I got your first request. 

I took a few days off last week. During this short period, my Inbox exploded
with lots of emails. I'm still handling my backlog.

In the case of this patch, I'd like to have Obi's ack, due to the
"MODULE_AUTHOR" addition, since he is the original author of the driver. 

I've already sent him an email about that. Hopefully, he'll answer soon about it.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
