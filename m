Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33170 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752099AbdK2Ir1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 03:47:27 -0500
Date: Wed, 29 Nov 2017 10:47:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 3/3] media: staging: atomisp: prefer s16 to int16_t.
Message-ID: <20171129084725.jopy3nl7yc6budsc@valkosipuli.retiisi.org.uk>
References: <20171127113054.27657-1-jeremy@azazel.net>
 <20171127113054.27657-4-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127113054.27657-4-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 27, 2017 at 11:30:54AM +0000, Jeremy Sowden wrote:
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

I'd just leave it as-is, int16_t is a standard type. The commit message
would be needed, too.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
