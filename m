Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:43677 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbbEMTsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 15:48:51 -0400
Date: Wed, 13 May 2015 20:48:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: v4.1-rcX regression in v4l2 build
Message-ID: <20150513194844.GS2067@n2100.arm.linux.org.uk>
References: <87d225mve4.fsf@belgarion.home>
 <Pine.LNX.4.64.1505122221150.11250@axis700.grange>
 <Pine.LNX.4.64.1505122302570.11250@axis700.grange>
 <87pp64l1o4.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pp64l1o4.fsf@belgarion.home>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 13, 2015 at 09:26:03PM +0200, Robert Jarzmik wrote:
> First, a question for Russell :
>   Given that the current PXA architecture is not implementing the
>   clk_round_rate() function, while implementing clk_get(), etc..., is it correct
>   to say that it is betraying the clk API by doing so ?

Really, yes.  PXA used to be self-contained as far as clk API usage, and
so it only ever implemented what it needed from the API to support the
SoC.  Now that things are getting "more complicated" then the other
functions will probably be needed.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
