Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A857CC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 14:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7868F21738
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 14:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfA1Olm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 09:41:42 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:49578 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbfA1Oll (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 09:41:41 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id o86Rgt90nRO5Zo86UgKY7B; Mon, 28 Jan 2019 15:41:40 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Yunfei Dong <yunfei.dong@mediatek.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] mtk-vcodec clock patches
Message-ID: <480e3f0f-32bd-a7ec-7a03-d28590a5c25e@xs4all.nl>
Date:   Mon, 28 Jan 2019 15:41:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGCu/jgJZd4svjFcU06Z4GV8TQw3FM0BMqapsxMZadyuQtxzhI7EzJ1vFiCPs3gshAGKGg4ytad6kotwBgABURunQ9MTWZd5BwahDw62w/2CizvvmyGT
 t4o8P3qWu17HEAiz7VCbZjreS8X/QH5CuMyDXWy+N8Mmjiq0zUeyNKkGXHkd66oCyv7V/FFNcEWHXLxFPaoHxCSfjDGyvHM2y3/ORCkmw0YtKbpFJAS0+QoV
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Yunfei Dong,

I assume another subsystem will take care of the dts changes? (patch 2/3)

Regards,

	Hans

The following changes since commit c9d06df612977a88c484668ad0a37bc8e4463b22:

  media: vicodec: get_next_header is static (2019-01-26 09:12:59 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1j

for you to fetch changes up to 8e4cf182a687719be135ae7acad20bdecd09411b:

  media: mtk-vcodec: Using common interface to manage vdec/venc clock (2019-01-28 15:26:04 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Yunfei Dong (2):
      media: dt-bindings: media: add 'assigned-clocks' to vcodec examples
      media: mtk-vcodec: Using common interface to manage vdec/venc clock

 Documentation/devicetree/bindings/media/mediatek-vcodec.txt |  13 ++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c       | 163 +++++++++++++---------------------------
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h          |  31 +++++---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c       | 104 ++++++++++++++-----------
 4 files changed, 145 insertions(+), 166 deletions(-)
