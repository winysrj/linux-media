Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:39951 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaHMMOs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Aug 2014 08:14:48 -0400
Date: Wed, 13 Aug 2014 13:14:35 +0100
From: Ian Molton <ian.molton@codethink.co.uk>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"lars@metafoo.de" <lars@metafoo.de>,
	"shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
	william.towle@codethink.co.uk
Subject: Re: [PATCH 2/2] media: adv7604: Add ability to read default input
 port from DT
Message-Id: <20140813131435.e0da6946bcd69e04a2305ef9@codethink.co.uk>
In-Reply-To: <20140811121902.GA16295@leverpostej>
References: <1407758719-12474-1-git-send-email-ian.molton@codethink.co.uk>
	<1407758719-12474-3-git-send-email-ian.molton@codethink.co.uk>
	<20140811121902.GA16295@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 11 Aug 2014 13:19:02 +0100
Mark Rutland <mark.rutland@arm.com> wrote:

> > -  - pclk-sample: Pixel clock polarity. Defaults to output on the falling edge.
> > +  - pclk-sample:  Pixel clock polarity. Defaults to output on the falling edge.
> 
> Unrelated whitespace change?

Is there a sensible way to get miniscule whitespace changes in?

> >    If none of hsync-active, vsync-active and pclk-sample is specified the
> >    endpoint will use embedded BT.656 synchronization.
> >  
> > +  - default-input: Select which input is selected after reset.
> 
> Valid values are?

Chip dependent. 0 for 7611, 0-1 for 7612, I expect there are other chips in the family with differing numbers of inputs.

> > +	 if (!of_property_read_u32(endpoint, "default_input", &v))
> 
> This doesn't match the binding ('_' vs '-').

Good catch!

-- 
Ian Molton <ian.molton@codethink.co.uk>
