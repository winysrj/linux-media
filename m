Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49178 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab1JEOLN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 10:11:13 -0400
Received: by ggnv2 with SMTP id v2so764701ggn.19
        for <linux-media@vger.kernel.org>; Wed, 05 Oct 2011 07:11:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111005134202.GB8614@valkosipuli.localdomain>
References: <51A4F524D105AA4C93787F33E2C90E62EE5203@greysvr02.GreyInnovation.local>
 <201110041350.33441.laurent.pinchart@ideasonboard.com> <1317729252.8358.54.camel@iivanov-desktop>
 <201110041500.56885.laurent.pinchart@ideasonboard.com> <51A4F524D105AA4C93787F33E2C90E62EE5350@greysvr02.GreyInnovation.local>
 <20111005105438.GA8614@valkosipuli.localdomain> <CA+2YH7vRZ9XVT-DMowOnCd0mbTWR6b3drPHAfRjsNuq3m+Kudg@mail.gmail.com>
 <20111005134202.GB8614@valkosipuli.localdomain>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Wed, 5 Oct 2011 16:10:53 +0200
Message-ID: <CAAwP0s0=O4Yzcb6OeqgEwQ7NAscnHzjwgFASAXeS1=_WdCiGUA@mail.gmail.com>
Subject: Re: Help with omap3isp resizing
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Enrico <ebutera@users.berlios.de>,
	Paul Chiha <paul.chiha@greyinnovation.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 5, 2011 at 3:42 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Wed, Oct 05, 2011 at 03:09:48PM +0200, Enrico wrote:
>> On Wed, Oct 5, 2011 at 12:54 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> > On Wed, Oct 05, 2011 at 01:51:29PM +1100, Paul Chiha wrote:
>> >> Thanks for your help. I've updated ispccdc.c to support the _1X16 codes
>> >> and the pipeline seems to work now. However, I needed to take out the
>> >> memcpy in ccdc_try_format(), because otherwise pad 0 format was being
>> >> copied to pad 1 or 2, regardless of what pad 1 or 2 were being set to. I'm
>> >> not sure why it was done that way. I think it's better that the given code
>> >> gets checked to see if it's in the list and if so use it. Do you know of
>> >> any valid reason why this copy is done?
>> >
>> > If I remember corretly, it's because there's nothing the CCDC may do to the
>> > size of the image --- the driver doesn't either support cropping on the
>> > CCDC. The sink format used to be always the same as the source format, the
>> > assumption which no longer is valid when YUYV8_2X8 etc. formats are
>> > supported. This must be taken into account, i.e. YUYV8_2X8 must be converted
>> > to YUYV8_1X16 instead of just copying the format as such.
>>
>> Looking at omap trm (spruf98t, July 2011) figure 12-103 it seems
>> possible to set some registers (start pixel horizontal/vertical and so
>> on...) to crop the "final" image, but i never tested it.
>
> Yeah; cropping should work fine on the CCDC as well but the driver doesn't
> implement it.
>

Hello,

Yes, cropping with the CCDC is possible, we modified the driver to
only get the active lines of a frame. This is a small part of our
patch that configures the CCDC to decide what is the first line to
output to memory for both even and odd fields.

+       if (pdata->is_bt656)
+               if (format->priv == V4L2_STD_PAL)
+                       isp_reg_writel(isp, (PAL_NON_ACTIVE <<
+                                            ISPCCDC_VERT_START_SLV0_SHIFT |
+                                            PAL_NON_ACTIVE <<
+                                            ISPCCDC_VERT_START_SLV1_SHIFT),
+                                      OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_VERT_START);
+               else if (format->priv == V4L2_STD_NTSC)
+                       isp_reg_writel(isp, (NTSC_NON_ACTIVE <<
+                                            ISPCCDC_VERT_START_SLV0_SHIFT |
+                                            NTSC_NON_ACTIVE <<
+                                            ISPCCDC_VERT_START_SLV1_SHIFT),
+                                      OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_VERT_START);


As I told in a previous email [1] we are working to get add proper
support for ITU-R BT656 video data using the ISP and a TVP5151 video
encoder. We are kind of busy to get this working for our tree. But
once it is done, I'll forward port to the last ISP driver and post for
review.

[1]: http://www.spinics.net/lists/linux-media/msg38715.html

Best regards,

> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
