Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39466 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751882AbdC1Uji (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 16:39:38 -0400
Date: Tue, 28 Mar 2017 23:39:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Helen Koike <helen.koike@collabora.co.uk>,
        Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v7] [media] vimc: Virtual Media Controller core, capture
 and sensor
Message-ID: <20170328203904.GF16657@valkosipuli.retiisi.org.uk>
References: <6c85eaf4-1f91-7964-1cf9-602005b62a94@collabora.co.uk>
 <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
 <f8466f7a-0f33-a610-10fc-2515d5f6b499@iki.fi>
 <ef7c1d62-0553-2c5b-004f-527d82e380b3@collabora.co.uk>
 <20170327150918.6843e285@vento.lan>
 <f668b12f-0da8-98da-63b0-c5064cc87da9@xs4all.nl>
 <20170328142339.GD16657@valkosipuli.retiisi.org.uk>
 <20170328122550.265108fb@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170328122550.265108fb@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Mar 28, 2017 at 12:25:50PM -0300, Mauro Carvalho Chehab wrote:
...
> The (very few) of non-MC app that doesn't fail if without those ioctl
> will keep running.
> 
> The only difference on implementing it is that other non-MC
> applications will start to run if the driver passes on v4l2-compliance
> tests.
> 
> So, I don't see any troubles on doing that. Just benefits. 

Are there such applications? (Please see my other e-mail.)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
