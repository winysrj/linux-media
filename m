Return-path: <mchehab@pedra>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:49987 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab0IPIat (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 04:30:49 -0400
To: Jarod Wilson <jarod@redhat.com>
cc: linux-media@vger.kernel.org,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Anders Eriksson <aeriksson@fastmail.fm>,
	Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [PATCH 4/4] IR/imon: set up mce-only devices w/mce keytable
In-reply-to: <20100916052439.GE23299@redhat.com>
References: <20100916051932.GA23299@redhat.com> <20100916052439.GE23299@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 16 Sep 2010 10:11:16 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20100916081116.71A4E45800D@tippex.mynet.homeunix.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>




jarod@redhat.com said:

> +	/* iMON LCD, MCE IR */ 
> +	case 0x9e: 
> +		dev_info(ictx->dev, "0xffdc iMON VFD, MCE IR"); 
> +		detected_display_type = IMON_DISPLAY_TYPE_VFD;
> +		allowed_protos = IR_TYPE_RC6; +		break; 
> +	/* iMON LCD, MCE IR */ +	case 0x9f:
> 

That "LCD" in the comment should be VFD.

/Anders



