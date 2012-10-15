Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54751 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754671Ab2JOUvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 16:51:10 -0400
Date: Mon, 15 Oct 2012 23:50:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Multiple Rectangle cropping
Message-ID: <20121015205055.GH21261@valkosipuli.retiisi.org.uk>
References: <CAPybu_1z8kam1e6ArT9gyX+qybW+6s1K1VdJikuWoYPMjA3q2Q@mail.gmail.com>
 <20121011223252.GR14107@valkosipuli.retiisi.org.uk>
 <CAPybu_1HiH69Cf1ORDaEHWWaeTFUMvntLGqa__JS4fE4=B67NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_1HiH69Cf1ORDaEHWWaeTFUMvntLGqa__JS4fE4=B67NQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Fri, Oct 12, 2012 at 09:18:42AM +0200, Ricardo Ribalda Delgado wrote:
> In fact, is the sensor, the one that supports multiple Areas of
> Interest. Unfortunatelly the userland v4l2 api only supports one area
> of interest for doing croping (or that is what I believe).
> 
> Is there any plan to support multiple AOI? or I have to make my own ioctl?

As a result, do you get two separate streams out of the device, or something
else? This is what I'd assume to get if I had two cropping rectangles.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
