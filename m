Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:33695 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754181AbZICLXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 07:23:23 -0400
Message-ID: <4A9FA729.3010207@onelan.com>
Date: Thu, 03 Sep 2009 12:23:21 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working	well
 together
References: <4A9E9E08.7090104@onelan.com>  <4A9EAF07.3040303@hhs.nl> <1251975978.22279.8.camel@morgan.walls.org>
In-Reply-To: <1251975978.22279.8.camel@morgan.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> But I suspect no user pays for the extra cost of the CX2341[568]
> hardware MPEG encoder, if the user primarily wants uncompressed YUV
> video as their main format.

Actually, we're doing exactly that. We want a PCI card from a reputable
manufacturer which provides uncompressed YUV and ATSC (both OTA and
ClearQAM cable). As we already buy Hauppauge HVR-1110s for DVB-T and
uncompressed analogue, a Hauppauge card suits us, and the only thing
they have that fits the needs is the HVR-1600; the MPEG encoder is thus
left idle.
-- 
Simon Farnsworth

