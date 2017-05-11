Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:35384 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755045AbdEKIhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 04:37:31 -0400
Received: by mail-yw0-f181.google.com with SMTP id l135so9245439ywb.2
        for <linux-media@vger.kernel.org>; Thu, 11 May 2017 01:37:31 -0700 (PDT)
Received: from mail-yw0-f180.google.com (mail-yw0-f180.google.com. [209.85.161.180])
        by smtp.gmail.com with ESMTPSA id c128sm462856ywh.2.2017.05.11.01.37.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 May 2017 01:37:29 -0700 (PDT)
Received: by mail-yw0-f180.google.com with SMTP id 203so9319334ywe.0
        for <linux-media@vger.kernel.org>; Thu, 11 May 2017 01:37:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170511082441.GG3227@valkosipuli.retiisi.org.uk>
References: <1494478820-22199-1-git-send-email-rajmohan.mani@intel.com>
 <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
 <20170511075511.GF3227@valkosipuli.retiisi.org.uk> <CAAFQd5BH17YofrbaZa07UFTR_qV_h_KgskGJm0bXhuf3sM6huw@mail.gmail.com>
 <20170511082441.GG3227@valkosipuli.retiisi.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 11 May 2017 16:37:08 +0800
Message-ID: <CAAFQd5CdJ4-cg-2s85=8sR4y7o45ybUXcD4buHiOiRuvD=+nWQ@mail.gmail.com>
Subject: Re: [PATCH v4] dw9714: Initial driver for dw9714 VCM
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rajmohan Mani <rajmohan.mani@intel.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 11, 2017 at 4:24 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Tomasz,
>
> On Thu, May 11, 2017 at 04:02:35PM +0800, Tomasz Figa wrote:
>> Hi Sakari,
>>
>> On Thu, May 11, 2017 at 3:55 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> > Hi Tomasz,
>> >
>> > On Thu, May 11, 2017 at 02:30:31PM +0800, Tomasz Figa wrote:
>> > ...
>> >> > +
>> >> > +/*
>> >> > + * This function sets the vcm position, so it consumes least current
>> >> > + * The lens position is gradually moved in units of DW9714_CTRL_STEPS,
>> >> > + * to make the movements smoothly.
>> >> > + */
>> >> > +static int dw9714_vcm_suspend(struct device *dev)
>> >> > +{
>> >> > +       struct i2c_client *client = to_i2c_client(dev);
>> >> > +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> >> > +       struct dw9714_device *dw9714_dev = container_of(sd,
>> >> > +                                                       struct dw9714_device,
>> >> > +                                                       sd);
>> >> > +       int ret, val;
>> >> > +
>> >> > +       for (val = dw9714_dev->current_val & ~(DW9714_CTRL_STEPS - 1);
>> >> > +            val >= 0; val -= DW9714_CTRL_STEPS) {
>> >> > +               ret = dw9714_i2c_write(client,
>> >> > +                                      DW9714_VAL((u16) val, DW9714_DEFAULT_S));
>> >>
>> >> DW9714_VAL() already contains such cast. Anyway, I still think they
>> >> don't really give us anything and should be removed.
>> >>
>> >> > +               if (ret)
>> >> > +                       dev_err(dev, "%s I2C failure: %d", __func__, ret);
>> >>
>> >> I think we should just return an error code here and fail the suspend.
>> >
>> > The result from an error here is that the user would hear an audible click.
>> > I don't think it's worth failing system suspend. :-)
>> >
>>
>> Hmm, the result of an error here would be higher power consumption in
>> suspend (unless there is also some other mechanism that actually cuts
>> the power).  Moreover, if an error here happens it would rather mean
>
> On systems where power consumption matters the device would presumably be
> powered off (e.g. by ACPI).
>
>> that there is something wrong with hardware itself (or I2C driver) and
>> not bailing out here would make it easier to let the error go
>> unnoticed.
>
> I'm not sure an error here matters much. :-)
>
> The same function is also used as runtime_suspend(), in which case the
> result won't be cared much about to begin with.

After thinking a bit more, I realized that the error would be actually
noticeable in terms of the camera not focusing properly, so maybe
there is no reason to care too much here indeed.

>
> ...
>
>> >> > +/*
>> >> > + * This function sets the vcm position to the value set by the user
>> >> > + * through v4l2_ctrl_ops s_ctrl handler
>> >> > + * The lens position is gradually moved in units of DW9714_CTRL_STEPS,
>> >> > + * to make the movements smoothly.
>> >> > + */
>> >> > +static int dw9714_vcm_resume(struct device *dev)
>> >> > +{
>> >> > +       struct i2c_client *client = to_i2c_client(dev);
>> >> > +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> >> > +       struct dw9714_device *dw9714_dev = container_of(sd,
>> >> > +                                                       struct dw9714_device,
>> >> > +                                                       sd);
>> >> > +       int ret, val;
>> >> > +
>> >> > +       for (val = dw9714_dev->current_val % DW9714_CTRL_STEPS;
>> >> > +            val < dw9714_dev->current_val + DW9714_CTRL_STEPS - 1;
>> >> > +            val += DW9714_CTRL_STEPS) {
>> >> > +               ret = dw9714_i2c_write(client,
>> >> > +                                      DW9714_VAL((u16) val, DW9714_DEFAULT_S));
>> >>
>> >> Ditto.
>> >>
>> >> > +               if (ret)
>> >> > +                       dev_err(dev, "%s I2C failure: %d", __func__, ret);
>> >>
>> >> Ditto.
>> >>
>> >> > +               usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
>> >> > +       }
>> >> > +
>> >> > +       /* restore v4l2 control values */
>> >> > +       ret = v4l2_ctrl_handler_setup(&dw9714_dev->ctrls_vcm);
>> >> > +       return ret;
>> >>
>> >> Hmm, actually I believe v4l2_ctrl_handler_setup() will call .s_ctrl()
>> >> here and set the motor value again. If we just make .s_ctrl() do the
>> >> adjustment in steps properly, we can simplify the resume to simply
>> >> call v4l2_ctrl_handler_setup() alone.
>> >
>> > Or drop the v4l2_ctrl_handler_setup() here.
>> >
>> > The reason is that the driver uses direct drive method for the lens and is
>> > thus responsible for managing ringing compensation as well. Ringing
>> > compensation support could be added to the driver later on; I think another
>> > control will be needed to control the mode.
>>
>> Given that we already have some kind of ringing compensation in
>> suspend and resume, can't we just reuse this in control handler? On
>
> The way it's done here is unlikely to be helpful for the user space that
> needs to drive the lens to a new position as fast as possible. The code
> above is presumably enough to prevent the lens from hitting the mechanical
> stopper but I'd equally expect it to interfere badly with the user space
> trying to control the lens.

Okay, fair enough. I assume then it's not unsafe for the hardware to
allow userspace to control it over the full range and the worst thing
that can happen is getting some sound effects? (Rather than some
malicious userspace burning the motor or so.

Best regards,
Tomasz
