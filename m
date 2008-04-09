Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JjdZu-0002HM-4h
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 18:55:24 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Wed, 9 Apr 2008 18:50:53 +0200
References: <200803292240.25719.janne-dvb@grunau.be>
	<200804091121.22092.janne-dvb@grunau.be>
	<37219a840804090745q1f3cc495s7ce63d59793cac4a@mail.gmail.com>
In-Reply-To: <37219a840804090745q1f3cc495s7ce63d59793cac4a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804091850.54005@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
	dvb adapter numbers, second try
Reply-To: linux-dvb@linuxtv.org
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

Michael Krufky wrote:
> (sorry for the double-email -- accidentally sent from the wrong email account)
> 
> On Wed, Apr 9, 2008 at 5:21 AM, Janne Grunau <janne-dvb@grunau.be> wrote:
> > On Wednesday 09 April 2008 00:22:40 Oliver Endriss wrote:
> >
> > > Michael Krufky wrote:
> >  > >
> >  > > I would really like to see this patch get merged.
> >  > >
> >  > > If nobody has an issue with this, I plan to push this into a
> >  > > mercurial tree at the end of the week and request that it be merged
> >  > > into the master branch.
> >  >
> >  > Correct me if I'm wrong, but afaik the option should be named
> >  > 'adapter_no', not 'adapter_nr'.
> >
> >  The usual english abbreviation for number is no. OTOH the respective V4L
> >  options are also called video|radio|vbi _nr, so calling it adapter_nr
> >  would be consistent with V4L.
> >
> >  I'm not sure which argument is more important but it won't be much work
> >  to change it o adapter_no.
> >
> >  Janne
> 
> I believe that the "nr" abbreviation comes from the German language.
> (correct me if I'm wrong)

Yep.

> Perhaps the abbreviation, "no" is more correct, since it is based on
> the English language, but to me this is of no significance, since v4l
> uses the "nr" abbreviation and this is globally understood.
> 
> If Oliver perfers "adapter_no" then lets go with it.  Otherwise, it's
> fine as-is.

Basically _I_ don't care at all, but obviously there are some guys who
search the code for typos. I guess they will find this one sooner or
later, and we have to change it anyway.

But if you'd like to use nr it is ok for me.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
