Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:47639 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752180AbeB0Hcg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 02:32:36 -0500
Subject: Re: [PATCH v2] Staging: bcm2048: Fix function argument alignment in
 radio-bcm2048.c.
To: Quytelda Kahja <quytelda@tamalin.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <20180219072550.hz4vpomsaz2ajrnm@mwanda>
 <20180220065304.8943-1-quytelda@tamalin.org>
 <cb62e915-eb9c-9252-1f0a-cc85c8ea3530@xs4all.nl>
 <CAFLvi2357U3HAt3mXDdNdZs4QA9mqWntTny4XyvtSfV2hu1dmA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7c9787b2-bad3-21d9-f726-e171d9af940d@xs4all.nl>
Date: Tue, 27 Feb 2018 08:32:30 +0100
MIME-Version: 1.0
In-Reply-To: <CAFLvi2357U3HAt3mXDdNdZs4QA9mqWntTny4XyvtSfV2hu1dmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/27/2018 02:53 AM, Quytelda Kahja wrote:
> Hans,
> 
> Thank you very much for your input on the patch; however this patch
> has already been applied to the staging tree.  Additionally:

I have no record of this being applied through linux-media. Did someone
else pick this up? Greg perhaps?

>> What coding style problem? You should give a short description of
>> what you are fixing.
> The subject of the patch (which becomes the subject of the email when
> using `git format-patch`) describes the change more fully: "Staging:
> bcm2048: Fix function argument alignment in radio-bcm2048.c".  It's a
> really trivial patch, so there's not too much to say.  That extra
> comment is just redundant, I suppose.

Usually you just show the warnings that gcc or sparse or whatever
produced.

> 
>> Just drop this change: it will replace one warning (non-aligned) with
>> another (> 80 cols).
> Breaking the 80 character line limit is arguably excusable for this
> code because of the 36 character function name and 30 character
> constant name; additionally, it has been said that the 80 character
> line limit will probably be increased in the future since we run
> modern machines that aren't limited to 80 character terminals anymore,
> so this warning may soon be irrelevant anyway.

I know people who would be very annoyed if the 80 char limit is lifted.

Anyway, in the end you look at whether a patch is worth it or not,
and this part isn't.

But if it is already applied by someone then this is all moot.

Regards,

	Hans

> 
> Thank you,
> Quytelda Kahja
> 
> On Mon, Feb 26, 2018 at 5:51 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 02/20/2018 07:53 AM, Quytelda Kahja wrote:
>>> Fix a coding style problem.
>>
>> What coding style problem? You should give a short description of
>> what you are fixing.
>>
>>>
>>> Signed-off-by: Quytelda Kahja <quytelda@tamalin.org>
>>> ---
>>> This is the patch without the unnecessary fixes for line length.
>>>
>>>  drivers/staging/media/bcm2048/radio-bcm2048.c | 22 +++++++++++-----------
>>>  1 file changed, 11 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
>>> index 06d1920150da..f38a4f2acdde 100644
>>> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
>>> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
>>> @@ -1864,7 +1864,7 @@ static int bcm2048_probe(struct bcm2048_device *bdev)
>>>               goto unlock;
>>>
>>>       err = bcm2048_set_fm_search_rssi_threshold(bdev,
>>> -                                     BCM2048_DEFAULT_RSSI_THRESHOLD);
>>> +                                                BCM2048_DEFAULT_RSSI_THRESHOLD);
>>>       if (err < 0)
>>>               goto unlock;
>>>
>>
>> Just drop this change: it will replace one warning (non-aligned) with
>> another (> 80 cols).
>>
>> This code is fine as it is.
>>
>> Regards,
>>
>>         Hans
>>
>>> @@ -1942,9 +1942,9 @@ static irqreturn_t bcm2048_handler(int irq, void *dev)
>>>   */
>>>  #define property_write(prop, type, mask, check)                              \
>>>  static ssize_t bcm2048_##prop##_write(struct device *dev,            \
>>> -                                     struct device_attribute *attr,  \
>>> -                                     const char *buf,                \
>>> -                                     size_t count)                   \
>>> +                                   struct device_attribute *attr,    \
>>> +                                   const char *buf,                  \
>>> +                                   size_t count)                     \
>>>  {                                                                    \
>>>       struct bcm2048_device *bdev = dev_get_drvdata(dev);             \
>>>       type value;                                                     \
>>> @@ -1966,8 +1966,8 @@ static ssize_t bcm2048_##prop##_write(struct device *dev,               \
>>>
>>>  #define property_read(prop, mask)                                    \
>>>  static ssize_t bcm2048_##prop##_read(struct device *dev,             \
>>> -                                     struct device_attribute *attr,  \
>>> -                                     char *buf)                      \
>>> +                                  struct device_attribute *attr,     \
>>> +                                  char *buf)                         \
>>>  {                                                                    \
>>>       struct bcm2048_device *bdev = dev_get_drvdata(dev);             \
>>>       int value;                                                      \
>>> @@ -1985,8 +1985,8 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,                \
>>>
>>>  #define property_signed_read(prop, size, mask)                               \
>>>  static ssize_t bcm2048_##prop##_read(struct device *dev,             \
>>> -                                     struct device_attribute *attr,  \
>>> -                                     char *buf)                      \
>>> +                                  struct device_attribute *attr,     \
>>> +                                  char *buf)                         \
>>>  {                                                                    \
>>>       struct bcm2048_device *bdev = dev_get_drvdata(dev);             \
>>>       size value;                                                     \
>>> @@ -2005,8 +2005,8 @@ property_read(prop, mask)                                               \
>>>
>>>  #define property_str_read(prop, size)                                        \
>>>  static ssize_t bcm2048_##prop##_read(struct device *dev,             \
>>> -                                     struct device_attribute *attr,  \
>>> -                                     char *buf)                      \
>>> +                                  struct device_attribute *attr,     \
>>> +                                  char *buf)                         \
>>>  {                                                                    \
>>>       struct bcm2048_device *bdev = dev_get_drvdata(dev);             \
>>>       int count;                                                      \
>>> @@ -2175,7 +2175,7 @@ static int bcm2048_fops_release(struct file *file)
>>>  }
>>>
>>>  static __poll_t bcm2048_fops_poll(struct file *file,
>>> -                                   struct poll_table_struct *pts)
>>> +                               struct poll_table_struct *pts)
>>>  {
>>>       struct bcm2048_device *bdev = video_drvdata(file);
>>>       __poll_t retval = 0;
>>>
>>
