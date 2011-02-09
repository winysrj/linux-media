Return-path: <mchehab@pedra>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:60844 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab1BIJJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 04:09:13 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [PATCH/RFC 0/5] HDMI driver for Samsung S5PV310 platform
Date: Wed, 9 Feb 2011 09:59:29 +0100
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com
References: <1297157427-14560-1-git-send-email-t.stanislaws@samsung.com> <201102081047.17840.hansverk@cisco.com> <AANLkTi=A=HiAvHojWP8HcFXpjXbZpq6UdHjOnWq-8jww@mail.gmail.com>
In-Reply-To: <AANLkTi=A=HiAvHojWP8HcFXpjXbZpq6UdHjOnWq-8jww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102090959.29732.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, February 08, 2011 16:28:32 Alex Deucher wrote:
> On Tue, Feb 8, 2011 at 4:47 AM, Hans Verkuil <hansverk@cisco.com> wrote:

<snip>

> >>   The driver supports an interrupt. It is used to detect plug/unplug 
events
> > in
> >> kernel debugs.  The API for detection of such an events in V4L2 API is to 
be
> >> defined.
> >
> > Cisco (i.e. a few colleagues and myself) are working on this. We hope to 
post
> > an RFC by the end of this month. We also have a proposal for CEC support 
in
> > the pipeline.
> 
> Any reason to not use the drm kms APIs for modesetting, display
> configuration, and hotplug support?  We already have the
> infrastructure in place for complex display configurations and
> generating events for hotplug interrupts.  It would seem to make more
> sense to me to fix any deficiencies in the KMS APIs than to spin a new
> API.  Things like CEC would be a natural fit since a lot of desktop
> GPUs support hdmi audio/3d/etc. and are already using kms.

There are various reasons for not going down that road. The most important one 
is that mixing APIs is actually a bad idea. I've done that once in the past 
and I've regretted ever since. The problem with doing that is that it is 
pretty hard on applications who have to mix two different styles of API, 
somehow know where to find the documentation for each and know that both APIs 
can in fact be used on the same device.

Now, if there was a lot of code that could be shared, then that might be 
enough reason to go that way, but in practice there is very little overlap. 
Take CEC: all the V4L API will do is to pass the CEC packets from kernel to 
userspace and vice versa. There is no parsing at all. This is typically used 
by embedded apps that want to do their own CEC processing.

An exception might be a PCI(e) card with HDMI input/output that wants to 
handle CEC internally. At that point we might look at sharing CEC parsing 
code. A similar story is true for EDID handling.

One area that might be nice to look at would be to share drivers for HDMI 
receivers and transmitters. However, the infrastructure for such drivers is 
wildly different between how it is used for GPUs versus V4L and has been for 
10 years or so. I also suspect that most GPUs have there own HDMI internal 
implementation so code sharing will probably be quite limited.

So, no, there are no plans to share anything between the two (except perhaps 
EDID and CEC parsing should that become relevant).

Oh, and let me join Andy in saying that the drm/kms/whatever API documentation 
*really* needs a lot of work.

Regards,

	Hans
