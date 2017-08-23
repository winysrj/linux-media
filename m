Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:44289 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753985AbdHWPIx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 11:08:53 -0400
Subject: Re: [GIT PULL FOR v4.14] v2: More constify, some fixes
To: Hans Verkuil <hansverk@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <84bd1126-a313-6477-b79c-2896eec62db9@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b90ca238-78ca-2fc0-bece-2d809121e305@xs4all.nl>
Date: Wed, 23 Aug 2017 17:08:48 +0200
MIME-Version: 1.0
In-Reply-To: <84bd1126-a313-6477-b79c-2896eec62db9@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/17 16:48, Hans Verkuil wrote:
> Hi Mauro,
> 
> Some more constify stuff and some fixes. The vb2 patch required to fix a
> venus bug is the most interesting change here.
> 
> I tried the -p flag for this pull request. I'm not convinced how useful it
> is since it doesn't include the commit logs.
> 
> Regards,
> 
> 	Hans
> 
> Change since the v1 pull request (marked that as superseded):
> 
> Added fix "media: venus: venc: set correct resolution on compressed stream"
> (with a CC to stable for 4.13)

Oops, I meant: "venus: fix copy/paste error in return_buf_error".

The pull request is correct, my cover letter wasn't.

Regards,

	Hans
