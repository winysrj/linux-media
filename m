Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:45229 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753781AbdL2Jnr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 04:43:47 -0500
Date: Fri, 29 Dec 2017 11:43:38 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Patrice Chotard <patrice.chotard@st.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Helen Koike <helen.koike@collabora.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] media: don't include drivers/media/i2c at cflags
Message-ID: <20171229094338.rgcetcop33wflxre@kekkonen.localdomain>
References: <fada1935590f66dc6784981e0d557ca09013c847.1514488526.git.mchehab@s-opensource.com>
 <ada795551aff6662d2322f63e55a853a58389eb5.1514488526.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada795551aff6662d2322f63e55a853a58389eb5.1514488526.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 28, 2017 at 02:21:49PM -0500, Mauro Carvalho Chehab wrote:
> Most of the I2C headers got moved a long time ago to
> include/media/i2c. Stop including them at the patch.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
