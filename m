Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:53046 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3FGKaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 06:30:52 -0400
Received: by mail-vc0-f173.google.com with SMTP id ht11so2650360vcb.4
        for <linux-media@vger.kernel.org>; Fri, 07 Jun 2013 03:30:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK9yfHyaAAxg7b0HocGCAQEGSF0iH8JJhMp4mbw=Rx1_z8fchQ@mail.gmail.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-6-git-send-email-arun.kk@samsung.com>
	<CAK9yfHyaAAxg7b0HocGCAQEGSF0iH8JJhMp4mbw=Rx1_z8fchQ@mail.gmail.com>
Date: Fri, 7 Jun 2013 16:00:51 +0530
Message-ID: <CALt3h7-Ejyii1_-ym9UwFRjAFEBb=Nu=2bmbemHAaRnfOqpaPw@mail.gmail.com>
Subject: Re: [RFC v2 05/10] exynos5-fimc-is: Adds the sensor subdev
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

>> +               if (ret < 0) {
>> +                       pr_err("Pipeline already opened.\n");
>> +                       return -EBUSY;
>
> why not propogate 'ret'? Same for other instances below.
>

Yes it can be done. Will change it.

Regards
Arun
