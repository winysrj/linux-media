Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:41733 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751948AbaGJKM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 06:12:29 -0400
Date: Thu, 10 Jul 2014 11:12:18 +0100
From: Ian Molton <ian.molton@codethink.co.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	William Towle <william.towle@codethink.co.uk>,
	mchehab@redhat.com, hans.verkuil@cisco.com,
	sylvester.nawrocki@gmail.com, vladimir.barinov@cogentembedded.com
Subject: Re: RFC: soc_camera, rcar_vin, and adv7604
Message-Id: <20140710111218.60572c1fc814de541b886147@codethink.co.uk>
In-Reply-To: <Pine.LNX.4.64.1407091955080.25501@axis700.grange>
References: <20140709174225.63a742ce09418cff539bb70a@codethink.co.uk>
	<Pine.LNX.4.64.1407091955080.25501@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 9 Jul 2014 22:34:07 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

>  Maybe we dould add some support, say, to 
> help with (fake) file handles just to aid the transition.

Indeed - the filehandles are probably the biggest sticking point. I already have the soc_camera code able to select mutually acceptable data formats, but the calls to get/set resolution seem to use fh's

I will persist with approach 2 then for now.

-- 
Ian Molton <ian.molton@codethink.co.uk>
