Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:50710 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab2EERW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 13:22:56 -0400
Date: Sat, 5 May 2012 19:24:05 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/7] gspca: allow subdrivers to use the control
 framework.
Message-ID: <20120505192405.18bb588e@tele>
In-Reply-To: <4FA541B8.4080507@redhat.com>
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
	<ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
	<4FA4DA05.5030001@redhat.com>
	<201205051114.31531.hverkuil@xs4all.nl>
	<4FA53CD2.1010706@redhat.com>
	<4FA541B8.4080507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 05 May 2012 17:05:28 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> > Now I see that we are doing exactly that in for example vidioc_g_jpegcomp in gspca.c, so
> > we should stop doing that. We can make vidioc_g/s_jpegcomp only do the usb locking if
> > gspca_dev->vdev.ctrl_handler == NULL, and once all sub drivers are converted simply remove
> > it. Actually I'm thinking about making the jpegqual control part of the gspca_dev struct
> > itself and move all handling of vidioc_g/s_jpegcomp out of the sub drivers and into
> > the core.  
> 
> Here is an updated version of this patch implementing this approach for
> vidioc_g/s_jpegcomp. We may need to do something similar in other places, although I cannot
> think of any such places atm,

As the JPEG parameters have been redefined as standard controls, and as
there should be only a very few applications which use it, I think the
vidioc_g/s_jpegcomp code could be fully removed.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
