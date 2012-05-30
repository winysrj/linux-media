Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:7472 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2E3MLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 May 2012 08:11:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Soby Mathew <soby.mathew@st.com>
Subject: Re: Preliminary proposal, new APIs for HDMI and DVI control in v4l2
Date: Wed, 30 May 2012 14:10:34 +0200
Cc: "Martin Bugge (marbugge)" <marbugge@cisco.com>,
	linux-media@vger.kernel.org
References: <4D7E42AE.2080506@cisco.com> <loom.20120527T192755-466@post.gmane.org> <4FC600D7.1020203@cisco.com>
In-Reply-To: <4FC600D7.1020203@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205301410.34174.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 30 May 2012 13:13:27 Martin Bugge (marbugge) wrote:
> Hi Soby
> 
> On 05/27/2012 07:30 PM, Soby Mathew wrote:
> > Martin Bugge (marbugge<marbugge<at>  cisco.com>  writes:
> >
> >>
> >> This is a preliminary proposal for an extension to the v4l2 api.
> >> To be discussed at the  V4L2 'brainstorming' meeting in Warsaw, March 2011
> >>
> >> Purpose: Provide basic controls for HDMI and DVI devices.
> >>
> >>
> > reposting the query since the earlier post did not appear in mailing list.
> >
> > Hi Martin,
> >     We are also in requirement of these controls as described by you. I did a
> > search in the archives but could not find a suitable conclusion to the RFC. I
> > could find that the dv_timings structure has been modified as a result of
> > further discussions. But for many items like S_EDID, DV_CABLE_DETECT, Info
> > frames etc , I could not find the logical conclusion to this RFC. Could please
> > let me know the further updates on these requirements?
> It has been on hold for a very long time, but just last week Hans 
> Verkuil posted a RFC
> which is a follow up on this subject.
> 
> http://www.spinics.net/lists/linux-media/msg47671.html
> 
> So that thread has taken over.

And expect to see a small patch series to be posted in the next few days containing
a slightly changed version of the proposal, including DocBook documentation.

Please review those patches when they are posted and let us know if you are OK with
it or if you have additional requirements.

Regards,

	Hans
