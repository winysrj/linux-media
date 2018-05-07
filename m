Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:32888 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753027AbeEGUgr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 16:36:47 -0400
MIME-Version: 1.0
In-Reply-To: <20180507131906.rdvcmvim5gvi5odk@valkosipuli.retiisi.org.uk>
References: <20180425213044.1535393-1-arnd@arndb.de> <2922276.lKgGZtlCEW@avalon>
 <20180507131906.rdvcmvim5gvi5odk@valkosipuli.retiisi.org.uk>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 7 May 2018 16:36:45 -0400
Message-ID: <CAK8P3a2+Xi8VF7B40zev1CT55HCNE92+MsPEiaGj7tOXEV57dg@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] [media] omap3isp: support 64-bit version of omap3isp_stat_data
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 7, 2018 at 9:19 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Mon, May 07, 2018 at 04:17:32PM +0300, Laurent Pinchart wrote:
>> On Thursday, 26 April 2018 00:30:10 EEST Arnd Bergmann wrote:
>> > +int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
>> > +                                   struct omap3isp_stat_data_time32 *data)
>> > +{
>> > +   struct omap3isp_stat_data data64;
>> > +   int ret;
>> > +
>> > +   ret = omap3isp_stat_request_statistics(stat, &data64);
>> > +
>> > +   data->ts.tv_sec = data64.ts.tv_sec;
>> > +   data->ts.tv_usec = data64.ts.tv_usec;
>> > +   memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
>> > +
>> > +   return ret;
>>
>> We could return immediately after omap3isp_stat_request_statistics() if the
>> function fails, but that's no big deal, the error path is clearly a cold path.

I looked at it again and briefly thought that it would leak kernel stack
data in my version and changing it would be required to avoid that,
but I do see now that the absence of the INFO_FL_ALWAYS_COPY
flag makes it safe after all.

I agree that returning early here would be nicer here, I'll leave it up to
Sakari to fold in that change if he likes.

>> > @@ -165,7 +167,14 @@ struct omap3isp_h3a_aewb_config {
>> >   * @config_counter: Number of the configuration associated with the data.
>> >   */
>> >  struct omap3isp_stat_data {
>> > +#ifdef __KERNEL__
>> > +   struct {
>> > +           __s64   tv_sec;
>> > +           __s64   tv_usec;
>> > +   } ts;
>>
>> I share Sakari's comment about this method implying a little-endian system,
>> but as the SoCs that integrate this device are all little-endian, that's not a
>> problem in practice.

To clarify: the version I have here does *not* imply a little-endian system,
it is supposed to work on both little-endian and big-endian builds, and
endianess is not a property of the SoC either -- you should be able to
build a big-endian kernel and run it on OMAP3 (aside from bugs in other
drivers). Using 'long' here instead of __s64 would however make this
interface broken on big-endian builds since the glibc definition of timeval
does include extra padding on big-endian machines to make the structure
compatible between 32-bit and 64-bit ABIs.

>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>
>> If you agree with the small comment about header ordering, let's get this
>> patch finally merged.
>
> I can make the change locally in my tree, no need to resend.
>
> Thanks.

Thanks a lot!
