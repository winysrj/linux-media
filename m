Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64980 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785Ab2HIOe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 10:34:29 -0400
Received: by qcro28 with SMTP id o28so275493qcr.19
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2012 07:34:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5023A770.5080604@redhat.com>
References: <1344352315-1184-1-git-send-email-kradlow@cisco.com>
	<3bb2b81ed5c186756c83b9136b5aa43005d728a2.1344352285.git.kradlow@cisco.com>
	<5023A770.5080604@redhat.com>
Date: Thu, 9 Aug 2012 14:34:28 +0000
Message-ID: <CAFomkUCsxjLjXYm1+Y6mK7CSfY1hMe+81+eq4cbYAhofY-HT8w@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] Add rds-ctl tool (with changes proposed in RFC)
From: Konke Radlow <koradlow@googlemail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl, koradlow@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 9, 2012 at 12:05 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
> Comments inline.
>
>
> On 08/07/2012 05:11 PM, Konke Radlow wrote:
>>
>> ---
>>   Makefile.am               |    3 +-
>>   configure.ac              |    1 +
>>   utils/rds-ctl/Makefile.am |    5 +
>>   utils/rds-ctl/rds-ctl.cpp |  959
>> +++++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 967 insertions(+), 1 deletion(-)
>>   create mode 100644 utils/rds-ctl/Makefile.am
>>   create mode 100644 utils/rds-ctl/rds-ctl.cpp
>>
>> diff --git a/Makefile.am b/Makefile.am
>> index 621d8d9..8ef0d00 100644
>> --- a/Makefile.am
>> +++ b/Makefile.am
>
>
> <Snip>
>
>
>> +static void print_rds_data(const struct v4l2_rds *handle, uint32_t
>> updated_fields)
>> +{
>> +       if (params.options[OptPrintBlock])
>> +               updated_fields = 0xffffffff;
>> +
>> +       if ((updated_fields & V4L2_RDS_PI) &&
>> +                       (handle->valid_fields & V4L2_RDS_PI)) {
>> +               printf("\nPI: %04x", handle->pi);
>> +               print_rds_pi(handle);
>> +       }
>> +
>> +       if (updated_fields & V4L2_RDS_PS &&
>> +                       handle->valid_fields & V4L2_RDS_PS) {
>> +               printf("\nPS: ");
>> +               for (int i = 0; i < 8; ++i) {
>> +                       /* filter out special characters */
>> +                       if (handle->ps[i] >= 0x20 && handle->ps[i] <=
>> 0x7E)
>> +                               printf("%lc",handle->ps[i]);
>> +                       else
>> +                               printf(" ");
>> +               }
>
>
>
> Since ps now is a 0 terminated UTF-8 string you should be able to just do:
>                 printf("\nPS: %s", handle->ps);
>
> And likewise for the other strings.
>

changed as proposed, and works like a charm :)

>
>
> Other then that this looks good to me.
>
> Regards,
>
> Hans

thank you for the review

Regards,
Konke
