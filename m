Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx06.syd.iprimus.net.au ([210.50.76.235]:49463 "EHLO
	mx06.syd.iprimus.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbZLIWMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 17:12:34 -0500
From: Primusmail <mike_booth76@iprimus.com.au>
To: linux-media@vger.kernel.org
Subject: Re: Details about DVB frontend AP
Date: Thu, 10 Dec 2009 09:02:10 +1100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912100902.11042.mike_booth76@iprimus.com.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

n Saturday 05 December 2009 07:59:16 Michael Krufky wrote:
> On Fri, Dec 4, 2009 at 3:02 PM, VDR User <user.vdr@gmail.com> wrote:
> > No activity in this thread for 2 weeks now.  Has there been any progress?
>
> I think I speak on behalf of most LinuxTV developers, when I say that
> nobody wants to spend their free personal time working on something
> that might get shot down with such controversy.
>
> I have stated that I like Manu's proposal, but I would prefer that the
> get_property (s2api) interface were used, because it totally provides
> an interface that is sufficient for this feature.
>
> Manu and I agree that these values should all be read at once.
>
> I think we all (except Mauro) agree that the behavior within the
> driver should fetch all statistics at once and return it to userspace
> as a single structure with all the information as it all relates to
> each other.
>
> Furthermore, I think we all know that we cant just remove the current
> structures, and we should do something to normalize the current
> reporting values.
>
> The longer this thread gets, the less likely anybody is to do anything
> about it.
>
> Let me state my opinion again:
>
> I would like to see a solution merged, and I think Manu's solution is
> reasonable, although it may be complicated -- if all drivers are
> updated to support it, then it will all be worth it.  The question is,
> will all drivers update to support this?  I don't know.
>
> We have the S2API's set / get property API -- In my opinion, we should
> use this API to fetch statistic information and have it return a
> single atomic structure.  Applications can use only the information
> that they're interested in.
>
> In the meanwhile, as a SEPARATE PROJECT, we should do something to
> standardize the values reported by the CURRENT API across the entire
> subsystem.  This should not be confused with Manu's initiative to
> create a better API -- we cant remove the current API, but it should
> be standardized.
>
> I volunteer to work on the standardization of the CURRENT Api, and I
> am all for seeing a new API introduced for better statistical
> reporting, provided that the get property method is used as an
> interface, rather than adding new ioctls.  However, if we add a new
> API, we haev to make sure that all the current drivers are updated to
> support it -- do we have all the information that we need for this?
> Do we have the manpower and the drive to get it done?
>
> My urge to do this work is a strong urge, but I have no desire to do
> this if people want to continue arguing about it... In the meanwhile,
> I am working on new drivers for new devices, and this is much more
> interesting that worrying about how strong a signal is for a device
> that already works.
>
> When you folks stop talking about this, that's when I will push the
> trees containing all the work that I've done already thus far -- we
> need to standardize the current API, and that has nothing to do with
> Manu's proposal.
>
> We should not confuse standardization the current reporting units with
> the introduction of a new API -- both should be done, but the more
> arguing there is about it, the less of a chance that anybody will
> volunteer their own time to work on it.
>
> ...and just to clarify -- I think I said it twice already, but
> repeating again -- I (mostly) like Manu's proposal, but if we cant
> update the drivers to support it, then is it worth the trouble?
>
> Regards,
>
> Mike Krufky
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Good to hear that this is still in someones consciousness. A friend of mine 
has taken Manus patch and has modified the vdr-femon and vdr-rotor plugins to 
display Signal Strength and signal to Noise again. Not accurate numbers but 
they do show when tuning is improving or worsening and thats all I need. This 
is only for TTS2-3200 cards , THis might be of interest to someone.

Mike
