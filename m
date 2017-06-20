Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48957
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750884AbdFTL76 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 07:59:58 -0400
Date: Tue, 20 Jun 2017 08:59:51 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [GIT PULL FOR v4.13] Add qcom venus driver
Message-ID: <20170620085951.11e5c8dd@vento.lan>
In-Reply-To: <9a84a004-ebdc-fba7-2cee-b91857788599@xs4all.nl>
References: <9a84a004-ebdc-fba7-2cee-b91857788599@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Jun 2017 10:19:46 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> Second attempt to add the venus driver.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit acec3630155763c170c7ae6508cf973355464508:
> 
>    [media] s3c-camif: fix arguments position in a function call (2017-06-13 14:21:24 -0300)
> 
> are available in the git repository at:
> 
>    git://linuxtv.org/hverkuil/media_tree.git venus
> 
> for you to fetch changes up to 3bf1c3aacb172db8fcbd25c62b042fc265c5a494:
> 
>    media: venus: enable building with COMPILE_TEST (2017-06-16 09:59:36 +0200)
> 
> ----------------------------------------------------------------
> Stanimir Varbanov (19):
>        media: v4l2-mem2mem: extend m2m APIs for more accurate buffer management
>        doc: DT: venus: binding document for Qualcomm video driver
>        MAINTAINERS: Add Qualcomm Venus video accelerator driver
>        media: venus: adding core part and helper functions
>        media: venus: vdec: add video decoder files
>        media: venus: venc: add video encoder files
>        media: venus: hfi: add Host Firmware Interface (HFI)
>        media: venus: hfi: add Venus HFI files
>        media: venus: enable building of Venus video driver
>        media: venus: hfi: fix mutex unlock
>        media: venus: hfi_cmds: fix variable dereferenced before check
>        media: venus: helpers: fix variable dereferenced before check
>        media: venus: hfi_venus: fix variable dereferenced before check
>        media: venus: hfi_msgs: fix set but not used variables
>        media: venus: vdec: fix compile error in vdec_close
>        media: venus: venc: fix compile error in venc_close
>        media: venus: vdec: add support for min buffers for capture
>        media: venus: update firmware path with linux-firmware place


>        media: venus: enable building with COMPILE_TEST

It is too early for this patch. I merged from 4.12-rc6, and it
still complains about those missing symbols:

WARNING: "qcom_scm_is_available" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!
WARNING: "qcom_scm_pas_shutdown" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!
WARNING: "qcom_scm_set_remote_state" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!

Probably, some patch is needed somewhere to replace those functions
by stubs if not the right arch, in order to make it build with
COMPILE_TEST.

For now, I'm excluding this patch on today's pull.


Thanks,
Mauro
