Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:1216 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933612AbcHaInP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 04:43:15 -0400
Received: from [10.47.79.81] ([10.47.79.81])
        (authenticated bits=0)
        by aer-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id u7V8h4ZL009349
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-media@vger.kernel.org>; Wed, 31 Aug 2016 08:43:06 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: RFC: V4L2_PIX_FMT_NV16: should it allow padding after each plane?
Message-ID: <57C69897.8010200@cisco.com>
Date: Wed, 31 Aug 2016 10:43:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The NV16 documentation allows for padding after each line:

https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-nv16.html

But I have one case where there is also padding after each plane.

Can we fold that into the existing NV16 format? I.e., in that case
the size of each plane is sizeimage / 2.

Or do I have to make a new NV16PAD format that allows such padding?

I am in favor of extending the NV16 specification since I believe it
makes sense, but I want to know what others think.

Regards,

	Hans
