Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33818 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752954AbeEHAIy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 20:08:54 -0400
MIME-Version: 1.0
In-Reply-To: <20180507213305.kfxabgkdvf7xwt7m@valkosipuli.retiisi.org.uk>
References: <20180425213044.1535393-1-arnd@arndb.de> <2922276.lKgGZtlCEW@avalon>
 <20180507131906.rdvcmvim5gvi5odk@valkosipuli.retiisi.org.uk>
 <CAK8P3a2+Xi8VF7B40zev1CT55HCNE92+MsPEiaGj7tOXEV57dg@mail.gmail.com> <20180507213305.kfxabgkdvf7xwt7m@valkosipuli.retiisi.org.uk>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 7 May 2018 20:08:53 -0400
Message-ID: <CAK8P3a3k5VMmZWuqqgCRTTgE4Ffct_reVJi5Tt8hkvTUUaDFow@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] [media] omap3isp: support 64-bit version of omap3isp_stat_data
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 7, 2018 at 5:33 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Mon, May 07, 2018 at 04:36:45PM -0400, Arnd Bergmann wrote:
>> On Mon, May 7, 2018 at 9:19 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> > On Mon, May 07, 2018 at 04:17:32PM +0300, Laurent Pinchart wrote:
>> >> On Thursday, 26 April 2018 00:30:10 EEST Arnd Bergmann wrote:
>> >> > +int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
>> >> > +                                   struct omap3isp_stat_data_time32 *data)
>> >> > +{
>> >> > +   struct omap3isp_stat_data data64;
>> >> > +   int ret;
>> >> > +
>> >> > +   ret = omap3isp_stat_request_statistics(stat, &data64);
>> >> > +
>> >> > +   data->ts.tv_sec = data64.ts.tv_sec;
>> >> > +   data->ts.tv_usec = data64.ts.tv_usec;
>> >> > +   memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
>> >> > +
>> >> > +   return ret;
>> >>
>> >> We could return immediately after omap3isp_stat_request_statistics() if the
>> >> function fails, but that's no big deal, the error path is clearly a cold path.
>>
>> I looked at it again and briefly thought that it would leak kernel stack
>> data in my version and changing it would be required to avoid that,
>> but I do see now that the absence of the INFO_FL_ALWAYS_COPY
>> flag makes it safe after all.
>>
>> I agree that returning early here would be nicer here, I'll leave it up to
>> Sakari to fold in that change if he likes.
>
> I agree with the change; actually the data64 struct will be left untouched
> if there's an error so changing this doesn't seem to make a difference.
> Private IOCTLs have always_copy == false, so the argument struct isn't
> copied back to the kernel.
>
> The diff is here. Let me know if something went wrong...
>
> diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
> index dfee8eaf2226..47353fee26c3 100644
> --- a/drivers/media/platform/omap3isp/ispstat.c
> +++ b/drivers/media/platform/omap3isp/ispstat.c
> @@ -519,12 +519,14 @@ int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
>         int ret;
>
>         ret = omap3isp_stat_request_statistics(stat, &data64);
> +       if (ret)
> +               return ret;
>
>         data->ts.tv_sec = data64.ts.tv_sec;
>         data->ts.tv_usec = data64.ts.tv_usec;
>         memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
>
> -       return ret;
> +       return 0;
>  }

Yes, that's exactly what I had in mind. Thanks for fixing it up!

      Arnd
