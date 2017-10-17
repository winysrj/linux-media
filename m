Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:51355 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932154AbdJQUw4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 16:52:56 -0400
Date: Tue, 17 Oct 2017 15:52:54 -0500
From: Rob Herring <robh@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] dt-bindings: media: xilinx: fix typo in example
Message-ID: <20171017205254.mdh5a4ndmntyreix@rob-hp-laptop>
References: <1507824214-17744-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507824214-17744-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 13, 2017 at 01:03:34AM +0900, Akinobu Mita wrote:
> Fix typo s/:/;/
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Hyun Kwon <hyun.kwon@xilinx.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Rob Herring <robh@kernel.org>
