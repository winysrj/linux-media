Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:36076 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdE2Hfw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 03:35:52 -0400
Received: by mail-yw0-f174.google.com with SMTP id b68so25381970ywe.3
        for <linux-media@vger.kernel.org>; Mon, 29 May 2017 00:35:51 -0700 (PDT)
Received: from mail-yb0-f182.google.com (mail-yb0-f182.google.com. [209.85.213.182])
        by smtp.gmail.com with ESMTPSA id q20sm4504607ywa.70.2017.05.29.00.35.50
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 May 2017 00:35:50 -0700 (PDT)
Received: by mail-yb0-f182.google.com with SMTP id 187so12948233ybg.0
        for <linux-media@vger.kernel.org>; Mon, 29 May 2017 00:35:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7A4F467111FEF64486F40DFE7DF3500A03EB248E@ORSMSX111.amr.corp.intel.com>
References: <1495844847-21655-1-git-send-email-hyungwoo.yang@intel.com>
 <20170527203053.GY29527@valkosipuli.retiisi.org.uk> <7A4F467111FEF64486F40DFE7DF3500A03EAF344@ORSMSX111.amr.corp.intel.com>
 <CAAFQd5Bd_KXeALAJxfOKwJecE0nZLmbPR2butXPmvrdnW=cW0A@mail.gmail.com> <7A4F467111FEF64486F40DFE7DF3500A03EB248E@ORSMSX111.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 29 May 2017 16:35:29 +0900
Message-ID: <CAAFQd5CrOe2yEf3hHObUR_H5oyWQi5PmcSSRmoyFFHBM66ySiQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] [media] i2c: add support for OV13858 sensor
To: "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hsu, Cedric" <cedric.hsu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 29, 2017 at 3:49 PM, Yang, Hyungwoo <hyungwoo.yang@intel.com> w=
rote:
>
> Hello Tomasz,
>
> Here's my comments.
>
> Thanks,
> Hyungwoo
>
> -----Original Message-----
>> From: Tomasz Figa [mailto:tfiga@chromium.org]
>> Sent: Sunday, May 28, 2017 7:56 PM
>> To: Yang, Hyungwoo <hyungwoo.yang@intel.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>; linux-media@vger.kernel.org; sak=
ari.ailus@linux.intel.com; Zheng, Jian Xu <jian.xu.zheng@intel.com>; Hsu, C=
edric <cedric.hsu@intel.com>
>> Subject: Re: [PATCH v3 1/1] [media] i2c: add support for OV13858 sensor
>>
>> Hi Hyungwoo,
>>
>> On Mon, May 29, 2017 at 8:26 AM, Yang, Hyungwoo <hyungwoo.yang@intel.com=
> wrote:
>> >
>> > Hi Sakari,
>> >
>> > Here's my comments.
>> >
>> > -Hyungwoo
>> >
>> >
>> > -----Original Message-----
>> >> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
>> >> Sent: Saturday, May 27, 2017 1:31 PM
>> >> To: Yang, Hyungwoo <hyungwoo.yang@intel.com>
>> >> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng,
>> >> Jian Xu <jian.xu.zheng@intel.com>; Hsu, Cedric
>> >> <cedric.hsu@intel.com>; tfiga@chromium.org
>> >> Subject: Re: [PATCH v3 1/1] [media] i2c: add support for OV13858
>> >> sensor
>> >>
>> >> Hi Hyungwoo,
>> >>
>> >> Thanks for the update. A few comments below.
>> >>
>> [snip]
>> >> > +/* Update VTS that meets expected vertical blanking */ static int
>> >> > +ov13858_update_vblank(struct ov13858 *ov13858,
>> >> > +                            struct v4l2_ctrl *ctrl) {
>> >> > +   return ov13858_write_reg(
>> >> > +                   ov13858, OV13858_REG_VTS,
>> >> > +                   OV13858_REG_VALUE_16BIT,
>> >> > +                   ov13858->cur_mode->height +
>> >> > +ov13858->vblank->val); }
>> >> > +
>> >> > +/* Update analog gain */
>> >> > +static int ov13858_update_analog_gain(struct ov13858 *ov13858,
>> >> > +                                 struct v4l2_ctrl *ctrl) {
>> >> > +   return ov13858_write_reg(ov13858, OV13858_REG_ANALOG_GAIN,
>> >> > +                            OV13858_REG_VALUE_16BIT, ctrl->val);
>> >>
>> >> I think I'd move what the four above functions do to ov13858_set_ctrl=
() unless they're used in more than one location.
>> >
>> > Why ? Personally I like this. Since there  wouldn't be any difference =
in generated machine code, I want to keep this if there's no strict rule on=
 this.
>>
>> Personally I wouldn't probably care about this, but I see one advantage =
of Sakari's suggestion.
>>
>> Namely, it improves code readability, because there is less indirection =
and the person reading ov13858_set_ctrl() instantly knows that all it does =
is directly writing the control value to hardware registers. Otherwise, wit=
h the indirection in current version, until you read ov13858_update_analog_=
gain() (or such), you don't know whether it does some extra processing, pow=
er management or whatnot.
>>
>> If ov13858_update_analog_gain() did more than just a simple register wri=
te, it would indeed make sense to separate it, as it's intuitive that a sep=
arate function means some more complicated work. (And vice versa, it's coun=
ter-intuitive to have a function that is only there to call a register acce=
ssor.)
>>
>
> This is my habit for people who doesn't have datasheet for h/w or people =
who doesn't need(want) to know about detail. Yeah, my habit is especially f=
or those h/w which have many bit-fields in a register and I believe this ki=
nd of separation helps these people. I know the registers in this sensor is=
 very much straightforward.

I still think it doesn't really add any value. If the code is
organized well, i.e. no forward declarations, callees always above
callers, then you can simply read the code from top to bottom and have
exactly the same understanding of it without having the datasheet,
because you can see what the code is supposed to do, in this case you
would get to ov13858_set_ctrl(), which is clear to be the function to
set a control, then to the switch construct and then to particular
switch case and at this point it's already clear that you want to set
analog gain or whatever given the V4L2_CID_* enum. So having a
function named in exactly the same way (ov13858_update_analog_gain())
is just redundant and actually takes the information about what's
going on inside away from the reader.

Best regards,
Tomasz
