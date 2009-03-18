Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([213.240.235.226]:49426 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbZCRHop (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 03:44:45 -0400
Subject: Re: About white balance control.
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	bill@thedirks.org, Hans Verkuil <hverkuil@xs4all.nl>,
	dongsoo45.kim@samsung.com,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?UTF-8?Q?=EA=B9=80=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>
In-Reply-To: <5e9665e10903172132g2c433879j14b292d8f5c96268@mail.gmail.com>
References: <5e9665e10903172132g2c433879j14b292d8f5c96268@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 09:37:55 +0200
Message-Id: <1237361875.5382.9.camel@iivanov.int.mm-sol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Hi Kim, 

On Wed, 2009-03-18 at 13:32 +0900, Dongsoo, Nathaniel Kim wrote:
> Hello,
> 
> I accidently realized today that I was using white balance control in wrong way.
> 
> As far as I understand we've got
> 
> V4L2_CID_AUTO_WHITE_BALANCE which activate auto white balance
> adjustment in runtime,
> V4L2_CID_DO_WHITE_BALANCE_TEMPERATURE specifying absolute kelvin value
> 
> but can't get what V4L2_CID_DO_WHITE_BALANCE is for.

  My understanding is that V4L2_CID_DO_WHITE_BALANCE enable/disable
  white balance processing, while with 
  V4L2_CID_DO_WHITE_BALANCE_TEMPERATURE you can specify explicitly 
  ambient temperature.
   
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
> 
> And one more thing. If I want to serve several white balance presets,
> like cloudy, dawn, sunny and so on, what should I do?
> I think it should be supported as menu type, but most of drivers are
> using white balance CID with integer type...then what should I do?
> Define preset names with kelvin number like this?

  I also will like to see controls which specify different kind of 
  white balance mode (cloudy, sunny, tungsten...). in this case 
  we can thing about V4L2_CID_WHITE_BALANCE_TEMPERATURE as 'manual'
  mode, and let other modes to be handled by some clever algorithms ;).

  IIvanov


> 
> #define WB_CLOUDY 8000
> 
> Pretty confusing... anyone knows what should I do?
> 
> Nate
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

