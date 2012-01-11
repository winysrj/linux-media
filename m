Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39064 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667Ab2AKAd6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 19:33:58 -0500
References: <4F0C3D1B.2010904@gmail.com> <CALzAhNVo4Aar7YbF1f6BU7Fp9Uceb5Nq5-JSb2tP0aNYiEra6A@mail.gmail.com> <4F0CC81A.6010301@gmail.com> <CALzAhNWG9VM=QtEXzm_qJXdKnbP+5Q=ZPm+8jLtJObfV4+vfJg@mail.gmail.com>
In-Reply-To: <CALzAhNWG9VM=QtEXzm_qJXdKnbP+5Q=ZPm+8jLtJObfV4+vfJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx, cxd2820r and tda18271)
From: Andy Walls <awalls@md.metrocast.net>
Date: Tue, 10 Jan 2012 19:34:05 -0500
To: Steven Toth <stoth@kernellabs.com>,
	Jim Darby <uberscubajim@gmail.com>
CC: linux-media@vger.kernel.org
Message-ID: <ce9f1cb9-02bb-496b-bba6-460e45eb2885@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steven Toth <stoth@kernellabs.com> wrote:

>> status SCVYL | signal ffff | snr 00ee | ber 00000000 | unc 00000000 |
>> FE_HAS_LOCK
>> status SCVYL | signal ffff | snr 00f0 | ber 00000000 | unc 00000000 |
>> FE_HAS_LOCK
>>
>> and when it stopped working, this time an hour later, nothing had
>changed.
>> In fact, it looks like the driver keeps lock even when it's not
>recording at
>> all.
>>
>> Any ideas anyone? Looks like the tuner is OK....
>
>It sounds signal, hardware or heat/environmental related, unlikely to
>be driver related.
>
>-- 
>Steven Toth - Kernel Labs
>http://www.kernellabs.com
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Any chance that transfer buffers are being slowly dropped out of rotation?

That would explain captures stopping after a variable amount of time.  (Early cx18 driver versions had that problem.)

Regards,
Andy


