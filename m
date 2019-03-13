Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5214CC43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 08:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 225692173C
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 08:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfCMIyk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 04:54:40 -0400
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:41022 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbfCMIyk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 04:54:40 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 3zejhiw2HLMwI3zemhDySq; Wed, 13 Mar 2019 09:54:37 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [STATUS UPDATE] test-media regression script status
Message-ID: <37927084-3fd6-51dc-9868-4c84cf034f38@xs4all.nl>
Date:   Wed, 13 Mar 2019 09:54:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPP6SBgcrag5yO21gzMHd+knG4LWQtEh5Wqs76NqGyZyhHJeyZV1YWwi7HLOyaBLSK2r8i+/a9a1KF3pCDRpiT2953DXCsnVsGS0CXgKVLjb5nLY1Wxm
 ODmMhGpINFCqbfHvmQau5FLlX3y5K1kXAr73Ohg7IovlqVHFyPPLkvNz4bfxlQOWOvjrFxGlMQ6RPMK4QfCNn7c5XW4qtvzIm/gd00eV/6QPkOBQ3Xli9tbh
 26Vt1IgILNQDp3jC+mtD4nbeKSwxIB09jqtzAiwXY7YZl2AVno7Xy5nPxbG5DzhuE0iiictBb2S8Tta0zXgHJi8qDFF9scXPgARsis/qM3kja6iVeI+gx8bl
 ZN2isZ/BoHVpVrjetMVajMmI8MSwnT4IeuSqmebMi/0bgPdwoANKh1BkXKuE5fBifSRqXmRm
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi all,

As you all know I have been working on creating a regression test script
to help catch regressions before they get into released kernels.

The test-media script is in v4l-utils, contrib/test. It is currently testing
with vivid, vim2m and vimc. Once vicodec is stable enough it will be added
to the test suite as well.

It is already run as part of the daily build using a kernel config with many
debug options enabled.

The daily build summary looks like this:

	virtme: OK: Final Summary: 1981, Succeeded: 1981, Failed: 0, Warnings: 14

	<snip>

	Detailed regression test results are available here:

	http://www.xs4all.nl/~hverkuil/logs/Wednesday-test-media.log
	http://www.xs4all.nl/~hverkuil/logs/Wednesday-test-media-dmesg.log

The daily build is currently only checking for failures in the compliance tests
and ignores warnings. It also ignores issues in the kernel log.

The main problems that I am trying to solve are kernel oopses (should be solved
once all my pending 5.2 pull requests are merged) and vivid warnings (12 of the
warnings are known and work is in progress to fix this, the remainder of the
warnings I need to look at and are likely caused by v4l2-compliance itself).

Note that there is one known remaining kernel oops when testing vimc, but resolving
that takes a lot more time (low-level media life-cycle issues) and the test has
been disabled for now in test-media.

The test can be run on a system (or VM) running the kernel you want to test with
by simply running it as root.

Usually for V4L2/MC changes it is enough to run it as:

sudo test-media mc

If you want the script to unload all media modules first, then add the -unload
option. If you want the script to scan for memory leaks (and the corresponding
debug option is enabled in the kernel), then add the -kmemleak option. To dump
the kernel log when done, add the -dmesg option.

Run test-media without options to see a help text.

Note that 'mc' is shorthand for 'vivid vim2m vimc'.

There are also cec compliance tests and the 'all' test which tests everything
(used in the daily build). The cec tests are slow (especially the cec-pwr tests),
so unless you changed something in the cec subsystem you want to avoid running
those.

The test script assumes that the very latest v4l-utils are installed.

The test can also be run using virtme. I made a virtme.sh script to run the tests.
It assumes that it is run from the top of the kernel tree. You can find the script
here: https://hverkuil.home.xs4all.nl/virtme/

The start of the script documents where to get virtme and how to install it.

This also contains a kernel config that enables various kernel debug options.

I strongly recommend that testing is done using virtme since this allows you
to enable many kernel debug options that you don't want to enable on the host.
Delayed kobject release is a particularly nasty debug option :-)

Note: running virtme when a VMWare instance is also running on the same host
does not work reliably. I don't know why exactly, but the only way I can use virtme
is from inside a VMWare linux guest. Unfortunately, I need to use VMWare Workstation,
so I'm stuck with it.

I hope that during the 5.2 development cycle we can fix the last remaining issues
and this can become part of the regular development process.

Future plans (besides adding vicodec support) is adding support for other drivers
like uvc and perhaps au0828 (for testing the upcoming Media Device Allocator API).
But those tests require real hardware to be connected, and there may be different
variants of the same hardware. We'll see how that will work out.

Regards,

	Hans
