Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E55C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F37C321872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfAXJdy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 04:33:54 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39158 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfAXJdy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 04:33:54 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id 4D2E02608AC
Subject: Re: Test results (v4l2) for media/master -
 v4.20-rc5-281-gd2b4387f3bdf
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        ezequiel@collabora.com
Cc:     linux-media@vger.kernel.org, kernel@collabora.com
References: <5c1912cb.1c69fb81.6be62.391b@mx.google.com>
 <20181218155231.3b3b6d8b@coco.lan>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <7c16e639-2535-b5c9-6948-ffce616f6c69@collabora.com>
Date:   Thu, 24 Jan 2019 09:33:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20181218155231.3b3b6d8b@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Thanks for the review.  We've made some progress but I would like
to check things with you before putting this in production,
please see below.

On 18/12/2018 17:52, Mauro Carvalho Chehab wrote:
> Em Tue, 18 Dec 2018 07:31:23 -0800 (PST)
> "kernelci.org bot" <bot@kernelci.org> escreveu:
> 
>> Test results for:
>>   Tree:    media
>>   Branch:  master
>>   Kernel:  v4.20-rc5-281-gd2b4387f3bdf
>>   URL:     https://git.linuxtv.org/media_tree.git
>>   Commit:  d2b4387f3bdf016e266d23cf657465f557721488
>>   Test plans: v4l2
>>
>> Summary
>> -------
>> 4 test groups results
>>
>> 1  | v4l2       | rk3399-gru-kevin       | arm64 |  49 total:  17 PASS   6 FAIL  26 SKIP
>> 2  | v4l2       | rk3288-veyron-jaq      | arm   |  49 total:  17 PASS   6 FAIL  26 SKIP
>> 3  | v4l2       | qemu                   | arm64 | 115 total:  77 PASS   7 FAIL  31 SKIP
>> 4  | v4l2       | qemu                   | arm   | 115 total:  77 PASS   7 FAIL  31 SKIP
> 
> Please add, at linuxtv.org's wiki page, what each test actually means...

I've now added an explanation with a link to the wiki:

"""
V4L2 Compliance on the uvcvideo driver.

This test ran "v4l2-compliance -s" from v4l-utils:

    https://www.linuxtv.org/wiki/index.php/V4l2-utils

See each detailed section in the report below to find out the git URL and
particular revision that was used to build the test binaries.
"""

Is this the kind of information you would expect to see here?

>> ---
>> 1  | v4l2       | rk3399-gru-kevin       | arm64 |  49 total:  17 PASS   6 FAIL  26 SKIP
>>
>>   Config:      defconfig
>>   Lab Name:    lab-collabora
>>   Date:        2018-12-14 19:51:24.841000
>>   TXT log:     https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2b4387f3bdf/arm64/defconfig/lab-collabora/v4l2-rk3399-gru-kevin.txt
>>   HTML log:    https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2b4387f3bdf/arm64/defconfig/lab-collabora/v4l2-rk3399-gru-kevin.html
>>   Rootfs:      http://storage.kernelci.org/images/rootfs/debian/stretch-v4l2/20181207.0/arm64/rootfs.cpio.gz
>>   Test Git:    git://linuxtv.org/v4l-utils.git
>>   Test Commit: 7a118f166609c0d05c6447cc79484af37875d6fc
>>
>>
>>     Output-ioctls - 5 tests: 0  PASS, 0 FAIL, 5 SKIP
>>   
>>     Buffer-ioctls-Input-0 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
>>       * Requests: FAIL
>>   
>>     Required-ioctls - 2 tests: 2  PASS, 0 FAIL, 0 SKIP
>>   
>>     Input/Output-configuration-ioctls - 4 tests: 0  PASS, 0 FAIL, 4 SKIP
>>   
>>     Control-ioctls-Input-0 - 6 tests: 3  PASS, 2 FAIL, 1 SKIP
>>       * VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
>>       * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: FAIL
> 
> ... for example, in this specific case, I have no idea what driver 
> failed. Ok, one could open the log txt file, look on it and
> discover that this specific test was against the uvcvideo driver,
> but it is doubtful to expect that everybody would do that.

Each test is now run on a per-driver basis, on relevant
platforms.  So there's vivid on QEMU and uvcvideo on a couple of
real hardware devices as shown in this example summary:

1  | rk3288-veyron-jaq      | arm   |  51 total:  17 PASS   8 FAIL  26 SKIP
2  | rk3399-gru-kevin       | arm64 |  51 total:  17 PASS   8 FAIL  26 SKIP

The driver name is mentioned in the email subject and at the top
of the report.  The test first looks for a /dev/video* device
corresponding to the requested driver, and then passes that on to
the v4l2-compliance test suite as an argument.

> The best would be to also c/c the developer of the specific
> driver, if listed at MAINTAINERS, as he is the one that should
> come up with a fix.

Sure, it's easy to add the maintainers to the recipients for each
type of report (i.e. Hans for vivid and Laurent for uvcvideo, and
you for both) in addition to the linux-media list.

> I also think that the patch subject should be changed to reflect the
> actual problems that was got, e. g., something like:
> 
> [KernelCI] v4l2-compliance: uvcvideo: 6 failures, driver_foo: 8 failures

The email subject has been changed to look more like other
KernelCI reports and take your suggestion into account.  For this
particular test report, it would now look like this:

media/master v4l2-compliance on uvcvideo: 102 tests, 0 regressions (v4.20-rc5-281-gd2b4387f3bdf)

There also would be another separate one with results for vivid.

Other mailing lists are receiving similar reports without a
[KernelCI] tag or anything, but it's easy to filter them based on
the sender as it's always "kernelci.org bot" <bot@kernelci.org>.

>>     Codec-ioctls-Input-0 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
>>   
>>     Debug-ioctls - 2 tests: 0  PASS, 0 FAIL, 2 SKIP
>>   
>>     Format-ioctls-Input-0 - 10 tests: 4  PASS, 1 FAIL, 5 SKIP
>>       * VIDIOC_G/S_PARM: FAIL
>>   
>>     Streaming-ioctls_Test-input-0 - 4 tests: 1  PASS, 2 FAIL, 1 SKIP
>>       * USERPTR: FAIL
>>       * MMAP: FAIL

[...]

> Again, I would simplify the report, printing only a summary of the
> failures. You can store a less summarized report at the KernelCI
> storage server.

The report now only shows failures and regression information (as
in the example below).  There are links to see the full console
log of the test run, which helps but I think it would be good to
also have a separate log file with just the full test output.


Please let us know if you're happy with this or if it needs
further changes before enabling the automated reports again.

Best wishes,
Guillaume

> Thanks,
> Mauro

Sample report from a test branch with a regression caused on
purpose:


----8<--------8<----


gtucker/kernelci-local v4l2-compliance on vivid: 102 tests, 4 regressions (kernelci-local-snapshot-016-6-g6fa02d2c8766)

Test results summary
--------------------

V4L2 Compliance on the vivid driver.

This test ran "v4l2-compliance -s" from v4l-utils:

    https://www.linuxtv.org/wiki/index.php/V4l2-utils

See each detailed section in the report below to find out the git URL and
particular revision that was used to build the test binaries.


  Tree:    gtucker
  Branch:  kernelci-local
  Kernel:  kernelci-local-snapshot-016-6-g6fa02d2c8766
  URL:     https://gitlab.collabora.com/gtucker/linux.git
  Commit:  6fa02d2c87664d7bc19de3ea7b288bfba7d36644


1  | qemu                   | arm64 |  51 total:  29 PASS   4 FAIL  18 SKIP
2  | qemu                   | arm   |  51 total:  29 PASS   4 FAIL  18 SKIP


Test failures
-------------  

1  | qemu                   | arm64 |  51 total:  29 PASS   4 FAIL  18 SKIP

  Config:      defconfig+virtualvideo
  Lab Name:    lab-collabora-dev
  Plain log:   http://staging-storage.kernelci.org/gtucker/kernelci-local/kernelci-local-snapshot-016-6-g6fa02d2c8766/arm64/defconfig+virtualvideo/lab-collabora-dev/v4l2-compliance-vivid-qemu.txt
  HTML log:    http://staging-storage.kernelci.org/gtucker/kernelci-local/kernelci-local-snapshot-016-6-g6fa02d2c8766/arm64/defconfig+virtualvideo/lab-collabora-dev/v4l2-compliance-vivid-qemu.html
  Rootfs:      http://staging-storage.kernelci.org/images/rootfs/debian/stretch-v4l2/20190117.0/arm64/rootfs.cpio.gz
  Test Git:    git://linuxtv.org/v4l-utils.git
  Test Commit: 6de7a0df7e8c06af36ed609d87649e704279ea2d
      

    Buffer-ioctls-Input-0 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
      * Requests: never passed       

    Input-ioctls - 15 tests: 3  PASS, 3 FAIL, 9 SKIP
      * VIDIOC_G/S_AUDOUT: never passed
      * VIDIOC_G/S/ENUMINPUT: new failure (last pass: kernelci-local-snapshot-016-5-gcec25f749cfa)
      * VIDIOC_ENUMAUDIO: new failure (last pass: kernelci-local-snapshot-016-5-gcec25f749cfa)             
  

2  | qemu                   | arm   |  51 total:  29 PASS   4 FAIL  18 SKIP

  Config:      multi_v7_defconfig+virtualvideo
  Lab Name:    lab-collabora-dev
  Plain log:   http://staging-storage.kernelci.org/gtucker/kernelci-local/kernelci-local-snapshot-016-6-g6fa02d2c8766/arm/multi_v7_defconfig+virtualvideo/lab-collabora-dev/v4l2-compliance-vivid-qemu.txt
  HTML log:    http://staging-storage.kernelci.org/gtucker/kernelci-local/kernelci-local-snapshot-016-6-g6fa02d2c8766/arm/multi_v7_defconfig+virtualvideo/lab-collabora-dev/v4l2-compliance-vivid-qemu.html
  Rootfs:      http://staging-storage.kernelci.org/images/rootfs/debian/stretch-v4l2/20190117.0/armhf/rootfs.cpio.gz
  Test Git:    git://linuxtv.org/v4l-utils.git
  Test Commit: 6de7a0df7e8c06af36ed609d87649e704279ea2d
      

    Buffer-ioctls-Input-0 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
      * Requests: never passed       

    Input-ioctls - 15 tests: 3  PASS, 3 FAIL, 9 SKIP
      * VIDIOC_G/S_AUDOUT: never passed
      * VIDIOC_G/S/ENUMINPUT: new failure (last pass: kernelci-local-snapshot-016-5-gcec25f749cfa)
      * VIDIOC_ENUMAUDIO: new failure (last pass: kernelci-local-snapshot-016-5-gcec25f749cfa)             
 
