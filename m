Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:38409 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2LRROd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 12:14:33 -0500
Message-ID: <50D0A475.7010800@wwwdotorg.org>
Date: Tue, 18 Dec 2012 10:14:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	grant.likely@secretlab.ca, rob.herring@calxeda.com,
	nicolas.thery@st.com, s.hauer@pengutronix.de,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] [media] Add common binding documentation for video interfaces
References: <1355168499-5847-9-git-send-email-s.nawrocki@samsung.com> <1355606016-6509-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1355606016-6509-1-git-send-email-sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2012 02:13 PM, Sylwester Nawrocki wrote:
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> This patch adds a document describing common OF bindings for video
> capture, output and video processing devices. It is currently mainly
> focused on video capture devices, with data interfaces defined in
> standards like ITU-R BT.656 or MIPI CSI-2.
> It also documents a method of describing data links between devices.

(quickly/briefly)
Reviewed-by: Stephen Warren <swarren@nvidia.com>

