Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1297 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab3BKNV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 08:21:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>,
	Arvydas Sidorenko <asido4@gmail.com>
Subject: Re: [RFCv2 PATCH 01/12] stk-webcam: the initial hflip and vflip setup was the wrong way around
Date: Mon, 11 Feb 2013 14:21:17 +0100
Cc: linux-media@vger.kernel.org
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl> <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com> <5118ED5C.2080801@redhat.com>
In-Reply-To: <5118ED5C.2080801@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302111421.17226.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon February 11 2013 14:08:44 Hans de Goede wrote:
> Hi,
> 
> Subject: stk-webcam: the initial hflip and vflip setup was the wrong way around
> 
> No it is not.

You are right, that patch makes no sense. It was a long day :-)

> On 02/10/2013 06:52 PM, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > This resulted in an upside-down picture.
> 
> No it does not, the laptop having an upside down mounted camera and not being
> in the dmi-table is what causes an upside down picture. For a non upside
> down camera (so no dmi-match) hflip and vflip should be 0.
> 
> The fix for the upside-down-ness Arvydas Sidorenko reported would be to
> add his laptop to the upside down table.

That doesn't make sense either. Arvydas, it worked fine for you before, right?
That is, if you use e.g. v3.8-rc7 then your picture is the right side up.

Can you confirm that?

Regards,

	Hans
