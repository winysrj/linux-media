Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:35137 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdGMEvk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 00:51:40 -0400
Received: by mail-yw0-f169.google.com with SMTP id v193so18008605ywg.2
        for <linux-media@vger.kernel.org>; Wed, 12 Jul 2017 21:51:40 -0700 (PDT)
Received: from mail-yb0-f180.google.com (mail-yb0-f180.google.com. [209.85.213.180])
        by smtp.gmail.com with ESMTPSA id e190sm1677602ywa.13.2017.07.12.21.51.38
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2017 21:51:39 -0700 (PDT)
Received: by mail-yb0-f180.google.com with SMTP id n200so8700736ybg.2
        for <linux-media@vger.kernel.org>; Wed, 12 Jul 2017 21:51:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C193D76D23A22742993887E6D207B54D1ADD7EFB@ORSMSX106.amr.corp.intel.com>
References: <1499730214-9005-1-git-send-email-yong.zhi@intel.com>
 <1499730214-9005-4-git-send-email-yong.zhi@intel.com> <20170711103343.qynz4rps7fsx36bc@valkosipuli.retiisi.org.uk>
 <C193D76D23A22742993887E6D207B54D1ADD7EFB@ORSMSX106.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 13 Jul 2017 13:51:18 +0900
Message-ID: <CAAFQd5CKwWoiEZo9rBy1P3ioGJyScr8iG5iDpq_M+Wem6YAS9g@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] intel-ipu3: cio2: Add new MIPI-CSI2 driver
To: "Zhi, Yong" <yong.zhi@intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Vijaykumar, Ramya" <ramya.vijaykumar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Thu, Jul 13, 2017 at 8:20 AM, Zhi, Yong <yong.zhi@intel.com> wrote:
> Hi, Sakari,
>
> Thanks for the time spent on code review, acks to all the comments, excep=
t two places:
>
>> +/* .complete() is called after all subdevices have been located */
>> +static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
>> +{
>> +     struct cio2_device *cio2 =3D container_of(notifier, struct cio2_de=
vice,
>> +                                             notifier);
>> +     struct sensor_async_subdev *s_asd;
>> +     struct fwnode_handle *fwn_remote, *fwn_endpt, *fwn_remote_endpt;
>> +     struct cio2_queue *q;
>> +     struct fwnode_endpoint remote_endpt;
>> +     unsigned int i, pad;
>> +     int ret;
>> +
>> +     for (i =3D 0; i < notifier->num_subdevs; i++) {
>> +             s_asd =3D container_of(cio2->notifier.subdevs[i],
>> +                                     struct sensor_async_subdev,
>> +                                     asd);
>> +
>> +             fwn_remote =3D s_asd->asd.match.fwnode.fwnode;
>> +             fwn_endpt =3D (struct fwnode_handle *)
>> +                                     s_asd->vfwn_endpt.base.local_fwnod=
e;
>
> Why do you need a cast?
>
> [YZ] With a cast results in compilation warning:

(I think you mean "without".)

>
> drivers/media/pci/ipu3/ipu3-cio2.c:1298:13: warning: assignment discards =
=E2=80=98const=E2=80=99 qualifier from pointer target type [-Wdiscarded-qua=
lifiers]
>    fwn_endpt =3D /*(struct fwnode_handle *)*/

This is a sign that the code is doing something wrong (in this case
probably trying to write to a const pointer), so casting just silences
the unfixed error.

>
>> +     ret =3D v4l2_async_notifier_register(&cio2->v4l2_dev, &cio2->notif=
ier);
>> +     if (ret) {
>> +             cio2->notifier.num_subdevs =3D 0;
>
> No need to assign num_subdevs as 0.
>
> [YZ] _notifier_exit() will call _unregister() if this is not 0.

You shouldn't call _exit() if _init() failed. I noticed that many
error paths in your code does this. Please fix it.

Best regards,
Tomasz
