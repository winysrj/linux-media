Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53487 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750811Ab3KFQHX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 11:07:23 -0500
Date: Wed, 6 Nov 2013 18:06:48 +0200
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
Subject: Re: [PATCH v2] videodev2: Set vb2_rect's width and height as unsigned
Message-ID: <20131106160647.GH24988@valkosipuli.retiisi.org.uk>
References: <1383752584-25962-1-git-send-email-ricardo.ribalda@gmail.com>
 <20131106155347.GG24988@valkosipuli.retiisi.org.uk>
 <CAPybu_11w06dFksNoRKHr8ujgd=UBsfE3g1=1+qPaKTSoAstWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_11w06dFksNoRKHr8ujgd=UBsfE3g1=1+qPaKTSoAstWg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Wed, Nov 06, 2013 at 04:56:12PM +0100, Ricardo Ribalda Delgado wrote:
> It has to be done in the same patch? or  on a separated patch just
> changing the xml file?

Good question. Now that you ask, I also realise the documentation must also
be changed --- struct v4l2_rect is documented in
Documentation/DocBook/media/v4l/vidioc-cropcap.xml.

A separate patch for the documentation is fine for me, but I don't think
it's necessary. I'd probably put the changes into a single one since they
are still rather small.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
