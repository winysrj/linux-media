Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52517 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750721AbcIFHeE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 03:34:04 -0400
Subject: Re: [PATCH v6] [media] vimc: Virtual Media Controller core, capture
 and sensor
To: Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        jgebben@codeaurora.org, mchehab@osg.samsung.com
References: <ee909db9-eb2b-d81a-347a-fe12112aa1cf@xs4all.nl>
 <37dc3fa2c020c30f8ced9749f81394d585a37ec1.1473018878.git.helen.koike@collabora.com>
Cc: Helen Fornazier <helen.fornazier@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cd080d30-e0eb-a544-5512-0de634f1cf22@xs4all.nl>
Date: Tue, 6 Sep 2016 09:33:54 +0200
MIME-Version: 1.0
In-Reply-To: <37dc3fa2c020c30f8ced9749f81394d585a37ec1.1473018878.git.helen.koike@collabora.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/16 22:02, Helen Koike wrote:
> From: Helen Fornazier <helen.fornazier@gmail.com>
>
> First version of the Virtual Media Controller.
> Add a simple version of the core of the driver, the capture and
> sensor nodes in the topology, generating a grey image in a hardcoded
> format.
>
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>

One thing is missing: a MAINTAINERS entry. Can you make a separate patch
updating the MAINTAINERS file?

Thanks!

	Hans

