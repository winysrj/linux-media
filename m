Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40133 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab2CHSex (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 13:34:53 -0500
Received: by yhmm54 with SMTP id m54so419953yhm.19
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2012 10:34:53 -0800 (PST)
Date: Thu, 8 Mar 2012 10:34:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Torsten Crass <torsten.crass@eBiology.de>,
	Jarod Wilson <jarod@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3.0.y 0/4] Re: lirc_serial spuriously claims assigned
 port and irq to be in use
Message-ID: <20120308183447.GA25235@kroah.com>
References: <1321422581.2885.50.camel@deadeye>
 <20120302034545.GA31860@burratino>
 <1330662942.8460.229.camel@deadeye>
 <20120302203913.GA22323@burratino>
 <20120307200407.GB26451@kroah.com>
 <20120307201709.GD2008@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307201709.GD2008@burratino>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 07, 2012 at 02:17:09PM -0600, Jonathan Nieder wrote:
> Greg Kroah-Hartman wrote:
> > On Fri, Mar 02, 2012 at 02:39:13PM -0600, Jonathan Nieder wrote:
> >> Ben Hutchings wrote:
> >>> On Thu, 2012-03-01 at 21:45 -0600, Jonathan Nieder wrote:
> 
> >>>> Would some of these patches (e.g., at least patches 1, 2, and 5) be
> >>>> appropriate for inclusion in the 3.0.y and 3.2.y stable kernels from
> >>>> kernel.org?
> >>>
> >>> Assuming they haven't caused any regressions, I think everything except
> >>> 9b98d6067971 (4/5) would be appropriate.
> >>
> >> Great.  Here are the aforementioned patches rebased against 3.0.y,
> [...]
> > So they should also go to 3.2-stable, right?
> 
> Yes.

Thanks, all now queued up.

greg k-h
