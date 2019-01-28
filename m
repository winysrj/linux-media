Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F69DC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 13:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9E9C2171F
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 13:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfA1NDd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 08:03:33 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49728 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726611AbfA1NDd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 08:03:33 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id o6ZUgsIT2RO5Zo6ZXgK74V; Mon, 28 Jan 2019 14:03:31 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v5.0] imx: Stop stream before disabling IDMA channels
Message-ID: <fe075300-df19-bece-919a-72936a787788@xs4all.nl>
Date:   Mon, 28 Jan 2019 14:03:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIkbgf9twlGBFu0k/Knw7U9DB52XbWGeySUBr1Wwio86MyOBOXd17wcIip8A3tAqD+2IrjXRXCIB4T61wk92eag5JJQED0T0HCxGJDXBUCWS1faMOMF5
 S133BHwBIGLvgAKkrx7UmMA/ak1ZfOmrdsMf2ckvKSQvz/tULLIiq066OFpVrMza5q2IuaOm/8BeM4tWCLTYfpguY8L/U2C9pCI=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit c9d06df612977a88c484668ad0a37bc8e4463b22:

  media: vicodec: get_next_header is static (2019-01-26 09:12:59 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.0d

for you to fetch changes up to 596a639f7b7745ea1d8493c2772d5f2b7b90dad6:

  media: imx: prpencvf: Stop upstream before disabling IDMA channel (2019-01-28 13:41:33 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Steve Longerbeam (3):
      media: imx: csi: Disable CSI immediately after last EOF
      media: imx: csi: Stop upstream before disabling IDMA channel
      media: imx: prpencvf: Stop upstream before disabling IDMA channel

 drivers/staging/media/imx/imx-ic-prpencvf.c | 26 +++++++++++++++++---------
 drivers/staging/media/imx/imx-media-csi.c   | 42 +++++++++++++++++++++++++++---------------
 2 files changed, 44 insertions(+), 24 deletions(-)
