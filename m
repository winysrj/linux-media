Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:46918 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1L3Vma (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 16:42:30 -0500
Date: Fri, 30 Dec 2011 23:42:26 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 1/4] V4L: Add JPEG compression control class
Message-ID: <20111230214225.GB3677@valkosipuli.localdomain>
References: <4EBECD11.8090709@gmail.com>
 <1325015011-11904-1-git-send-email-snjw23@gmail.com>
 <1325015011-11904-2-git-send-email-snjw23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325015011-11904-2-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tue, Dec 27, 2011 at 08:43:28PM +0100, Sylwester Nawrocki wrote:
...
> +#define	V4L2_CID_JPEG_ACTIVE_MARKERS		(V4L2_CID_JPEG_CLASS_BASE + 4)

Just a few comments. I like the approach, and I'd just remove the 'S' from
the CID name.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
