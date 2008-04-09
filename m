Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1JjWU7-0001Ze-Vn
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 11:20:54 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Wed, 9 Apr 2008 11:21:22 +0200
References: <200803292240.25719.janne-dvb@grunau.be>
	<37219a840804080818x729fd503ka3ba048c46169bcb@mail.gmail.com>
	<200804090022.40805@orion.escape-edv.de>
In-Reply-To: <200804090022.40805@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804091121.22092.janne-dvb@grunau.be>
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
	dvb adapter numbers, second try
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

On Wednesday 09 April 2008 00:22:40 Oliver Endriss wrote:
> Michael Krufky wrote:
> >
> > I would really like to see this patch get merged.
> >
> > If nobody has an issue with this, I plan to push this into a
> > mercurial tree at the end of the week and request that it be merged
> > into the master branch.
>
> Correct me if I'm wrong, but afaik the option should be named
> 'adapter_no', not 'adapter_nr'.

The usual english abbreviation for number is no. OTOH the respective V4L 
options are also called video|radio|vbi _nr, so calling it adapter_nr 
would be consistent with V4L.

I'm not sure which argument is more important but it won't be much work 
to change it o adapter_no.

Janne

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
