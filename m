Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:43881 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbZCTRvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 13:51:38 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1179292rvb.1
        for <linux-media@vger.kernel.org>; Fri, 20 Mar 2009 10:51:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A24693684029E5489D1D202277BE89442E6B1E31@dlee02.ent.ti.com>
References: <d9ec170c0903190659t70ede200w301c0105f7323c7f@mail.gmail.com>
	 <A24693684029E5489D1D202277BE89442E6B1E31@dlee02.ent.ti.com>
Date: Fri, 20 Mar 2009 23:21:36 +0530
Message-ID: <d9ec170c0903201051x731b0fcqbee2633744b45b56@mail.gmail.com>
Subject: Re: ISP Configuration for RAW Bayer sensor
From: Suresh Rao <sureshraomr@gmail.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

Thanks for the update.  Sure, I love to get hands on it.

Regards,
Suresh


On Fri, Mar 20, 2009 at 7:49 AM, Aguirre Rodriguez, Sergio Alberto
<saaguirre@ti.com> wrote:
>
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Suresh Rao
>> Sent: Thursday, March 19, 2009 7:59 AM
>> To: linux-media@vger.kernel.org
>> Cc: Tuukka.O Toivonen
>> Subject: Re: ISP Configuration for RAW Bayer sensor
>>
>> Hi Tuukka,
>>
>> Thanks a lot for the patch, I will try this.
>>
>> I tried similar thing but on the sensor side and it worked, ie., I
>> skip the very first line from readout and get the desired format for
>> the ISP.
>
> Hi Suresh,
>
> I am currently working on a patch for solving these type of adjustments.
>
> The main idea is to specify from the sensor to the ISP, which is the output Raw sequence: RGGB, GRBG, BGGR, GBRG. And then adjust internal ISP reading offset to interpret the image adequately...
>
> I'll post the patch as soon as I have it ready (I'm currently busy with some other higher priority tasks for these remaining 2 weeks of the month :I)
>
> Regards,
> Sergio
>>
>> Thanks,
>> Suresh
>>
>> On Thu, Mar 19, 2009 at 1:12 PM, Tuukka.O Toivonen
>> <tuukka.o.toivonen@nokia.com> wrote:
>> > On Wednesday 18 March 2009 18:17:56 ext Suresh Rao wrote:
>> >> I am working with MT9V023 RAW sensor.  The data format from the sensor
>> is
>> >>
>> >> B G B G B G B G ...
>> >> G R G R G R G R ...
>> >> B G B G B G B G ...
>> >> G R G R G R G R ........      [ Format 1]
>> > [...]
>> >> I want to use the ISP on the OMAP for doing interpolation and format
>> >> conversion to UYVY.  I am able to capture the images from the sensor,
>> >> however I notice that the color information is missing.  I dug the
>> >> sources and found that in the RAW capture mode ISP is getting
>> >> configured to input format
>> >>
>> >> G R G R G R G R ...
>> >> B G B G B G B G ...
>> >> G R G R G R G R ...
>> >> B G B G B G B G ...          [Format 2]
>> >>
>> >> Has anyone tried sensors with BGGR ( Format 1) on OMAP?
>> >>
>> >> Can anyone give me some pointers or information on how to configure
>> >> ISP for BGGR (Format 1)
>> >
>> > If you can live with losing a few pixels (maybe sensor has a few extra)
>> > I recommend to configure ISP to crop away the topmost line.
>> >
>> > Here's couple of old _example_ patches how to configure the cropping.
>> > Just gives an idea where to start...
>> >
>> > - Tuukka
>> >
>> >
>> > diff --git a/drivers/media/video/isp/ispccdc.c
>> b/drivers/media/video/isp/ispccdc.c
>> > index 2288bc9..87870f1 100644
>> > --- a/drivers/media/video/isp/ispccdc.c
>> > +++ b/drivers/media/video/isp/ispccdc.c
>> > @@ -1189,13 +1189,13 @@ int ispccdc_config_size(u32 input_w, u32 input_h,
>> u32 output_w, u32 output_h)
>> >                                                ISPCCDC_HORZ_INFO);
>> >                } else {
>> >                        if (ispccdc_obj.ccdc_inpfmt == CCDC_RAW) {
>> > -                               omap_writel(1 <<
>> ISPCCDC_HORZ_INFO_SPH_SHIFT
>> > -                                               |
>> ((ispccdc_obj.ccdcout_w - 1)
>> > +                               omap_writel(0 <<
>> ISPCCDC_HORZ_INFO_SPH_SHIFT
>> > +                                               | (ispccdc_obj.ccdcout_w
>> >                                                <<
>> ISPCCDC_HORZ_INFO_NPH_SHIFT),
>> >                                                ISPCCDC_HORZ_INFO);
>> >                        } else {
>> >                                omap_writel(0 <<
>> ISPCCDC_HORZ_INFO_SPH_SHIFT
>> > -                                               |
>> ((ispccdc_obj.ccdcout_w - 1)
>> > +                                               | (ispccdc_obj.ccdcout_w
>> >                                                <<
>> ISPCCDC_HORZ_INFO_NPH_SHIFT),
>> >                                                ISPCCDC_HORZ_INFO);
>> >                        }
>> > @@ -1227,7 +1227,7 @@ int ispccdc_config_size(u32 input_w, u32 input_h,
>> u32 output_w, u32 output_h)
>> >                                        ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
>> >                                        ISPCCDC_VP_OUT);
>> >                omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
>> > -                                       ((ispccdc_obj.ccdcout_w - 1) <<
>> > +                                       (ispccdc_obj.ccdcout_w <<
>> >                                        ISPCCDC_HORZ_INFO_NPH_SHIFT),
>> >                                        ISPCCDC_HORZ_INFO);
>> >                omap_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
>> > diff --git a/drivers/media/video/isp/ispccdc.c
>> > b/drivers/media/video/isp/ispccdc.c
>> > index f5957b2..6afaabf 100644
>> > --- a/drivers/media/video/isp/ispccdc.c
>> > +++ b/drivers/media/video/isp/ispccdc.c
>> > @@ -478,7 +478,7 @@ EXPORT_SYMBOL(ispccdc_enable_lsc);
>> >   **/
>> >  void ispccdc_config_crop(u32 left, u32 top, u32 height, u32 width)
>> >  {
>> > -       ispccdc_obj.ccdcin_woffset = left + ((left + 1) % 2);
>> > +       ispccdc_obj.ccdcin_woffset = left + (left % 2);
>> >         ispccdc_obj.ccdcin_hoffset = top + (top % 2);
>> >
>> >         ispccdc_obj.crop_w = width - (width % 16);
>> > @@ -1166,7 +1166,7 @@ int ispccdc_config_size(u32 input_w, u32 input_h,
>> > u32 output_w, u32 output_h)
>> >                                         ISPCCDC_FMT_VERT);
>> >                 omap_writel((ispccdc_obj.ccdcout_w <<
>> >                                         ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
>> > -                                       (ispccdc_obj.ccdcout_h <<
>> > +                                       (ispccdc_obj.ccdcout_h - 1 <<
>> >                                         ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
>> >                                         ISPCCDC_VP_OUT);
>> >                 omap_writel((((ispccdc_obj.ccdcout_h - 25) &
>> >
>> >
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
