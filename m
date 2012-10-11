Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53740 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756793Ab2JKWc5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 18:32:57 -0400
Date: Fri, 12 Oct 2012 01:32:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Multiple Rectangle cropping
Message-ID: <20121011223252.GR14107@valkosipuli.retiisi.org.uk>
References: <CAPybu_1z8kam1e6ArT9gyX+qybW+6s1K1VdJikuWoYPMjA3q2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_1z8kam1e6ArT9gyX+qybW+6s1K1VdJikuWoYPMjA3q2Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Thu, Oct 11, 2012 at 12:40:03PM +0200, Ricardo Ribalda Delgado wrote:
> I want to port an old driver for an fpga based camera to the new media
> infrastructure.
> 
> By reading the doc. I think it has almost all the capabilities needed.
> The only one I am missing is the habilty to select multiple rectangles
> from the sensor. ie: I have a 100x50 sensor and I want a 100x20 image
> with the pixels from 0,0->100,10 and then 0,40->100,50
> 
> Any suggestion about how to implement this with the media api?

I suppose your FPGA does the cropping. You can use the V4L2 subdev selection
interface and crop on the source pads. Each will then have a link to a
capture video device.

<URL:http://hverkuil.home.xs4all.nl/spec/media.html#subdev>

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
