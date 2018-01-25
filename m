Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54126 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751480AbeAYKw5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 05:52:57 -0500
Date: Thu, 25 Jan 2018 12:52:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Akash Gajjar <gajjar04akash@gmail.com>
Cc: Akash Gajjar <Akash_Gajjar@mentor.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: leds: as3645a: Add CONFIG_OF support
Message-ID: <20180125105253.25b5gydtqlqo7bnn@valkosipuli.retiisi.org.uk>
References: <1516865677-16006-1-git-send-email-gajjar04akash@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516865677-16006-1-git-send-email-gajjar04akash@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akash,

On Thu, Jan 25, 2018 at 01:04:36PM +0530, Akash Gajjar wrote:
> From: Akash Gajjar <Akash_Gajjar@mentor.com>
> 
> Witth this changes, the driver builds with CONFIG_OF support
> 
> Signed-off-by: Akash Gajjar <gajjar04akash@gmail.com>

Sorry; this driver has been removed in favour of the LED framework driver
for the same device. It can be found in drivers/leds/leds-as3645a.c

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
