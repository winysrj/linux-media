Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:17582 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbbAMMzy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 07:55:54 -0500
Message-ID: <54B515DC.6020701@cisco.com>
Date: Tue, 13 Jan 2015 13:55:56 +0100
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 16/16] [media] Add MAINTAINERS entry for the adv7180
References: <1421150481-30230-1-git-send-email-lars@metafoo.de> <1421150481-30230-17-git-send-email-lars@metafoo.de>
In-Reply-To: <1421150481-30230-17-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/13/2015 01:01 PM, Lars-Peter Clausen wrote:
> Add myself as the maintainer  for the adv7180 video subdev driver.
 >
 > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de> --- MAINTAINERS |
 > 7 +++++++ 1 file changed, 7 insertions(+)
 >
 > diff --git a/MAINTAINERS b/MAINTAINERS index 4318f34..22bb77e 100644
 > --- a/MAINTAINERS +++ b/MAINTAINERS @@ -659,6 +659,13 @@ L:
 > linux-media@vger.kernel.org S:    Maintained F:
 > drivers/media/i2c/ad9389b*
 >
 > +ANALOG DEVICES INC ADV7180 DRIVER +M:    Lars-Peter Clausen
 > <lars@metafoo.de> +L:    linux-media@vger.kernel.org +W:
 > http://ez.analog.com/community/linux-device-drivers

I think the web address should be http://ez.analog.com/community/video

It is written much more about ADV7180 there, and people asking questions 
about video devices has been directed to the Video forum in the past.

Regards,

Mats Randgaard

>
 > +S:    Supported +F:    drivers/media/i2c/adv7180.c + ANALOG DEVICES INC
 > ADV7511 DRIVER M:    Hans Verkuil <hans.verkuil@cisco.com> L:
 > linux-media@vger.kernel.org


