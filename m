Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:45393 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbbIVQhC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 12:37:02 -0400
Date: Tue, 22 Sep 2015 17:36:48 +0100 (BST)
From: William Towle <william.towle@codethink.co.uk>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org
Subject: Re: [Linux-kernel] Renesas Lager: Device Tree entries for VIN HDMI
 input, version 2
In-Reply-To: <1439465811-936-1-git-send-email-william.towle@codethink.co.uk>
Message-ID: <alpine.DEB.2.02.1509221642350.6758@xk120.dyn.ducie.codethink.co.uk>
References: <1439465811-936-1-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

> On Thu, 13 Aug 2015, William Towle wrote:
> >  (Obsoletes corresponding parts of "HDMI and Composite capture on
> > Lager...", published previously)

> > To follow:
> > 	[PATCH 1/3] ARM: shmobile: lager dts: Add entries for VIN HDMI input
> > 	[PATCH 2/3] media: adv7604: automatic "default-input" selection
> > 	[PATCH 3/3] ARM: shmobile: lager dts: specify default-input for

> I am wondering about the status of patch 2 of the series,
> is it queued-up anywhere?

   All of these are effectively new, although the first and third
debuted in another thread. The patchwork link for the latter (at
https://patchwork.linuxtv.org/patch/30707/) contains the discussion
that led to the above being separated out.


> I am also wondering about the relationship between patch 2 and 3.
> Does 3 work without 2? Does 2 make 3 unnecessary?

   The device tree change in patch 3 is from Ian Molton's original
submissions, and works regardless of whether patch 2 is alongside it
or not.

   As far as the automatic port selection goes, patch 2 is related to
the argument made in commit 7111cdd ("[media] media: adv7604: reduce
support to first (digital) input") that since cable detect doesn't
work for port B, the .max_port property for boards using an ADV7612
should be ADV76XX_PAD_HDMI_PORT_A and we can use this to configure
port A as the default where there is not also an entry to specify it
in the device tree.
   If support for port B were available [in future], no action would
be taken where an ADV7612 is present and one would need to arrange
for applications in userland to actively make a choice where the
device tree does not have an appropriate value. In our particular case
we don't differentiate between hardware with ADV7611/7612 in the test
suite, and this necessitates having port selection available in the
device tree.

   Laurent may wish to comment further; for earlier discussion, see
https://patchwork.linuxtv.org/patch/30707/

Cheers,
   Wills.
