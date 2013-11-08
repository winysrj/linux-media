Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59787 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757076Ab3KHKj4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Nov 2013 05:39:56 -0500
Date: Fri, 8 Nov 2013 12:39:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	"open list:MT9M032 APTINA SE..." <linux-media@vger.kernel.org>
Subject: Re: [PATCH v5] videodev2: Set vb2_rect's width and height as unsigned
Message-ID: <20131108103921.GB25342@valkosipuli.retiisi.org.uk>
References: <1383763336-5822-1-git-send-email-ricardo.ribalda@gmail.com>
 <3183788.gODlx1VQRn@avalon>
 <CAPybu_1qCzDO15d1X2RAfqip9WepMQ88A=YYRWwJPDf1OxhsDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_1qCzDO15d1X2RAfqip9WepMQ88A=YYRWwJPDf1OxhsDA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 08, 2013 at 11:12:54AM +0100, Ricardo Ribalda Delgado wrote:
...
> Also I am not aware of a reason why clamp_t is better than clamp (I am
> probably wrong here....). If there is a good reason for not using
> clamp_t I have no problem in reviewing again the patch and use
> unsigned constants.

clamp_t() should only be used if you need to force a type for the clamping
operation. It's always better if you don't have to, and all the arguments
are of the same type: type casting can have an effect on the end result and
bugs related to that can be difficult to find.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
