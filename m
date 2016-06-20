Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45848 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754172AbcFTPAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 11:00:07 -0400
Date: Mon, 20 Jun 2016 17:59:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	hans.verkuil@cisco.com, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 2/4] vb2: Merge vb2_internal_dqbuf and vb2_dqbuf
Message-ID: <20160620145906.GJ24980@valkosipuli.retiisi.org.uk>
References: <1466426845-25673-1-git-send-email-ricardo.ribalda@gmail.com>
 <1466426845-25673-2-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466426845-25673-2-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 20, 2016 at 02:47:23PM +0200, Ricardo Ribalda Delgado wrote:
> After all the code refactoring, vb2_internal_dqbuf is only called by
> vb2_dqbuf.
> 
> Since the function it is very simple, there is no need to have two
> functions.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Hi, Ricardo!

Patches 2--4: 

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
