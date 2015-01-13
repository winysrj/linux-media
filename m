Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-243.synserver.de ([212.40.185.243]:1083 "EHLO
	smtp-out-239.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751093AbbAMNDD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 08:03:03 -0500
Message-ID: <54B5177E.4070801@metafoo.de>
Date: Tue, 13 Jan 2015 14:02:54 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: "Mats Randgaard (matrandg)" <matrandg@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 16/16] [media] Add MAINTAINERS entry for the adv7180
References: <1421150481-30230-1-git-send-email-lars@metafoo.de> <1421150481-30230-17-git-send-email-lars@metafoo.de> <54B515DC.6020701@cisco.com>
In-Reply-To: <54B515DC.6020701@cisco.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/13/2015 01:55 PM, Mats Randgaard (matrandg) wrote:
> On 01/13/2015 01:01 PM, Lars-Peter Clausen wrote:
>> Add myself as the maintainer  for the adv7180 video subdev driver.
>  >
>  > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de> --- MAINTAINERS |
>  > 7 +++++++ 1 file changed, 7 insertions(+)
>  >
>  > diff --git a/MAINTAINERS b/MAINTAINERS index 4318f34..22bb77e 100644
>  > --- a/MAINTAINERS +++ b/MAINTAINERS @@ -659,6 +659,13 @@ L:
>  > linux-media@vger.kernel.org S:    Maintained F:
>  > drivers/media/i2c/ad9389b*
>  >
>  > +ANALOG DEVICES INC ADV7180 DRIVER +M:    Lars-Peter Clausen
>  > <lars@metafoo.de> +L:    linux-media@vger.kernel.org +W:
>  > http://ez.analog.com/community/linux-device-drivers
>
> I think the web address should be http://ez.analog.com/community/video
>
> It is written much more about ADV7180 there, and people asking questions
> about video devices has been directed to the Video forum in the past.

Well depends on the subject of the question. If you have a question about 
the Linux device driver the correct section is the Linux device driver 
section. If you have question about the chip itself it should be in the 
video section. But this maintainers entry is about the driver not the chip.

- Lars
