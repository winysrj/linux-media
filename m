Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:33212 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933883AbdDSLLf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 07:11:35 -0400
Subject: Re: [PATCH] [media] pixfmt-meta-vsp1-hgo.rst: remove spurious '-'
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
References: <242b0c4cc96f97d0a3b96343acd21613b63fa4a6.1492599862.git.mchehab@s-opensource.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <be8e2b69-8ec1-bab0-f934-5b201c1cd2fc@linux.intel.com>
Date: Wed, 19 Apr 2017 14:11:31 +0300
MIME-Version: 1.0
In-Reply-To: <242b0c4cc96f97d0a3b96343acd21613b63fa4a6.1492599862.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/19/17 14:04, Mauro Carvalho Chehab wrote:
> Remove spurious '-' in the VSP1 hgo table.
> 
> This resulted in a weird dot character that also caused
> the row to be double-height.
> 
> We used to have it on other tables, but we got rid of them
> on changeset 8ed29e302dd1 ("[media] subdev-formats.rst: remove
> spurious '-'").
> 
> Fixes: 14d665387165 ("[media] v4l: Define a pixel format for the R-Car VSP1 1-D histogram engine")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
