Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41598 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751244AbcBYVwP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2016 16:52:15 -0500
Date: Thu, 25 Feb 2016 23:52:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v5 4/4] media-ctl: List supported media bus formats
Message-ID: <20160225215211.GF11084@valkosipuli.retiisi.org.uk>
References: <1456331128-7036-1-git-send-email-sakari.ailus@linux.intel.com>
 <1456331128-7036-5-git-send-email-sakari.ailus@linux.intel.com>
 <7141573.SjGf7uf7rF@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7141573.SjGf7uf7rF@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Feb 25, 2016 at 11:38:02PM +0200, Laurent Pinchart wrote:
...
> > +static void list_known_mbus_formats(void)
> > +{
> > +	unsigned int ncodes;
> > +	const unsigned int *code = v4l2_subdev_pixelcode_list(&ncodes);
> > +
> > +	while (ncodes--) {
> > +		const char *str = v4l2_subdev_pixelcode_to_string(*code);
> > +		int spaces = 30 - (int)strlen(str);
> > +
> > +		if (*code == 0)
> > +			break;
> > +
> > +		if (spaces < 0)
> > +			spaces = 0;
> > +
> > +		printf("%s %*c 0x%8.8x\n", str, spaces, ' ', *code);
> > +
> > +		code++;
> > +	}
> > +}

I remember I intended to change s/8\.8/4.4/ but I forgot to do that to this
version. I'll resubmit.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
