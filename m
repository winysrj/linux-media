Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1JjbYO-00043M-Ng
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 16:45:37 +0200
Received: by gv-out-0910.google.com with SMTP id n40so515639gve.16
	for <linux-dvb@linuxtv.org>; Wed, 09 Apr 2008 07:45:30 -0700 (PDT)
Message-ID: <37219a840804090745q1f3cc495s7ce63d59793cac4a@mail.gmail.com>
Date: Wed, 9 Apr 2008 10:45:29 -0400
From: "Michael Krufky" <mkrufky@gmail.com>
To: "Janne Grunau" <janne-dvb@grunau.be>
In-Reply-To: <200804091121.22092.janne-dvb@grunau.be>
MIME-Version: 1.0
Content-Disposition: inline
References: <200803292240.25719.janne-dvb@grunau.be>
	<37219a840804080818x729fd503ka3ba048c46169bcb@mail.gmail.com>
	<200804090022.40805@orion.escape-edv.de>
	<200804091121.22092.janne-dvb@grunau.be>
Cc: linux-dvb@linuxtv.org
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

(sorry for the double-email -- accidentally sent from the wrong email account)

On Wed, Apr 9, 2008 at 5:21 AM, Janne Grunau <janne-dvb@grunau.be> wrote:
> On Wednesday 09 April 2008 00:22:40 Oliver Endriss wrote:
>
> > Michael Krufky wrote:
>  > >
>  > > I would really like to see this patch get merged.
>  > >
>  > > If nobody has an issue with this, I plan to push this into a
>  > > mercurial tree at the end of the week and request that it be merged
>  > > into the master branch.
>  >
>  > Correct me if I'm wrong, but afaik the option should be named
>  > 'adapter_no', not 'adapter_nr'.
>
>  The usual english abbreviation for number is no. OTOH the respective V4L
>  options are also called video|radio|vbi _nr, so calling it adapter_nr
>  would be consistent with V4L.
>
>  I'm not sure which argument is more important but it won't be much work
>  to change it o adapter_no.
>
>  Janne

I believe that the "nr" abbreviation comes from the German language.
(correct me if I'm wrong)

Perhaps the abbreviation, "no" is more correct, since it is based on
the English language, but to me this is of no significance, since v4l
uses the "nr" abbreviation and this is globally understood.

If Oliver perfers "adapter_no" then lets go with it.  Otherwise, it's
fine as-is.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
