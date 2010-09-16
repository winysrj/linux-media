Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab0IPNbU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 09:31:20 -0400
Date: Thu, 16 Sep 2010 09:30:57 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: linux-media@vger.kernel.org,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [PATCH 4/4] IR/imon: set up mce-only devices w/mce keytable
Message-ID: <20100916133057.GA29829@redhat.com>
References: <20100916051932.GA23299@redhat.com>
 <20100916052439.GE23299@redhat.com>
 <20100916081116.71A4E45800D@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916081116.71A4E45800D@tippex.mynet.homeunix.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Sep 16, 2010 at 10:11:16AM +0200, Anders Eriksson wrote:
> 
> 
> 
> jarod@redhat.com said:
> 
> > +	/* iMON LCD, MCE IR */ 
> > +	case 0x9e: 
> > +		dev_info(ictx->dev, "0xffdc iMON VFD, MCE IR"); 
> > +		detected_display_type = IMON_DISPLAY_TYPE_VFD;
> > +		allowed_protos = IR_TYPE_RC6; +		break; 
> > +	/* iMON LCD, MCE IR */ +	case 0x9f:
> > 
> 
> That "LCD" in the comment should be VFD.

Ah, dammit, copy-paste fail. Will fix, thanks!

-- 
Jarod Wilson
jarod@redhat.com

