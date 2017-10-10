Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43090 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755064AbdJJI4Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 04:56:25 -0400
Date: Tue, 10 Oct 2017 11:56:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v7 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20171010085623.2s5qiep752hosugn@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
 <047245414a82a6553361b1dd3497f796855a657d.1506550930.git.mchehab@s-opensource.com>
 <20171006102229.evjyn77udfcc76gs@valkosipuli.retiisi.org.uk>
 <20171010053004.2d97795a@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010053004.2d97795a@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 10, 2017 at 05:30:04AM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 6 Oct 2017 13:22:29 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > > +    Bridge driver
> > > +	The same as V4L2 main driver.  
> > 
> > Not all V4L2 main drivers can be bridge drivers. Mem-to-mem devices, for
> > instance. How about:
> > 
> > A driver for a device receiving image data from another device (or
> > transmitting it to a sub-device) controlled by a sub-device driver. Bridge
> > drivers typically act as V4L2 main drivers.
> 
> That is not true for some device drivers we have.
> 
> The GSPCA drivers are bridge drivers, but they don't use any sub-device
> (well, it should, but nobody will redesign it, as the efforts would
> be huge, for a very little gain). Also uvcdriver doesn't need sub-device
> drivers, as the camera's internal firmware does the interface with the
> sensors.
> 
> We could, instead define it as:
> 
>     Bridge driver
> 	A driver that provides a bridge between the CPU's bus to the
> 	data and control buses of a media hardware. Often, the
> 	bridge driver is the same as V4L2 main driver.

Looks good to me.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
