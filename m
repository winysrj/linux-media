Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:63618 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab0GSH4Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 03:56:24 -0400
Subject: Re: [PATCH v4 1/5] V4L2: Add seek spacing and FM RX class.
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	Valentin Eduardo <eduardo.valentin@nokia.com>
In-Reply-To: <4C328ED6.1070705@redhat.com>
References: <1275647663-20650-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1275647663-20650-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <4C328ED6.1070705@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 10:55:13 +0300
Message-ID: <1279526113.15203.12.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.


On Tue, 2010-07-06 at 04:03 +0200, ext Mauro Carvalho Chehab wrote:
> Em 04-06-2010 07:34, Matti J. Aaltonen escreveu:
> > +
> > +#define V4L2_CID_FM_RX_BAND			(V4L2_CID_FM_TX_CLASS_BASE + 1)
> > +enum v4l2_fm_rx_band {
> > +	V4L2_FM_BAND_OTHER		= 0,
> > +	V4L2_FM_BAND_JAPAN		= 1,
> > +	V4L2_FM_BAND_OIRT		= 2
> > +};
> 
> 
> You don't need anything special to define the bandwidth. VIDIOC_G_TUNER/VIDIOC_S_TUNER allows
> negotiating rangelow/rangehigh.

I don't quite get how you want this to be done... Are you saying that
this enum should not be there? At least the wl1273 chip actually
supports two bands so it would seem more straightforward to start by
defining the band and working from there than the other way round. 

B.R. 
Matti A.

> 
> > +
> >  /*
> >   *	T U N I N G
> >   */
> > @@ -1377,7 +1389,8 @@ struct v4l2_hw_freq_seek {
> >  	enum v4l2_tuner_type  type;
> >  	__u32		      seek_upward;
> >  	__u32		      wrap_around;
> > -	__u32		      reserved[8];
> > +	__u32		      spacing;
> > +	__u32		      reserved[7];
> >  };
> >  
> >  /*
> 
> I can't comment on your other API proposals, as you didn't send a patch documenting it
> at the API spec.
> 
> Cheers,
> Mauro.


