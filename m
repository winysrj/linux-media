Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:40436 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbZLDU7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 15:59:11 -0500
Received: by ey-out-2122.google.com with SMTP id d26so694617eyd.19
        for <linux-media@vger.kernel.org>; Fri, 04 Dec 2009 12:59:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a3ef07920912041202u78f4d12av8d7a49f5f91b3d56@mail.gmail.com>
References: <20091022211330.6e84c6e7@hyperion.delvare>
	 <4B02FDA4.5030508@infradead.org>
	 <1a297b360911200129pe5af064wf9cf239851ac5c46@mail.gmail.com>
	 <200911201237.31537.julian@jusst.de>
	 <1a297b360911200808k12676112lf7a11f3dfd44a187@mail.gmail.com>
	 <4B07290B.4060307@jusst.de>
	 <a3ef07920912041202u78f4d12av8d7a49f5f91b3d56@mail.gmail.com>
Date: Fri, 4 Dec 2009 15:59:16 -0500
Message-ID: <37219a840912041259w499f2347he1b25c16550d671f@mail.gmail.com>
Subject: Re: Details about DVB frontend API
From: Michael Krufky <mkrufky@kernellabs.com>
To: VDR User <user.vdr@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 4, 2009 at 3:02 PM, VDR User <user.vdr@gmail.com> wrote:
> No activity in this thread for 2 weeks now.  Has there been any progress?

I think I speak on behalf of most LinuxTV developers, when I say that
nobody wants to spend their free personal time working on something
that might get shot down with such controversy.

I have stated that I like Manu's proposal, but I would prefer that the
get_property (s2api) interface were used, because it totally provides
an interface that is sufficient for this feature.

Manu and I agree that these values should all be read at once.

I think we all (except Mauro) agree that the behavior within the
driver should fetch all statistics at once and return it to userspace
as a single structure with all the information as it all relates to
each other.

Furthermore, I think we all know that we cant just remove the current
structures, and we should do something to normalize the current
reporting values.

The longer this thread gets, the less likely anybody is to do anything about it.

Let me state my opinion again:

I would like to see a solution merged, and I think Manu's solution is
reasonable, although it may be complicated -- if all drivers are
updated to support it, then it will all be worth it.  The question is,
*will* all drivers update to support this?  I don't know.

We have the S2API's set / get property API -- In my opinion, we should
use this API to fetch statistic information and have it return a
single atomic structure.  Applications can use only the information
that they're interested in.

In the meanwhile, as a SEPARATE PROJECT, we should do something to
standardize the values reported by the CURRENT API across the entire
subsystem.  This should not be confused with Manu's initiative to
create a better API -- we cant remove the current API, but it should
be standardized.

I volunteer to work on the standardization of the CURRENT Api, and I
am all for seeing a new API introduced for better statistical
reporting, provided that the get property method is used as an
interface, rather than adding new ioctls.  However, if we add a new
API, we haev to make sure that all the current drivers are updated to
support it -- do we have all the information that we need for this?
Do we have the manpower and the drive to get it done?

My urge to do this work is a strong urge, but I have no desire to do
this if people want to continue arguing about it... In the meanwhile,
I am working on new drivers for new devices, and this is *much* more
interesting that worrying about how strong a signal is for a device
that already works.

When you folks stop talking about this, that's when I will push the
trees containing all the work that I've done already thus far -- we
need to standardize the current API, and that has nothing to do with
Manu's proposal.

We should not confuse standardization the current reporting units with
the introduction of a new API -- both should be done, but the more
arguing there is about it, the less of a chance that anybody will
volunteer their own time to work on it.

...and just to clarify -- I think I said it twice already, but
repeating again -- I (mostly) like Manu's proposal, but if we cant
update the drivers to support it, then is it worth the trouble?

Regards,

Mike Krufky
