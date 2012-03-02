Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48329 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab2CBVQy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 16:16:54 -0500
Received: by dajr28 with SMTP id r28so2419314daj.19
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2012 13:16:54 -0800 (PST)
Date: Fri, 2 Mar 2012 13:13:00 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Torsten Crass <torsten.crass@eBiology.de>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3.0.y 0/4] Re: lirc_serial spuriously claims assigned
 port and irq to be in use
Message-ID: <20120302211300.GA6008@kroah.com>
References: <1321422581.2885.50.camel@deadeye>
 <20120302034545.GA31860@burratino>
 <1330662942.8460.229.camel@deadeye>
 <20120302203913.GA22323@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302203913.GA22323@burratino>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 02, 2012 at 02:39:13PM -0600, Jonathan Nieder wrote:
> Ben Hutchings wrote:
> > On Thu, 2012-03-01 at 21:45 -0600, Jonathan Nieder wrote:
> 
> >> Would some of these patches (e.g., at least patches 1, 2, and 5) be
> >> appropriate for inclusion in the 3.0.y and 3.2.y stable kernels from
> >> kernel.org?
> >
> > Assuming they haven't caused any regressions, I think everything except
> > 9b98d6067971 (4/5) would be appropriate.
> 
> Great.  Here are the aforementioned patches rebased against 3.0.y, in
> the hope that some interested person can confirm they still work.  The
> only backporting needed was to adjust to the lack of
> drivers/staging/lirc -> drivers/staging/media/lirc renaming.

I'll look at these, but please, in the future, send all stable patches
to stable@vger.kernel.org as there are other stable trees that people
maintain and they watch that list...

thanks,

greg k-h
