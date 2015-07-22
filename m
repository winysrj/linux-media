Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46046 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934075AbbGVAlL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2015 20:41:11 -0400
Date: Wed, 22 Jul 2015 09:41:05 +0900
From: Simon Horman <horms@verge.net.au>
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Cc: hverkuil@xs4all.nl, magnus.damm@gmail.com, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, j.anaszewski@samsung.com,
	kamil@wypas.org, sergei.shtylyov@cogentembedded.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/3] R-Car JPEG Processing Unit
Message-ID: <20150722004105.GD25644@verge.net.au>
References: <1437444022-28916-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1437444022-28916-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

On Tue, Jul 21, 2015 at 05:00:19AM +0300, Mikhail Ulyanov wrote:
> This series of patches contains a driver for the JPEG codec integrated
> peripheral found in the Renesas R-Car SoCs and associated DT documentation.

I am wondering if you have any plans to post patches to integrate this
change on any Reneas boards - by which I mean patches to update dts and/or
dtsi files. I would be very happy to see such patches submitted for review.
