Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:33064 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729257AbeI1RxI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 13:53:08 -0400
Subject: Re: [PATCH v3 0/2] media: platform: Add Aspeed Video Engine Driver
To: Eddie James <eajames@linux.vnet.ibm.com>,
        Eddie James <eajames@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <1537903629-14003-1-git-send-email-eajames@linux.ibm.com>
 <337a1869-4c16-edb0-976e-755f786afb01@xs4all.nl>
 <f033e988-e46f-b232-8ea5-a287cd48ef84@linux.vnet.ibm.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <057866e9-5d37-f2db-86a3-aa726b23dad2@xs4all.nl>
Date: Fri, 28 Sep 2018 13:29:44 +0200
MIME-Version: 1.0
In-Reply-To: <f033e988-e46f-b232-8ea5-a287cd48ef84@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/2018 08:05 PM, Eddie James wrote:
> 
> 
> On 09/26/2018 07:03 AM, Hans Verkuil wrote:
>> On 09/25/2018 09:27 PM, Eddie James wrote:
>>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>>> can capture and compress video data from digital or analog sources. With
>>> the Aspeed chip acting as a service processor, the Video Engine can
>>> capture the host processor graphics output.
>>>
>>> This series adds a V4L2 driver for the VE, providing the usual V4L2 streaming
>>> interface by way of videobuf2. Each frame, the driver triggers the hardware to
>>> capture the host graphics output and compress it to JPEG format.
>>>
>>> I was unable to cross compile v4l2-compliance for ARM with our OpenBMC
>>> toolchain. Although bootstrap, configure, and make were successful, no binaries
>>> were generated... I was able to build v4l-utils 1.12.3 from the OpenEmbedded
>>> project, with the output below:
>> You can also try to build it manually:
>>
>> g++ -o v4l2-compliance -DNO_LIBV4L2 v4l2-compliance.cpp v4l2-test-debug.cpp v4l2-test-input-output.cpp v4l2-test-controls.cpp v4l2-test-io-config.cpp v4l2-test-formats.cpp v4l2-test-buffers.cpp
>> v4l2-test-codecs.cpp v4l2-test-colors.cpp v4l2-test-media.cpp v4l2-test-subdevs.cpp media-info.cpp v4l2-info.cpp -I../.. -I../../include -I../common
>>
>> (replace g++ with your cross compiler)
>>
>> Hopefully that will work since 1.12.3 is way too old.
>>
>> Regards,
>>
>>     Hans
> 
> Yea I got it built. Still no SHA :( But this is with HEAD at commit 3874aa8eb1ff0c2e103d024ba5af915b1b26f098
> 
> FYI I am also patching out the JPEG thing I mentioned, so that the streaming test will run:
> diff --git a/utils/v4l2-compliance/v4l2-test-formats.cpp b/utils/v4l2-compliance
> index 02c2ce9..1f6eaa5 100644
> --- a/utils/v4l2-compliance/v4l2-test-formats.cpp
> +++ b/utils/v4l2-compliance/v4l2-test-formats.cpp
> @@ -330,7 +330,7 @@ static int testColorspace(__u32 pixelformat, __u32 colorspac
>         fail_on_test(!colorspace);
>         fail_on_test(colorspace == V4L2_COLORSPACE_BT878);
>         fail_on_test(pixelformat == V4L2_PIX_FMT_JPEG &&
> -                    colorspace != V4L2_COLORSPACE_JPEG);
> +                    colorspace != V4L2_COLORSPACE_SRGB);

I dropped this bogus test from v4l2-compliance. It doesn't make sense.

Regards,

	Hans
