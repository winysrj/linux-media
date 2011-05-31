Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2608 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab1EaRCc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 13:02:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: vipul kumar samar <vipulkumar.samar@st.com>
Subject: Re: About RFC of HDMI-CEC
Date: Tue, 31 May 2011 19:01:28 +0200
Cc: "Martin Bugge (marbugge)" <marbugge@cisco.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <4DDCED60.3080907@st.com> <201105260835.45559.hverkuil@xs4all.nl> <4DDE44BA.6030808@st.com>
In-Reply-To: <4DDE44BA.6030808@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105311901.28876.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, May 26, 2011 14:16:58 vipul kumar samar wrote:
> On 05/26/2011 12:05 PM, Hans Verkuil wrote:
> > On Thursday, May 26, 2011 07:09:30 vipul kumar samar wrote:
> >> Hello,
> >>
> >> On 05/25/2011 06:13 PM, Martin Bugge (marbugge) wrote:
> >>> Hello
> >>>
> >>> To be honest I became a bit disengaded after all the discussion.
> >>>
> >>> What caused me a lot of problems was the request for AV link support
> >>> (which is used in SCART connectors).
> >>> Something I never plan to implement.
> >>>
> >>> But after the "v4l2 Warsaw Brainstroming meeting" it was sort of approved.
> >>>
> >>> It only need to be reworked to be a subdev level api.
> >>> (for that I need some help from Hans Verkuil)
> >>>
> >>> But it is great that someone else also need an API for this.
> >>> I include the latest version here so you can see if you agree, and
> >>> together we will get it in.
> >>>
> >>
> >> Yes, sure.
> >>
> >>> We currently have two drivers which uses this API for CEC.
> >>>
> >>> * Analog Devices adv7604
> >>>
> >>> * TMS320DM8x
> >>>
> >>
> >> i want to see source code of these two drivers.From where i can get
> >> source code of these drivers??
> >
> > The adv7604 driver is here:
> >
> > http://git.linuxtv.org/hverkuil/cisco.git?a=shortlog;h=refs/heads/cobalt
> >
> > But this tree hasn't been updated in quite some time and doesn't contain the
> > CEC support. I need to work on this anyway today so I'll see if I can get
> > this tree in sync with our internal tree.
> >
> > The other driver we can't release as open source. It will eventually become
> > available, though.
> >
> > Regards,
> >
> >        Hans
> 
> Hello Hans,
> 
> Once i go through this driver then we will discuss it in more detail.
> Thanks for your support.

Hi Vipul,

I updated the adv7604 driver yesterday to the latest version. Be aware that it
is work in progress, so there are still loose ends and TODOs. But at least the
CEC support is in.

Regards,

	Hans
