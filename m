Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA09C282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 14:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1623E21872
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 14:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfBGOLo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:11:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:13521 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfBGOLo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 09:11:44 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2019 06:11:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,344,1544515200"; 
   d="scan'208";a="136637413"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga001.jf.intel.com with ESMTP; 07 Feb 2019 06:11:42 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 06A9B20389; Thu,  7 Feb 2019 16:11:40 +0200 (EET)
Date:   Thu, 7 Feb 2019 16:11:40 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 6/6] pxa_camera: fix smatch warning
Message-ID: <20190207141137.mgzm3cmj2wwlvq6z@paasikivi.fi.intel.com>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
 <20190207091338.55705-7-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207091338.55705-7-hverkuil-cisco@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 07, 2019 at 10:13:38AM +0100, Hans Verkuil wrote:
> drivers/media/platform/pxa_camera.c:2400 pxa_camera_probe() error: we previously assumed 'pcdev->pdata' could be null (see line 2397)
> 
> First check if platform data is provided, then check if DT data is provided,
> and if neither is provided just return with -ENODEV.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
