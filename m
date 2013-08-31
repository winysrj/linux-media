Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46630 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755743Ab3HaRmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 13:42:33 -0400
Date: Sat, 31 Aug 2013 20:42:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <posciak@chromium.org>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, k.debski@samsung.com
Subject: Re: [PATCH v1 14/19] v4l: Add v4l2_buffer flags for VP8-specific
 special frames.
Message-ID: <20130831174228.GA4216@valkosipuli.retiisi.org.uk>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
 <52203EDB.8080308@xs4all.nl>
 <CACHYQ-pUhmPhMrbE8QWM+r6OWbBnOx7g6vjQvOxBSoodnPk4+Q@mail.gmail.com>
 <201308301012.46032.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308301012.46032.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Pawel,

On Fri, Aug 30, 2013 at 10:12:45AM +0200, Hans Verkuil wrote:
> Are prev/golden/altref frames mutually exclusive? If so, then perhaps we

Does that apply to other types of frames as well (key, p and b)? If yes, the
existing frame bits could be used for VP8 frame flags while the existing
codecs could keep using the old definitions, i.e. same bits, but different
macros.

Just my five euro cents.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
