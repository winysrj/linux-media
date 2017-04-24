Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44004 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S976332AbdDXRvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 13:51:00 -0400
Date: Mon, 24 Apr 2017 20:50:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: Re: [PATCH] [media] ov2640: make GPIOLIB an optional dependency
Message-ID: <20170424175023.GV7456@valkosipuli.retiisi.org.uk>
References: <a463ea990d2138ca93027b006be96a0324b77fe4.1492602584.git.mchehab@s-opensource.com>
 <20170419132339.GA31747@amd>
 <20170419110300.2dbbf784@vento.lan>
 <20170421063312.GA21434@amd>
 <20170421113934.55158d51@vento.lan>
 <20170424144402.GS7456@valkosipuli.retiisi.org.uk>
 <20170424125036.0d17e213@vento.lan>
 <20170424173847.GU7456@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170424173847.GU7456@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 24, 2017 at 08:38:47PM +0300, Sakari Ailus wrote:
...
> ret won't be zero here, that was checked above. You could check for just ret
> though, it'd be easier to read that way.

I missed ret would have to have type long instead. How about:

ret = PTR_ERR(priv->reset_gpio);
if (!priv->reset_gpio) {
	dev_dbg("reset gpio is not assigned\n");
} else if (IS_ERR(priv->reset_gpio) && ret != -ENOSYS) {
	dev_dbg("error %d while getting reset gpio", ret);
	return ret;
}

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
