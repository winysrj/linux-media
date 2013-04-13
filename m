Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:38088 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3DMTR6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 15:17:58 -0400
Received: by mail-we0-f173.google.com with SMTP id t57so2756439wey.18
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 12:17:56 -0700 (PDT)
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC v6] [media] Add common video interfaces OF bindings documentation
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	rob.herring@calxeda.com
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com, swarren@wwwdotorg.org,
	t.figa@samsung.com, myungjoo.ham@samsung.com,
	sw0312.kim@samsung.com, prabhakar.lad@ti.com,
	Thomas Abraham <thomas.abraham@linaro.org>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
In-Reply-To: <5149E1A9.9090506@samsung.com>
References: <1359652738-1544-2-git-send-email-s.nawrocki@samsung.com> <1359657675-6678-1-git-send-email-s.nawrocki@samsung.com> <5149E1A9.9090506@samsung.com>
Date: Sat, 13 Apr 2013 20:17:52 +0100
Message-Id: <20130413191752.AF4B23E2249@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 Mar 2013 17:19:53 +0100, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> On 01/31/2013 07:41 PM, Sylwester Nawrocki wrote:
> > From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > This patch adds a document describing common OF bindings for video
> > capture, output and video processing devices. It is curently mainly
> > focused on video capture devices, with data busses defined by
> > standards like ITU-R BT.656 or MIPI-CSI2.
> > It also documents a method of describing data links between devices.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > ---
> > 
> > Changes since v5:
> >  - added 'ports' node documentation
> 
> Hi Rob, Grant,
> 
> there was no more comments on this patch for a relatively long time
> now. Would you apply it to your tree or could I send it for inclusion
> in the media tree with your Ack ?

For the binding:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

