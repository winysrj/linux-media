Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:19426 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbZCRK3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 06:29:14 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: Re: About white balance control.
Date: Wed, 18 Mar 2009 11:29:51 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	bill@thedirks.org, Hans Verkuil <hverkuil@xs4all.nl>,
	dongsoo45.kim@samsung.com,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?utf-8?q?=EA=B9=80=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>
References: <5e9665e10903172132g2c433879j14b292d8f5c96268@mail.gmail.com>
In-Reply-To: <5e9665e10903172132g2c433879j14b292d8f5c96268@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903181129.52130.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kim,

On Wednesday 18 March 2009 05:32:08 Dongsoo, Nathaniel Kim wrote:
> Hello,
>
> I accidently realized today that I was using white balance control in wrong
> way.
>
> As far as I understand we've got
>
> V4L2_CID_AUTO_WHITE_BALANCE which activate auto white balance
> adjustment in runtime, V4L2_CID_DO_WHITE_BALANCE_TEMPERATURE specifying
> absolute kelvin value

I suppose you mean V4L2_CID_WHITE_BALANCE_TEMPERATURE here.

> but can't get what V4L2_CID_DO_WHITE_BALANCE is for.
>
> I think after issuing V4L2_CID_AUTO_WHITE_BALANCE and
> V4L2_CID_WHITE_BALANCE_TEMPERATURE,
> the white balance functionality works immediately. Isn't it right?
>
> What exactly is the button type V4L2_CID_DO_WHITE_BALANCE for? Because
> the V4L2 API document says that "(the value is ignored)". Does that
> mean that even we have issued V4L2_CID_AUTO_WHITE_BALANCE and
> V4L2_CID_WHITE_BALANCE_TEMPERATURE, we can't see the white balance
> working at that moment?

V4L2_CID_AUTO_WHITE_BALANCE to enables or disables automatic white balance 
adjustment. When automatic white balance is enabled the device adjusts the 
white balance continuously.

V4L2_CID_WHITE_BALANCE_TEMPERATURE controls the white balance adjustment 
manually. The control is only effective when automatic white balance is 
disabled.

V4L2_CID_DO_WHITE_BALANCE instructs the device to run the automatic white 
balance adjustment algorithm once and use the results for white balance 
correction. It only makes sense when automatic white balance is disabled.

> And one more thing. If I want to serve several white balance presets,
> like cloudy, dawn, sunny and so on, what should I do?
> I think it should be supported as menu type, but most of drivers are
> using white balance CID with integer type...then what should I do?
> Define preset names with kelvin number like this?
>
> #define WB_CLOUDY 8000
>
> Pretty confusing... anyone knows what should I do?

Best regards,

Laurent Pinchart

