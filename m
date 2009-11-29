Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:42912 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZK2RlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 12:41:17 -0500
MIME-Version: 1.0
In-Reply-To: <20091129171726.GB4993@kroah.com>
References: <20091127013217.7671.32355.stgit@terra>
	 <20091127013423.7671.36546.stgit@terra>
	 <20091129171726.GB4993@kroah.com>
Date: Sun, 29 Nov 2009 12:41:22 -0500
Message-ID: <9e4733910911290941o761a4dfhf4168e573c6b6e89@mail.gmail.com>
Subject: Re: [IR-RFC PATCH v4 2/6] Core IR module
From: Jon Smirl <jonsmirl@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 29, 2009 at 12:17 PM, Greg KH <greg@kroah.com> wrote:
>> +static ssize_t ir_raw_show(struct device *dev,
>> +                              struct device_attribute *attr, char *buf)
>> +{
>> +     struct input_dev *input_dev = to_input_dev(dev);
>> +     unsigned int i, count = 0;
>> +
>> +     for (i = input_dev->ir->raw.tail; i != input_dev->ir->raw.head; ) {
>> +
>> +             count += snprintf(&buf[count], PAGE_SIZE - 1, "%i\n", input_dev->ir->raw.buffer[i++]);
>> +             if (i > ARRAY_SIZE(input_dev->ir->raw.buffer))
>> +                     i = 0;
>> +             if (count >= PAGE_SIZE - 1) {
>> +                     input_dev->ir->raw.tail = i;
>> +                     return PAGE_SIZE - 1;
>> +             }
>> +     }
>> +     input_dev->ir->raw.tail = i;
>> +     return count;
>> +}
>
> This looks like it violates the "one value per sysfs file" rule that we
> have.  What exactly are you outputting here?  It does not look like this
> belongs in sysfs at all.

It should be on a debug switch or maybe a debug device. If the rest of
the system is working right you shouldn't need this data.

>
>> +static ssize_t ir_raw_store(struct device *dev,
>> +                               struct device_attribute *attr,
>> +                               const char *buf,
>> +                               size_t count)
>> +{
>> +     struct ir_device *ir = to_input_dev(dev)->ir;
>> +     long delta;
>> +     int i = count;
>> +     int first = 0;
>> +
>> +     if (!ir->xmit)
>> +             return count;
>> +     ir->send.count = 0;
>> +
>> +     while (i > 0) {
>> +             i -= strict_strtoul(&buf[i], i, &delta);
>> +             while ((buf[i] != '\n') && (i > 0))
>> +                     i--;
>> +             i--;
>> +             /* skip leading zeros */
>> +             if ((delta > 0) && !first)
>> +                     continue;
>> +
>> +             ir->send.buffer[ir->send.count++] = abs(delta);
>> +     }
>> +
>> +     ir->xmit(ir->private, ir->send.buffer, ir->send.count, ir->raw.carrier, ir->raw.xmitter);
>> +
>> +     return count;
>> +}
>
> What type of data are you expecting here?  More than one value?
>
> thanks,
>
> greg k-h
>



-- 
Jon Smirl
jonsmirl@gmail.com
