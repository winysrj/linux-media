Return-path: <mchehab@pedra>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55140 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab1BRWdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 17:33:40 -0500
Date: Fri, 18 Feb 2011 22:33:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [alsa-devel] [PATCH v9 01/12] media: Media device node support
Message-ID: <20110218223337.GC25168@sirena.org.uk>
References: <1297686067-9666-1-git-send-email-laurent.pinchart@ideasonboard.com> <1297686067-9666-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297686067-9666-2-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 14, 2011 at 01:20:56PM +0100, Laurent Pinchart wrote:

> +	  Enable the media controller API used to query media devices internal
> +	  topology and configure it dynamically.
> +
> +	  This API is mostly used by camera interfaces in embedded platforms.

I'd expect this comment is going to bitrot very soon once the framework
goes in.
