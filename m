Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:59925 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab2EERTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 13:19:17 -0400
Date: Sat, 5 May 2012 19:20:24 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/7] gspca: allow subdrivers to use the control
 framework.
Message-ID: <20120505192024.2bdc1023@tele>
In-Reply-To: <4FA54052.1090009@redhat.com>
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
	<201205051034.30484.hverkuil@xs4all.nl>
	<4FA53D48.6020004@redhat.com>
	<201205051650.03626.hverkuil@xs4all.nl>
	<4FA54052.1090009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 05 May 2012 16:59:30 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> > Unless there is another good reason for doing the probing in sd_init I prefer
> > to move it to sd_config.  
> 
> Sensor probing does more then just sensor probing, it also configures
> things like the i2c clockrate, and if the bus between bridge and sensor
> is spi / i2c or 3-wire, or whatever ...
> 
> After a suspend resume all bets are of wrt bridge state, so we prefer to
> always do a full re-init as we do on initial probe, so that we (hopefully)
> will put the bridge back in a sane state.
> 
> I think moving the probing from init to config is a bad idea, the chance
> that we will get regressions (after a suspend/resume) from this are too
> big IMHO.

Moving the sensor probing to sd_config is normally safe because the
init sequences which are sent actually after probing do all the
re-initialization job. An easy way to know it in zc3xx is to force the
sensor via the module parameter.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
