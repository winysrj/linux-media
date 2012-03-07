Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:53361 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759236Ab2CGURR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Mar 2012 15:17:17 -0500
Received: by obbuo6 with SMTP id uo6so7342237obb.19
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 12:17:16 -0800 (PST)
Date: Wed, 7 Mar 2012 14:17:09 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Torsten Crass <torsten.crass@eBiology.de>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3.0.y 0/4] Re: lirc_serial spuriously claims assigned
 port and irq to be in use
Message-ID: <20120307201709.GD2008@burratino>
References: <1321422581.2885.50.camel@deadeye>
 <20120302034545.GA31860@burratino>
 <1330662942.8460.229.camel@deadeye>
 <20120302203913.GA22323@burratino>
 <20120307200407.GB26451@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307200407.GB26451@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg Kroah-Hartman wrote:
> On Fri, Mar 02, 2012 at 02:39:13PM -0600, Jonathan Nieder wrote:
>> Ben Hutchings wrote:
>>> On Thu, 2012-03-01 at 21:45 -0600, Jonathan Nieder wrote:

>>>> Would some of these patches (e.g., at least patches 1, 2, and 5) be
>>>> appropriate for inclusion in the 3.0.y and 3.2.y stable kernels from
>>>> kernel.org?
>>>
>>> Assuming they haven't caused any regressions, I think everything except
>>> 9b98d6067971 (4/5) would be appropriate.
>>
>> Great.  Here are the aforementioned patches rebased against 3.0.y,
[...]
> So they should also go to 3.2-stable, right?

Yes.

Thanks,
Jonathan
