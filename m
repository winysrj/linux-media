Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33734 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752486AbeADNIz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 08:08:55 -0500
Date: Thu, 4 Jan 2018 15:08:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] media: don't use whitespaces for indentation
Message-ID: <20180104130852.nfmae3fjxzrnja2q@valkosipuli.retiisi.org.uk>
References: <4e866518d3a00d4dedad069151cd447f66bd9387.1515068806.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e866518d3a00d4dedad069151cd447f66bd9387.1515068806.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, Jan 04, 2018 at 07:27:48AM -0500, Mauro Carvalho Chehab wrote:
> On several places, whitespaces are being used for indentation,
> or even at the end of the line.
> 
> Fix them, by running a script that fix it inside drivers/media
> and include/media.

What kind of a script?

Could you also add includ/uapi/media to this?

Thanks.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
